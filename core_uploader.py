#!/usr/bin/env python3
"""
Core Uploader - Upload entire directory structure to GitHub repository
Maps and uploads all files from /home/ava-core to a GitHub repo in a single operation.
"""

import os
import json
import base64
import requests
import shutil
from pathlib import Path
from typing import Dict, List, Tuple, Any
from datetime import datetime
import subprocess
import sys
import argparse


class CoreUploader:
    def __init__(self, repo_owner: str, repo_name: str, github_token: str, root_path: str = "/home/ava-core"):
        """
        Initialize the Core Uploader.
        
        Args:
            repo_owner: GitHub repository owner
            repo_name: GitHub repository name
            github_token: GitHub personal access token
            root_path: Root directory to upload
        """
        self.repo_owner = repo_owner
        self.repo_name = repo_name
        self.github_token = github_token
        self.root_path = root_path
        self.files_to_upload: List[Tuple[str, str]] = []
        self.upload_stats = {
            "total_files": 0,
            "total_folders": 0,
            "uploaded_files": 0,
            "failed_files": 0,
            "skipped_files": 0,
            "errors": []
        }
    
    def scan_directory(self) -> None:
        """Scan the root directory and collect all files."""
        print(f"Scanning {self.root_path}...")
        
        try:
            for root, dirs, files in os.walk(self.root_path):
                self.upload_stats["total_folders"] += len(dirs)
                
                for file in files:
                    file_path = os.path.join(root, file)
                    relative_path = os.path.relpath(file_path, self.root_path)
                    
                    self.files_to_upload.append((file_path, relative_path))
                    self.upload_stats["total_files"] += 1
        
        except Exception as e:
            self.upload_stats["errors"].append(f"Scan error: {e}")
            print(f"Error scanning directory: {e}")
    
    def read_file_content(self, file_path: str) -> Tuple[str, bool]:
        """
        Read file content and return as base64 encoded string.
        
        Args:
            file_path: Path to the file
            
        Returns:
            Tuple of (content, is_binary)
        """
        try:
            with open(file_path, 'rb') as f:
                content = f.read()
                # Try to decode as text
                try:
                    content.decode('utf-8')
                    return base64.b64encode(content).decode('utf-8'), False
                except UnicodeDecodeError:
                    # Binary file
                    return base64.b64encode(content).decode('utf-8'), True
        except Exception as e:
            raise Exception(f"Failed to read {file_path}: {e}")
    
    def create_file_via_api(self, file_path: str, relative_path: str, content: str, is_binary: bool) -> bool:
        """
        Create a file in GitHub via REST API.
        
        Args:
            file_path: Local file path
            relative_path: Relative path in repo
            content: Base64 encoded content
            is_binary: Whether file is binary
            
        Returns:
            True if successful, False otherwise
        """
        url = f"https://api.github.com/repos/{self.repo_owner}/{self.repo_name}/contents/{relative_path}"
        
        headers = {
            "Authorization": f"token {self.github_token}",
            "Accept": "application/vnd.github.v3+json"
        }
        
        data = {
            "message": f"Add {relative_path}",
            "content": content,
            "encoding": "base64"
        }
        
        try:
            response = requests.put(url, json=data, headers=headers, timeout=10)
            
            if response.status_code in [201, 200]:
                return True
            else:
                error_msg = f"Failed to upload {relative_path}: {response.status_code}"
                self.upload_stats["errors"].append(error_msg)
                return False
        
        except Exception as e:
            error_msg = f"Exception uploading {relative_path}: {e}"
            self.upload_stats["errors"].append(error_msg)
            return False
    
    def upload_all_files(self, batch_size: int = 10) -> None:
        """
        Upload all scanned files to GitHub via API.
        
        Args:
            batch_size: Number of files to process before progress update
        """
        print(f"\nUploading {len(self.files_to_upload)} files to {self.repo_owner}/{self.repo_name}...")
        
        for i, (file_path, relative_path) in enumerate(self.files_to_upload):
            try:
                # Check file size (skip if > 100MB)
                file_size = os.path.getsize(file_path)
                if file_size > 100 * 1024 * 1024:
                    print(f"⏭️  Skipping {relative_path} (too large: {file_size / 1024 / 1024:.1f}MB)")
                    self.upload_stats["skipped_files"] += 1
                    continue
                
                content, is_binary = self.read_file_content(file_path)
                
                if self.create_file_via_api(file_path, relative_path, content, is_binary):
                    self.upload_stats["uploaded_files"] += 1
                    if (i + 1) % batch_size == 0:
                        print(f"Progress: {i + 1}/{len(self.files_to_upload)} files uploaded")
                else:
                    self.upload_stats["failed_files"] += 1
            
            except Exception as e:
                print(f"❌ Error with {file_path}: {e}")
                self.upload_stats["failed_files"] += 1
    
    def upload_via_git_commands(self) -> None:
        """Alternative: Clone repo and push via git commands (faster for large uploads)."""
        print(f"\nUsing Git-based upload (faster for bulk operations)...")
        
        try:
            # Create temporary directory for cloning
            temp_dir = f"/tmp/github-{self.repo_name}-upload"
            
            # Remove old temp dir if exists
            if os.path.exists(temp_dir):
                shutil.rmtree(temp_dir)
            
            # Clone repository
            print(f"Cloning repository...")
            clone_url = f"https://{self.github_token}@github.com/{self.repo_owner}/{self.repo_name}.git"
            result = subprocess.run(["git", "clone", clone_url, temp_dir], capture_output=True, text=True)
            if result.returncode != 0:
                raise Exception(f"Clone failed: {result.stderr}")
            
            # Copy all files using shutil
            print(f"Copying files (this may take a while with 512k+ files)...")
            for item in os.listdir(self.root_path):
                src = os.path.join(self.root_path, item)
                dst = os.path.join(temp_dir, item)
                
                # Skip .git and other repo files
                if item.startswith('.git'):
                    continue
                
                try:
                    if os.path.isdir(src):
                        if os.path.exists(dst):
                            shutil.rmtree(dst)
                        shutil.copytree(src, dst, ignore=shutil.ignore_patterns('.git*'))
                    else:
                        shutil.copy2(src, dst)
                except Exception as e:
                    print(f"Warning: Could not copy {item}: {e}")
            
            # Configure git
            os.chdir(temp_dir)
            subprocess.run(["git", "config", "user.email", "uploader@ava-core.local"], capture_output=True)
            subprocess.run(["git", "config", "user.name", "Core Uploader"], capture_output=True)
            
            # Add and commit
            print(f"Adding files to git...")
            subprocess.run(["git", "add", "-A"], capture_output=True)
            
            print(f"Committing changes...")
            result = subprocess.run(
                ["git", "commit", "-m", f"Initial upload of ava-core directory ({self.upload_stats['total_files']} files)"],
                capture_output=True,
                text=True
            )
            
            if result.returncode == 0:
                # Push
                print(f"Pushing to GitHub (this may take several minutes)...")
                push_result = subprocess.run(["git", "push", "-u", "origin", "master"], capture_output=True, text=True)
                
                if push_result.returncode == 0:
                    self.upload_stats["uploaded_files"] = self.upload_stats["total_files"]
                    print("✓ Upload complete!")
                else:
                    raise Exception(f"Push failed: {push_result.stderr}")
            else:
                print(f"No changes or commit failed: {result.stderr}")
        
        except Exception as e:
            print(f"❌ Error during git upload: {e}")
            self.upload_stats["errors"].append(str(e))
    
    def generate_manifest(self, output_file: str = "MANIFEST.json") -> None:
        """Generate a manifest of all uploaded files."""
        manifest = {
            "generated": datetime.now().isoformat(),
            "source": self.root_path,
            "repository": f"{self.repo_owner}/{self.repo_name}",
            "statistics": self.upload_stats,
            "sample_files": [
                {
                    "local_path": fp,
                    "repo_path": rp,
                    "size": os.path.getsize(fp) if os.path.exists(fp) else 0
                }
                for fp, rp in self.files_to_upload[:100]
            ]
        }
        
        with open(output_file, 'w') as f:
            json.dump(manifest, f, indent=2)
        
        print(f"✓ Manifest saved to {output_file}")
    
    def print_summary(self) -> None:
        """Print upload summary."""
        print("\n" + "=" * 80)
        print("UPLOAD SUMMARY")
        print("=" * 80)
        print(f"Total Files Scanned:    {self.upload_stats['total_files']}")
        print(f"Total Folders Scanned:  {self.upload_stats['total_folders']}")
        print(f"Files Uploaded:         {self.upload_stats['uploaded_files']}")
        print(f"Files Failed:           {self.upload_stats['failed_files']}")
        print(f"Files Skipped:          {self.upload_stats['skipped_files']}")
        
        if self.upload_stats["errors"]:
            print(f"\nErrors ({len(self.upload_stats['errors'])}):")
            for error in self.upload_stats["errors"][:10]:
                print(f"  - {error}")
        
        print("=" * 80 + "\n")


def main():
    """Main function."""
    parser = argparse.ArgumentParser(description="Core Uploader - Upload directory to GitHub")
    parser.add_argument("--owner", required=True, help="GitHub repository owner")
    parser.add_argument("--repo", required=True, help="GitHub repository name")
    parser.add_argument("--token", required=True, help="GitHub personal access token")
    parser.add_argument("--path", default="/home/ava-core", help="Root directory to upload")
    parser.add_argument("--method", choices=["api", "git"], default="git", help="Upload method (api or git)")
    parser.add_argument("--manifest", action="store_true", help="Generate manifest file")
    
    args = parser.parse_args()
    
    uploader = CoreUploader(args.owner, args.repo, args.token, args.path)
    
    # Scan directory
    uploader.scan_directory()
    print(f"✓ Scanned: {uploader.upload_stats['total_files']} files, {uploader.upload_stats['total_folders']} folders\n")
    
    # Upload
    if args.method == "git":
        uploader.upload_via_git_commands()
    else:
        uploader.upload_all_files()
    
    # Generate manifest
    if args.manifest:
        uploader.generate_manifest()
    
    # Print summary
    uploader.print_summary()


if __name__ == "__main__":
    main()
