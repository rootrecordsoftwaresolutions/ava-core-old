
- `ava-desk/`
  GUI, launcher, Tkinter, desktop integration, Visual CLI

- `cloudflare/`
  Cloudflare tunnels, ingress, cloudflared, DNS, origin routing

- `ssh/`
  OpenSSH, remote access, keys, ports, authentication

- `cronologicals/`
  Scheduled jobs, recurring processing, SQLite jobs, aggregation,
  locking, missed runs, duplicate processing

- `python/`
  Python runtime behavior, packaging, imports, syntax/runtime differences,
  AST/code-generation issues

Create another category when an existing category does not fit.

## IMPORTANT DISTINCTION

Not every ordinary error needs to become a bug entry.

Document something when it is:

- Likely to recur
- Easy to misunderstand
- Caused by an incorrect architectural assumption
- Relevant to future debugging
- Relevant to automated agents modifying the system
- A non-obvious implementation constraint
- A discovery that could save substantial time later

## AUTOMATED CODE CHANGES

When an automated agent modifies AVA Core code and discovers that its
assumption about the codebase was wrong, document that discovery.

Especially document failures involving:

- Incorrect file locations
- Incorrect service assumptions
- Incorrect class/module boundaries
- Incorrect configuration locations
- Incorrect process ownership
- Incorrect launcher assumptions
- Incorrect API assumptions
- Incorrect filesystem assumptions

## SECURITY

NEVER place the following in this directory:

- Private SSH keys
- Passwords
- API keys
- Cloudflare tokens
- Authentication credentials
- Session cookies
- Private wallet keys
- Other secrets

Document the LOCATION and TYPE of a credential when useful, but never record
the credential itself.

## WEB DIRECTORY

This directory is intentionally stored under:

    /home/ava-core/context/common-bugs/

It is exposed through the AVA directory system and should therefore remain
human- and agent-readable.

Keep filenames descriptive and Markdown content clean enough to be browsed
through the directory web interface.

## FINAL RULE

Every debugging session should leave the system slightly smarter than it
was before.

If a discovery would have saved time had it been known at the beginning of
the investigation, it belongs here.
EOF

echo
echo "=== AGENTS CREATED ==="
ls -lh AGENTS.md
echo
echo "=== COMMON BUGS ==="
find . -type f | sort
cd /home/ava-core
echo "=== AVA CORE STRUCTURE ==="
find .   -type d   \( -name .git -o -name __pycache__ -o -name node_modules -o -name .cache -o -name .venv -o -name venv \) -prune   -o -type d -print   | sort | head -300
echo
echo "=== EXISTING AGENTS FILES ==="
find .   -type d   \( -name .git -o -name __pycache__ -o -name node_modules \) -prune   -o -name AGENTS.md -print   | sort
echo
echo "=== TOP-LEVEL ==="
find . -maxdepth 2 -type f   \( -name 'README*' -o -name 'package.json' -o -name 'pyproject.toml'      -o -name 'requirements*.txt' -o -name 'docker-compose*.yml'      -o -name 'Dockerfile' -o -name '*.service' \)   -print | sort
cd /home/ava-core
set -e
create_agents() {     local file="$1";     local content="$2";      if [ -e "$file" ]; then         echo "SKIP  $file";     else         printf '%s\n' "$content" > "$file";         echo "CREATE $file";     fi; }
create_agents "./AGENTS.md" '# AGENTS — AVA Core

## Purpose

This is the root operational guidance for the AVA Core system.

AVA Core is a real, running system. Treat the existing filesystem, services,
applications, configuration, databases, automation, and operational
conventions as authoritative.

## REQUIRED BEHAVIOR

Before modifying anything:

1. Inspect the actual files and directories involved.
2. Read applicable nested `AGENTS.md` files.
3. Check `/home/ava-core/context/common-bugs/` for known recurring issues.
4. Do not assume paths, service names, launchers, configuration locations,
   architectures, or process ownership.
5. Preserve working functionality unless the requested change explicitly
   requires otherwise.

When debugging or investigating:

- Prefer evidence over assumptions.
- Inspect actual processes, files, services, logs, and configuration.
- Reproduce failures where practical.
- Verify fixes rather than stopping at successful compilation.

When a reusable discovery is made:

- Update the relevant entry in `/home/ava-core/context/common-bugs/`.
- Add a new entry when the issue is genuinely new.
- Correct existing documentation when an earlier assumption was wrong.

## CODE CHANGES

Before modifying source:

- Inspect the relevant source.
- Make a timestamped backup when working on important operational files.
- Make the smallest safe change.
- Compile or syntax-check where applicable.
- Perform a runtime test when applicable.
- Verify the actual behavior.

Do not repeatedly patch based on guessed structure.

## PROJECT BOUNDARIES

Do not treat dependency caches, generated files, or third-party source as
AVA Core project code.

In particular, avoid creating or modifying project-level agent guidance
inside:

- `.cargo/registry/`
- `.cursor/plugins/cache/`
- `.codex/.tmp/`
- `node_modules/`
- `__pycache__/`
- `.venv/`
- `venv/`

unless explicitly required.

## CONTEXT

Persistent operational knowledge belongs under:

    /home/ava-core/context/

Recurring bugs and discoveries belong under:

    /home/ava-core/context/common-bugs/

Read and update that knowledge as part of debugging and development.

## NESTED AGENTS

Nested `AGENTS.md` files provide more specific instructions for their
directory and descendants.

When a nested file conflicts with this file, follow the more specific
instruction unless it violates a higher-level system requirement.

## SECURITY

Never place passwords, private keys, API keys, tokens, session cookies,
wallet secrets, or other credentials in source-control-style documentation.

Document credential locations/types when operationally useful, but never
record the secret itself.

## FINAL RULE

Every debugging, building, and development session should leave AVA Core
better understood than it was before.'
create_agents "./context/AGENTS.md" '# AGENTS — AVA Core Context

## Purpose

This directory contains persistent context and operational knowledge for
AVA Core.

Treat these files as system memory, not disposable notes.

## REQUIRED BEHAVIOR

Before making architectural or operational assumptions, inspect relevant
context here.

When debugging reveals reusable information:

1. Search existing context first.
2. Update an existing entry if appropriate.
3. Create a new entry when the discovery is genuinely new.
4. Preserve exact paths, commands, service names, and important evidence.
5. Never store secrets.

## Common Bugs

The recurring-bug knowledge base is:

    /home/ava-core/context/common-bugs/

Agents debugging AVA Core should check it before assuming a problem is new.

When a bug or implementation mistake is discovered, add the finding there
when it is likely to recur or would have saved time if known earlier.

## CONTENT QUALITY

Prefer:

- Exact paths
- Exact commands
- Actual error messages
- Actual architecture
- Detection procedures
- Successful fixes
- Verification procedures
- Prevention notes

Avoid vague or speculative documentation.'
create_agents "./operations/AGENTS.md" '# AGENTS — AVA Core Operations

## Purpose

This directory contains operational tools, services, automation, and system
management components for AVA Core.

## REQUIRED BEHAVIOR

Treat operational code as production-sensitive.

Before changing an operational component:

1. Inspect its current implementation.
2. Check relevant nested `AGENTS.md` files.
3. Check `/home/ava-core/context/common-bugs/`.
4. Identify dependencies, services, schedules, and callers.
5. Make a backup when appropriate.
6. Test the change directly.

Do not assume a service, path, process, or configuration location.

## VERIFICATION

For operational changes verify:

- Syntax/compile status
- Runtime behavior
- Relevant service/process state
- Logs where applicable
- Actual filesystem/configuration state

A successful compile is not considered a successful operational test by
itself.

## KNOWLEDGE

When debugging reveals a reusable operational discovery, document it under:

    /home/ava-core/context/common-bugs/

Do this during the investigation rather than waiting until later.'
create_agents "./operations/system-tools/AGENTS.md" '# AGENTS — AVA Core System Tools

## Purpose

System tools provide utilities used to operate, inspect, control, or monitor
AVA Core.

## REQUIRED BEHAVIOR

Before modifying a system tool:

- Inspect the complete relevant source.
- Determine how it is launched.
- Determine what services/processes it interacts with.
- Check its nested `AGENTS.md`.
- Check `/home/ava-core/context/common-bugs/`.
- Preserve existing behavior unless explicitly changing it.

## TESTING

Use the tool itself for runtime verification when practical.

For Python:

    python3 -m py_compile <file>

is only a syntax check.

Also perform an actual launch/runtime test when the tool supports it.

For GUI applications, direct execution should be tested before diagnosing
desktop-launcher problems.

## PATCHING

Automated patches must account for actual source structure.

Do not assume:

- class boundaries
- module launchers
- configuration paths
- service names
- filesystem locations

Use AST inspection for structural Python modifications when appropriate.

## BUG MEMORY

Record reusable discoveries in:

    /home/ava-core/context/common-bugs/

Especially document failures caused by incorrect assumptions.'
create_agents "./Web/AGENTS.md" '# AGENTS — AVA Core Web

## Purpose

This directory contains AVA Core web-facing infrastructure, applications,
assets, services, and related web tooling.

## REQUIRED BEHAVIOR

Before modifying web infrastructure:

1. Inspect the actual directory and deployment structure.
2. Read nested `AGENTS.md` files.
3. Check relevant context under `/home/ava-core/context/`.
4. Verify actual running services and configuration.
5. Do not assume Cloudflare, DNS, tunnel, origin, or deployment paths.

## CLOUDFLARE

Cloudflare configuration must be based on the actual installed binary,
process, configuration, and service state.

Do not assume:

    /etc/cloudflared/

or a system-wide `cloudflared` installation.

Inspect the actual environment before making changes.

## DEPLOYMENT

When debugging a web deployment, distinguish between:

- Source problem
- Local application problem
- Web server problem
- Tunnel problem
- DNS problem
- Browser/client problem
- Cache/CDN problem

Verify each layer rather than guessing.

## BUG MEMORY

Reusable deployment and infrastructure discoveries belong in:

    /home/ava-core/context/common-bugs/cloudflare/

or the appropriate common-bugs category.

Do not store credentials or tokens in documentation.'
create_agents "./.ava/AGENTS.md" '# AGENTS — AVA Internal State

## Purpose

`.ava` contains AVA-specific internal state, generated operational material,
or tooling state.

Treat its contents according to the specific purpose of each child
directory.

## REQUIRED BEHAVIOR

Inspect before modifying.

Do not delete or regenerate internal state merely because its purpose is not
immediately obvious.

Check relevant context documentation before changing operational behavior.

If an important discovery about `.ava` would help future debugging, document
it under:

    /home/ava-core/context/common-bugs/

Avoid storing secrets in documentation.'
create_agents "./.agents/AGENTS.md" '# AGENTS — AVA Agent Tooling

## Purpose

`.agents` contains agent tooling, skills, automation definitions, and
development-agent resources used by AVA Core.

## REQUIRED BEHAVIOR

Changes here can affect automated development behavior.

Before modifying an agent skill or automation:

1. Read the relevant skill files.
2. Inspect existing conventions.
3. Preserve unrelated tooling.
4. Test the resulting behavior where possible.
5. Document reusable failures or discoveries in
   `/home/ava-core/context/common-bugs/`.

## IMPORTANT

Do not confuse agent tooling with application source code.

Do not modify third-party caches or generated agent assets as a substitute
for changing the actual project configuration.

## SECURITY

Never place credentials, private keys, API tokens, or other secrets in agent
instructions.'
echo
echo "=== CREATED / EXISTING STRATEGIC AGENTS ==="
find     .     -path './.git' -prune -o     -path './.cargo' -prune -o     -path './.cursor' -prune -o     -path './.codex' -prune -o     -path '*/node_modules' -prune -o     -path '*/__pycache__' -prune -o     -path '*/.venv' -prune -o     -path '*/venv' -prune -o     -name AGENTS.md -print     | sort
echo
echo "=== DONE ==="
cd /home/ava-core
set -e
PUBLIC="/home/ava-core/Web/Ava-Directory"
REPO="Ava-Directory"
echo "=== 1. CHECK GITHUB AUTH ==="
gh auth status
cd /home/ava-core
set -e
PUBLIC="/home/ava-core/Web/Ava-Directory"
REPO="Ava-Directory"
echo "=== 1. CHECK GITHUB AUTH ==="
gh auth status
echo
echo "=== 2. CREATE PUBLIC STAGING DIRECTORY ==="
mkdir -p "$PUBLIC"
cd "$PUBLIC"
if [ ! -d .git ]; then     git init;     git branch -M main; fi
echo
echo "=== 3. PUBLIC EXPORT IGNORE RULES ==="
cat > .gitignore <<'EOF'
# ============================================================
# AVA DIRECTORY — PUBLIC EXPORT SAFETY
# ============================================================

# Secrets / environment
.env
.env.*
**/.env
**/.env.*
!.env.example
!.env.sample

# AI / agent private tooling and caches
.cursor/
**/.cursor/
.codex/
**/.codex/
.copilot/
**/.copilot/
.claude/
**/.claude/
.aider/
**/.aider/
.agents/
**/.agents/

# Runtime / local AI state
.ollama/
**/.ollama/
.ai/
**/.ai/

# Credentials / authentication
*.pem
*.key
*.p12
*.pfx
*.crt
*.cer
id_rsa
id_rsa.*
id_ed25519
id_ed25519.*
authorized_keys
known_hosts

# Tokens / credentials / secrets
*secret*
*secrets*
*credential*
*credentials*
*token*
*password*
*passwd*
*private-key*
*private_key*

# Databases / runtime state
*.db
*.sqlite
*.sqlite3
*.db-journal
*.db-wal
*.db-shm

# Logs
*.log
logs/
**/logs/

# Python
__pycache__/
**/__pycache__/
*.pyc
*.pyo
.venv/
**/.venv/
venv/
**/venv/

# Node
node_modules/
**/node_modules/
npm-debug.log*
yarn-debug.log*
pnpm-debug.log*

# Build/cache
.cache/
**/.cache/
dist/
build/
coverage/
.tmp/
tmp/

# OS/editor
.DS_Store
Thumbs.db
*.swp
*.swo
*~

# Git internals
.git/

# SSH / cloud credentials
.ssh/
**/.ssh/
.cloudflared/
**/.cloudflared/

# Cloudflare credential files
cert.pem
origin.pem
cloudflared.pem
tunnel*.json
credentials.json

# Backups
*.backup
*.backup_*
*.bak
*.old

# Private operational state
runtime/
state/
private/
secrets/
credentials/
EOF

echo
echo "=== 4. BUILD PUBLIC DIRECTORY ==="
# Clean previous export WITHOUT touching the git repository itself.
find "$PUBLIC" -mindepth 1 -maxdepth 1     ! -name ".git"     ! -name ".gitignore"     -exec rm -rf {} +
# ------------------------------------------------------------
# Explicitly export the intentional public/context material.
# ------------------------------------------------------------
mkdir -p "$PUBLIC/context"
mkdir -p "$PUBLIC/operations"
mkdir -p "$PUBLIC/Web"
# Context is intentionally public, subject to .gitignore.
if [ -d /home/ava-core/context ]; then     cp -a /home/ava-core/context/. "$PUBLIC/context/"; fi
# Operational documentation/context.
if [ -d /home/ava-core/operations ]; then     find /home/ava-core/operations         -type f         \( -name '*.md' -o -name '*.txt' -o -name '*.json.example'            -o -name '*.yml.example' -o -name '*.yaml.example' \)         -print0 |     while IFS= read -r -d '' f; do         rel="${f#/home/ava-core/operations/}";         mkdir -p "$PUBLIC/operations/$(dirname "$rel")";         cp "$f" "$PUBLIC/operations/$rel";     done; fi
# Web-facing documentation/assets only.
if [ -d /home/ava-core/Web ]; then     find /home/ava-core/Web         -type f         \( -name '*.md' -o -name '*.txt' -o -name '*.html'            -o -name '*.css' -o -name '*.js' -o -name '*.json'            -o -name '*.svg' \)         -not -path '*/node_modules/*'         -not -path '*/.cursor/*'         -not -path '*/.codex/*'         -not -path '*/.agents/*'         -not -path '*/.git/*'         -print0 |     while IFS= read -r -d '' f; do         rel="${f#/home/ava-core/Web/}";         mkdir -p "$PUBLIC/Web/$(dirname "$rel")";         cp "$f" "$PUBLIC/Web/$rel";     done; fi
echo
echo "=== 5. ADD PUBLIC REPO CONTROL FILES ==="
cat > "$PUBLIC/README.md" <<'EOF'
# Ava-Directory

Public operational directory and context mirror for AVA Core.

This repository contains intentionally published documentation, context,
architecture notes, operational knowledge, and web-facing material.

Private system state, credentials, databases, AI tooling, caches, and
machine-specific secrets are excluded.

The directory is automatically synchronized from AVA Core.
EOF

cat > "$PUBLIC/AGENTS.md" <<'EOF'
# AGENTS — Ava-Directory Public Repository

This repository is a PUBLIC export of selected AVA Core information.

## IMPORTANT

Never place secrets here.

Never publish:

- `.env` files
- API keys
- passwords
- private keys
- SSH credentials
- Cloudflare credentials
- wallet/private blockchain keys
- session tokens
- private databases
- private AI agent state
- `.cursor`
- `.codex`
- `.agents`
- private runtime state

## PURPOSE

This repository exists to make intentionally public AVA Core information
available through the AVA Directory.

Source material originates from:

    /home/ava-core/

The export process is intentionally selective.

## COMMON BUG MEMORY

Publicly appropriate reusable discoveries should remain synchronized with:

    /home/ava-core/context/common-bugs/

## RULE

If something should not be publicly visible, do not put it in this repo.
EOF

echo
echo "=== 6. FINAL SECRET-SAFETY FILTER ==="
# Remove anything matching dangerous names that slipped through the export.
find "$PUBLIC"     -type f     \(       -name '.env' -o       -name '.env.*' -o       -iname '*password*' -o       -iname '*passwd*' -o       -iname '*secret*' -o       -iname '*credential*' -o       -iname '*token*' -o       -name '*.pem' -o       -name '*.key' -o       -name '*.p12' -o       -name '*.pfx' -o       -name 'id_rsa*' -o       -name 'id_ed25519*' -o       -name 'authorized_keys' -o       -name 'cert.pem' -o       -name 'credentials.json'     \)     -print -delete
# Remove prohibited directories from the export.
find "$PUBLIC"     -type d     \(       -name '.cursor' -o       -name '.codex' -o       -name '.agents' -o       -name '.claude' -o       -name '.copilot' -o       -name '.aider' -o       -name 'node_modules' -o       -name '__pycache__' -o       -name '.venv' -o       -name 'venv' -o       -name '.cloudflared'     \)     -prune -print -exec rm -rf {} +
echo
echo "=== 7. SHOW PUBLIC EXPORT ==="
find "$PUBLIC"     -type f     -not -path '*/.git/*'     | sort
echo
echo "=== 8. CHECK FOR OBVIOUS SECRETS ==="
if grep -RIlE     --exclude-dir=.git     --exclude='*.png'     --exclude='*.jpg'     --exclude='*.gif'     --exclude='*.svg'     -e 'BEGIN .*PRIVATE KEY'     -e 'AWS_SECRET_ACCESS_KEY'     -e 'CF_API_TOKEN'     -e 'CLOUDFLARE_API_TOKEN'     -e 'PRIVATE_KEY='     -e 'PASSWORD='     -e 'API_KEY='     "$PUBLIC" 2>/dev/null; then     echo;     echo "echo "=== 8. CHECK FOR OBVIOUS SECRETS ==="! POSSIBLE SECRET FOUND — STOPPING echo "=== 8. CHECK FOR OBVIOUS SECRETS ==="!";     exit 1; fi
echo "No obvious secret patterns detected."
echo
echo "=== 9. GIT STATUS ==="
git add -A
git status --short
echo
echo "=== 10. INITIAL COMMIT ==="
if ! git diff --cached --quiet; then     git commit -m "Initial public AVA Directory"; else     echo "Nothing to commit."; fi
set -euo pipefail
HOME_DIR="/home/ava-core"
REPO_DIR="$HOME_DIR/Ava-Directory"
SYNC_SCRIPT="$HOME_DIR/operations/system-tools/sync-ava-directory.sh"
echo "=== AVA DIRECTORY — PUBLIC GITHUB SETUP ==="
# ------------------------------------------------------------
# 1. REQUIRE GITHUB CLI
# ------------------------------------------------------------
command -v gh >/dev/null 2>&1 || {     echo "ERROR: GitHub CLI (gh) is not installed.";     echo "Install it with:";     echo "  sudo apt install gh";     exit 1; }
gh auth status
# ------------------------------------------------------------
# 2. CREATE LOCAL REPOSITORY
# ------------------------------------------------------------
mkdir -p "$REPO_DIR"
cd "$REPO_DIR"
if [ ! -d .git ]; then     git init;     git branch -M main; fi
# ------------------------------------------------------------
# 3. PUBLIC REPOSITORY README
# ------------------------------------------------------------
cat > README.md <<'EOF'
# AVA Directory

Public-facing directory and operational documentation for AVA Core.

This repository is automatically synchronized from the AVA Core system.

## Important

This is a sanitized public export.

Private system state, credentials, secrets, AI tooling, caches,
development environments, and other non-public material are intentionally
excluded.

The authoritative AVA Core filesystem remains on the AVA Core machine.
EOF

# ------------------------------------------------------------
# 4. PUBLIC EXPORT RULES
# ------------------------------------------------------------
cat > .gitignore <<'EOF'
# ============================================================
# SECRETS
# ============================================================

.env
.env.*
*.env
*.pem
*.key
*.p12
*.pfx
*.crt
*.csr
id_rsa
id_rsa.*
id_ed25519
id_ed25519.*
*.secret
secrets/
credentials/
credentials.*
tokens/
wallets/

# ============================================================
# GIT / REPOSITORY INTERNALS
# ============================================================

.git/
.git/*
.github/

# ============================================================
# AI / AGENT / PRIVATE DEVELOPMENT TOOLING
# ============================================================

.cursor/
.codex/
.agents/
.claude/
.copilot/
.gemini/
.aider/
.windsurf/
.ai/
.ai-*
**/.cursor/
**/.codex/
**/.agents/
**/.claude/
**/.copilot/
**/.gemini/
**/.aider/
**/.windsurf/

# ============================================================
# LOCAL DEVELOPMENT / CACHE
# ============================================================

node_modules/
__pycache__/
*.pyc
*.pyo
.venv/
venv/
env/
.cache/
.npm/
.yarn/
.pytest_cache/
.mypy_cache/
.ruff_cache/
dist/
build/

# ============================================================
# RUST / LARGE DEPENDENCY CACHE
# ============================================================

.cargo/
**/.cargo/

# ============================================================
# DATABASES / RUNTIME STATE
# ============================================================

*.db
*.sqlite
*.sqlite3
*.db-shm
*.db-wal
*.log
logs/
runtime/
tmp/
temp/

# ============================================================
# OS / DESKTOP
# ============================================================

.DS_Store
Thumbs.db
*.swp
*.swo
*~

# ============================================================
# SSH
# ============================================================

.ssh/
**/.ssh/

# ============================================================
# CLOUD / PRIVATE CONFIG
# ============================================================

.cloudflared/
**/.cloudflared/

# ============================================================
# BACKUPS
# ============================================================

*.backup
*.bak
*.orig
*.old
EOF

# ------------------------------------------------------------
# 5. SANITIZED EXPORT SCRIPT
# ------------------------------------------------------------
mkdir -p "$(dirname "$SYNC_SCRIPT")"
cat > "$SYNC_SCRIPT" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

SOURCE="/home/ava-core"
DEST="/home/ava-core/Ava-Directory"

cd "$DEST"

echo "=== AVA DIRECTORY SYNC ==="
date

# ------------------------------------------------------------
# Export the public directory.
#
# IMPORTANT:
# This is intentionally an allow-by-exclusion model.
# Anything newly created under /home/ava-core could otherwise
# become public. Sensitive classes are therefore excluded here
# AND by .gitignore.
# ------------------------------------------------------------

rsync -a --delete \
    --exclude='.git/' \
    --exclude='.git' \
    --exclude='.cursor/' \
    --exclude='.codex/' \
    --exclude='.agents/' \
    --exclude='.claude/' \
    --exclude='.copilot/' \
    --exclude='.gemini/' \
    --exclude='.aider/' \
    --exclude='.windsurf/' \
    --exclude='.ai/' \
    --exclude='.ai-*/' \
    --exclude='.cargo/' \
    --exclude='**/.cursor/' \
    --exclude='**/.codex/' \
    --exclude='**/.agents/' \
    --exclude='**/.claude/' \
    --exclude='**/.copilot/' \
    --exclude='**/.gemini/' \
    --exclude='**/.aider/' \
    --exclude='**/.windsurf/' \
    --exclude='**/.ai/' \
    --exclude='**/.cargo/' \
    --exclude='node_modules/' \
    --exclude='**/node_modules/' \
    --exclude='__pycache__/' \
    --exclude='**/__pycache__/' \
    --exclude='.venv/' \
    --exclude='venv/' \
    --exclude='.cache/' \
    --exclude='**/.cache/' \
    --exclude='.npm/' \
    --exclude='.ssh/' \
    --exclude='**/.ssh/' \
    --exclude='.cloudflared/' \
    --exclude='**/.cloudflared/' \
    --exclude='.env' \
    --exclude='.env.*' \
    --exclude='*.env' \
    --exclude='*.pem' \
    --exclude='*.key' \
    --exclude='*.p12' \
    --exclude='*.pfx' \
    --exclude='*.secret' \
    --exclude='secrets/' \
    --exclude='credentials/' \
    --exclude='wallets/' \
    --exclude='tokens/' \
    --exclude='*.db' \
    --exclude='*.sqlite' \
    --exclude='*.sqlite3' \
    --exclude='*.db-shm' \
    --exclude='*.db-wal' \
    --exclude='*.log' \
    --exclude='logs/' \
    --exclude='runtime/' \
    --exclude='tmp/' \
    --exclude='temp/' \
    --exclude='dist/' \
    --exclude='build/' \
    --exclude='*.backup*' \
    --exclude='*.bak' \
    --exclude='*.orig' \
    --exclude='*.old' \
    --exclude='.DS_Store' \
    "$SOURCE/" "$DEST/"

# Never export the sync script itself.
rm -f "$DEST/operations/system-tools/sync-ava-directory.sh" 2>/dev/null || true

# Never export the repository's own Git metadata.
rm -rf "$DEST/.git" 2>/dev/null || true

# Recreate git metadata after rsync.
cd "$DEST"
git init -q
git branch -M main

# Make absolutely sure secret patterns are ignored.
git add -A

# ------------------------------------------------------------
# SECURITY CHECK
# ------------------------------------------------------------

if git diff --cached --name-only | grep -E \
    '(^|/)(\.env|\.env\.|\.cursor|\.codex|\.agents|\.ssh|\.cloudflared|secrets|credentials|wallets)(/|$)|(\.pem|\.key|\.p12|\.pfx)$' \
    >/tmp/ava-directory-security-failure 2>&1; then

    echo
    echo "!!! SECURITY CHECK FAILED !!!"
    cat /tmp/ava-directory-security-failure
    git reset -q
    exit 1
fi

rm -f /tmp/ava-directory-security-failure

# ------------------------------------------------------------
# COMMIT / PUSH
# ------------------------------------------------------------

if ! git diff --cached --quiet; then
    git commit -m "Automated AVA Directory update $(date '+%Y-%m-%d %H:%M:%S')"
fi

git push origin main

echo
echo "=== SYNC COMPLETE ==="
date
EOF

chmod +x "$SYNC_SCRIPT"
# ------------------------------------------------------------
# 6. CREATE PUBLIC GITHUB REPOSITORY
# ------------------------------------------------------------
cd "$REPO_DIR"
if ! git remote get-url origin >/dev/null 2>&1; then     echo "Creating public GitHub repository: Ava-Directory";      gh repo create Ava-Directory         --public         --description "Public AVA Core directory and operational documentation"         --source="$REPO_DIR"         --remote=origin; else     echo "GitHub remote already exists:";     git remote get-url origin; fi
# ------------------------------------------------------------
# 7. FIRST SANITIZED EXPORT
# ------------------------------------------------------------
"$SYNC_SCRIPT"
echo "=== AVA DIRECTORY STATUS ==="
cd /home/ava-core/Ava-Directory 2>/dev/null || true
git status --short
git remote -v 2>/dev/null || true
echo
echo "=== DIRECTORY INDEXER ==="
find /home/ava-core/operations -maxdepth 4   -type f \( -iname '*directory*' -o -iname '*index*' \)   -print 2>/dev/null | sort
echo
echo "=== DIRECTORY.TXT COUNT ==="
find /home/ava-core   -path '*/.git' -prune -o   -path '*/.cursor' -prune -o   -path '*/.codex' -prune -o   -path '*/.agents' -prune -o   -name DIRECTORY.txt -print 2>/dev/null | wc -l
echo
echo "=== CRON ==="
crontab -l 2>/dev/null | grep -Ei 'directory|ava' || true
set -euo pipefail
cd /home/ava-core/Ava-Directory
echo "=== RESETTING PUBLIC EXPORT ==="
# Remove everything from the local export except .git
find . -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
# Recreate clean public export from the actual AVA directory
rsync -a   --exclude='.git/'   --exclude='.cursor/'   --exclude='.codex/'   --exclude='.agents/'   --exclude='.claude/'   --exclude='.copilot/'   --exclude='.gemini/'   --exclude='.aider/'   --exclude='.windsurf/'   --exclude='.cargo/'   --exclude='node_modules/'   --exclude='__pycache__/'   --exclude='.venv/'   --exclude='venv/'   --exclude='.cache/'   --exclude='.npm/'   --exclude='.ssh/'   --exclude='.cloudflared/'   --exclude='.env'   --exclude='.env.*'   --exclude='*.env'   --exclude='*.pem'   --exclude='*.key'   --exclude='*.p12'   --exclude='*.pfx'   --exclude='*.secret'   --exclude='secrets/'   --exclude='credentials/'   --exclude='wallets/'   --exclude='tokens/'   --exclude='*.db'   --exclude='*.sqlite'   --exclude='*.sqlite3'   --exclude='*.db-shm'   --exclude='*.db-wal'   --exclude='*.log'   --exclude='logs/'   --exclude='runtime/'   --exclude='tmp/'   --exclude='temp/'   --exclude='dist/'   --exclude='build/'   /home/ava-core/   /home/ava-core/Ava-Directory/
cd /home/ava-core/Ava-Directory
echo "=== EXPORT REPO ==="
pwd
git status --short
git branch --show-current
git remote -v
echo
echo "=== CONTENT COUNT ==="
find . -type f -not -path './.git/*' | wc -l
echo
echo "=== PRIVATE MATERIAL CHECK ==="
find .   -not -path './.git/*'   \( -name '.env' -o -name '.env.*' -o -name '*.env'      -o -name '*.pem' -o -name '*.key' -o -name '*.p12' -o -name '*.pfx'      -o -name '*.secret' -o -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3'      -o -path '*/.cursor/*' -o -path '*/.codex/*' -o -path '*/.agents/*'      -o -path '*/.claude/*' -o -path '*/.copilot/*' -o -path '*/.gemini/*'      -o -path '*/.aider/*' -o -path '*/.windsurf/*'   \) -print
echo
echo "=== TOP LEVEL ==="
find . -mindepth 1 -maxdepth 1 -not -name .git -printf '%f\n' | sort | head -100
cd /home/ava-core
set -euo pipefail
EXPORT="/home/ava-core/Ava-Directory"
SOURCE="/home/ava-core"
echo "=== CLEANING PUBLIC EXPORT ==="
# Preserve the repository's .git directory.
find "$EXPORT" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
echo "=== COPYING SAFE AVA DIRECTORIES ==="
# ------------------------------------------------------------
# ONLY export known AVA/Core project directories and documents.
# ------------------------------------------------------------
rsync -a   "$SOURCE/AGENTS.md"   "$SOURCE/README.md"   "$SOURCE/README-CORE-CONTEXT"   "$EXPORT/"
rsync -a   "$SOURCE/context/"   "$EXPORT/context/"
rsync -a   "$SOURCE/operations/"   "$EXPORT/operations/"
rsync -a   "$SOURCE/Web/"   "$EXPORT/Web/"
rsync -a   "$SOURCE/.ava/"   "$EXPORT/.ava/"
# ------------------------------------------------------------
# Remove anything private/generated that may exist underneath
# exported directories.
# ------------------------------------------------------------
find "$EXPORT"   -type d   \(     -name .git     -o -name .cursor     -o -name .codex     -o -name .agents     -o -name .claude     -o -name .copilot     -o -name .gemini     -o -name .aider     -o -name .windsurf     -o -name .ai     -o -name node_modules     -o -name __pycache__     -o -name .venv     -o -name venv     -o -name .venvs     -o -name .cache     -o -name .npm     -o -name .cargo     -o -name .ssh     -o -name .cloudflared     -o -name Credentials     -o -name credentials     -o -name secrets     -o -name wallets     -o -name tokens     -o -name Database     -o -name databases     -o -name logs     -o -name runtime     -o -name tmp     -o -name temp     -o -name build     -o -name dist   \)   -prune -exec rm -rf {} +
find "$EXPORT"   -type f   \(     -name '.env'     -o -name '.env.*'     -o -name '*.env'     -o -name '*.pem'     -o -name '*.key'     -o -name '*.p12'     -o -name '*.pfx'     -o -name '*.secret'     -o -name '*.db'     -o -name '*.sqlite'     -o -name '*.sqlite3'     -o -name '*.db-shm'     -o -name '*.db-wal'     -o -name '*.log'     -o -name '*.bak'     -o -name '*.backup*'   \)   -delete
# Never allow the repository to recursively appear in itself.
rm -rf "$EXPORT/Ava-Directory"
# ------------------------------------------------------------
# Public repository .gitignore
# ------------------------------------------------------------
cat > "$EXPORT/.gitignore" <<'EOF'
# Secrets
.env
.env.*
*.env
*.pem
*.key
*.p12
*.pfx
*.secret

# Private directories
Credentials/
credentials/
secrets/
wallets/
tokens/
Database/
databases/

# AI / agent tooling
.cursor/
.codex/
.agents/
.claude/
.copilot/
.gemini/
.aider/
.windsurf/
.ai/

# Development caches
.cargo/
node_modules/
__pycache__/
.venv/
venv/
.venvs/
.cache/
.npm/
.yarn/

# System/private state
.ssh/
.cloudflared/
.ollama/
.gnupg/
.pki/

# Runtime data
*.db
*.sqlite
*.sqlite3
*.db-shm
*.db-wal
*.log
logs/
runtime/
tmp/
temp/

# Build artifacts
dist/
build/

# Backups
*.bak
*.orig
*.old
*.backup*
EOF

echo
echo "=== PUBLIC EXPORT CREATED ==="
cd "$EXPORT"
echo
echo "=== TOP LEVEL ==="
find . -mindepth 1 -maxdepth 1 -not -name .git -printf '%f\n' | sort
echo
echo "=== FILE COUNT ==="
find . -type f -not -path './.git/*' | wc -l
echo
echo "=== SECURITY SCAN ==="
BAD="$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' \
    -o -name '.env.*' \
    -o -name '*.env' \
    -o -name '*.pem' \
    -o -name '*.key' \
    -o -name '*.p12' \
    -o -name '*.pfx' \
    -o -name '*.secret' \
    -o -name '*.db' \
    -o -name '*.sqlite' \
    -o -name '*.sqlite3' \
    -o -name '.cursor' \
    -o -name '.codex' \
    -o -name '.agents' \
    -o -name '.claude' \
    -o -name '.copilot' \
    -o -name '.gemini' \
    -o -name '.aider' \
    -o -name '.windsurf' \
    -o -name '.ollama' \
    -o -name '.gnupg' \
    -o -name 'Credentials' \
    -o -name 'Database' \
  \) -print)"
if [ -n "$BAD" ]; then     echo "BAD="$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' \
    -o -name '.env.*' \
    -o -name '*.env' \
    -o -name '*.pem' \
    -o -name '*.key' \
    -o -name '*.p12' \
    -o -name '*.pfx' \
    -o -name '*.secret' \
    -o -name '*.db' \
    -o -name '*.sqlite' \
    -o -name '*.sqlite3' \
    -o -name '.cursor' \
    -o -name '.codex' \
    -o -name '.agents' \
    -o -name '.claude' \
    -o -name '.copilot' \
    -o -name '.gemini' \
    -o -name '.aider' \
    -o -name '.windsurf' \
    -o -name '.ollama' \
    -o -name '.gnupg' \
    -o -name 'Credentials' \
    -o -name 'Database' \
  \) -print)"! SECURITY FAILURE BAD="$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' \
    -o -name '.env.*' \
    -o -name '*.env' \
    -o -name '*.pem' \
    -o -name '*.key' \
    -o -name '*.p12' \
    -o -name '*.pfx' \
    -o -name '*.secret' \
    -o -name '*.db' \
    -o -name '*.sqlite' \
    -o -name '*.sqlite3' \
    -o -name '.cursor' \
    -o -name '.codex' \
    -o -name '.agents' \
    -o -name '.claude' \
    -o -name '.copilot' \
    -o -name '.gemini' \
    -o -name '.aider' \
    -o -name '.windsurf' \
    -o -name '.ollama' \
    -o -name '.gnupg' \
    -o -name 'Credentials' \
    -o -name 'Database' \
  \) -print)"!"
    echo "$BAD"
    exit 1
fi
cd /home/ava-core
set -euo pipefail
EXPORT="/home/ava-core/Ava-Directory"
SOURCE="/home/ava-core"
echo "=== CLEANING PUBLIC EXPORT ==="
# Preserve the repository's .git directory.
find "$EXPORT" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
echo "=== COPYING SAFE AVA DIRECTORIES ==="
# ------------------------------------------------------------
# ONLY export known AVA/Core project directories and documents.
# ------------------------------------------------------------
rsync -a   "$SOURCE/AGENTS.md"   "$SOURCE/README.md"   "$SOURCE/README-CORE-CONTEXT"   "$EXPORT/"
rsync -a   "$SOURCE/context/"   "$EXPORT/context/"
rsync -a   "$SOURCE/operations/"   "$EXPORT/operations/"
rsync -a   "$SOURCE/Web/"   "$EXPORT/Web/"
rsync -a   "$SOURCE/.ava/"   "$EXPORT/.ava/"
# ------------------------------------------------------------
# Remove anything private/generated that may exist underneath
# exported directories.
# ------------------------------------------------------------
find "$EXPORT"   -type d   \(     -name .git     -o -name .cursor     -o -name .codex     -o -name .agents     -o -name .claude     -o -name .copilot     -o -name .gemini     -o -name .aider     -o -name .windsurf     -o -name .ai     -o -name node_modules     -o -name __pycache__     -o -name .venv     -o -name venv     -o -name .venvs     -o -name .cache     -o -name .npm     -o -name .cargo     -o -name .ssh     -o -name .cloudflared     -o -name Credentials     -o -name credentials     -o -name secrets     -o -name wallets     -o -name tokens     -o -name Database     -o -name databases     -o -name logs     -o -name runtime     -o -name tmp     -o -name temp     -o -name build     -o -name dist   \)   -prune -exec rm -rf {} +
find "$EXPORT"   -type f   \(     -name '.env'     -o -name '.env.*'     -o -name '*.env'     -o -name '*.pem'     -o -name '*.key'     -o -name '*.p12'     -o -name '*.pfx'     -o -name '*.secret'     -o -name '*.db'     -o -name '*.sqlite'     -o -name '*.sqlite3'     -o -name '*.db-shm'     -o -name '*.db-wal'     -o -name '*.log'     -o -name '*.bak'     -o -name '*.backup*'   \)   -delete
# Never allow the repository to recursively appear in itself.
rm -rf "$EXPORT/Ava-Directory"
# ------------------------------------------------------------
# Public repository .gitignore
# ------------------------------------------------------------
cat > "$EXPORT/.gitignore" <<'EOF'
# Secrets
.env
.env.*
*.env
*.pem
*.key
*.p12
*.pfx
*.secret

# Private directories
Credentials/
credentials/
secrets/
wallets/
tokens/
Database/
databases/

# AI / agent tooling
.cursor/
.codex/
.agents/
.claude/
.copilot/
.gemini/
.aider/
.windsurf/
.ai/

# Development caches
.cargo/
node_modules/
__pycache__/
.venv/
venv/
.venvs/
.cache/
.npm/
.yarn/

# System/private state
.ssh/
.cloudflared/
.ollama/
.gnupg/
.pki/

# Runtime data
*.db
*.sqlite
*.sqlite3
*.db-shm
*.db-wal
*.log
logs/
runtime/
tmp/
temp/

# Build artifacts
dist/
build/

# Backups
*.bak
*.orig
*.old
*.backup*
EOF

echo
echo "=== PUBLIC EXPORT CREATED ==="
cd "$EXPORT"
echo
echo "=== TOP LEVEL ==="
find . -mindepth 1 -maxdepth 1 -not -name .git -printf '%f\n' | sort
echo
echo "=== FILE COUNT ==="
find . -type f -not -path './.git/*' | wc -l
echo
echo "=== SECURITY SCAN ==="
BAD="$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' \
    -o -name '.env.*' \
    -o -name '*.env' \
    -o -name '*.pem' \
    -o -name '*.key' \
    -o -name '*.p12' \
    -o -name '*.pfx' \
    -o -name '*.secret' \
    -o -name '*.db' \
    -o -name '*.sqlite' \
    -o -name '*.sqlite3' \
    -o -name '.cursor' \
    -o -name '.codex' \
    -o -name '.agents' \
    -o -name '.claude' \
    -o -name '.copilot' \
    -o -name '.gemini' \
    -o -name '.aider' \
    -o -name '.windsurf' \
    -o -name '.ollama' \
    -o -name '.gnupg' \
    -o -name 'Credentials' \
    -o -name 'Database' \
  \) -print)"
if [ -n "$BAD" ]; then     echo "BAD="$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' \
    -o -name '.env.*' \
    -o -name '*.env' \
    -o -name '*.pem' \
    -o -name '*.key' \
    -o -name '*.p12' \
    -o -name '*.pfx' \
    -o -name '*.secret' \
    -o -name '*.db' \
    -o -name '*.sqlite' \
    -o -name '*.sqlite3' \
    -o -name '.cursor' \
    -o -name '.codex' \
    -o -name '.agents' \
    -o -name '.claude' \
    -o -name '.copilot' \
    -o -name '.gemini' \
    -o -name '.aider' \
    -o -name '.windsurf' \
    -o -name '.ollama' \
    -o -name '.gnupg' \
    -o -name 'Credentials' \
    -o -name 'Database' \
  \) -print)"! SECURITY FAILURE BAD="$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' \
    -o -name '.env.*' \
    -o -name '*.env' \
    -o -name '*.pem' \
    -o -name '*.key' \
    -o -name '*.p12' \
    -o -name '*.pfx' \
    -o -name '*.secret' \
    -o -name '*.db' \
    -o -name '*.sqlite' \
    -o -name '*.sqlite3' \
    -o -name '.cursor' \
    -o -name '.codex' \
    -o -name '.agents' \
    -o -name '.claude' \
    -o -name '.copilot' \
    -o -name '.gemini' \
    -o -name '.aider' \
    -o -name '.windsurf' \
    -o -name '.ollama' \
    -o -name '.gnupg' \
    -o -name 'Credentials' \
    -o -name 'Database' \
  \) -print)"!"
    echo "$BAD"
    exit 1
fi
cd /home/ava-core/Ava-Directory
echo "=== CHECK ==="
pwd
git status --short | head -30
echo
echo "=== TOP LEVEL ==="
find . -mindepth 1 -maxdepth 1 -not -name .git -printf '%f\n' | sort
echo
echo "=== COUNTS ==="
find context operations Web .ava -type f 2>/dev/null | wc -l
cd /home/ava-core/Ava-Directory
echo "=== GIT ROOT ==="
git rev-parse --show-toplevel
echo
echo "=== GIT DIRECTORY ==="
git rev-parse --git-dir
echo
echo "=== REPO CONFIG ==="
git config --get core.worktree || true
git remote -v
cd /home/ava-core
echo "=== BACKING UP ACCIDENTAL GIT METADATA ==="
mv .git .git-ava-core-backup
echo
echo "=== INITIALIZING AVA-DIRECTORY REPO ==="
cd /home/ava-core/Ava-Directory
git init
git branch -M main
git remote add origin https://github.com/Ava-Core-Dev/Ava-Directory.git
echo
echo "=== VERIFYING ROOT ==="
echo "Git root:"
git rev-parse --show-toplevel
echo
echo "Git directory:"
git rev-parse --git-dir
echo
echo "Remote:"
git remote -v
echo
echo "=== STATUS ==="
git status --short
cd /home/ava-core/Ava-Directory
echo "=== PUBLIC EXPORT SECURITY CHECK ==="
BAD=$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' -o -name '.env.*' -o -name '*.env' \
    -o -name '*.pem' -o -name '*.key' \
    -o -name '*.p12' -o -name '*.pfx' -o -name '*.secret' \
    -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' \
    -o -name '*.db-shm' -o -name '*.db-wal' \
    -o -name '.cursor' -o -name '.codex' -o -name '.agents' \
    -o -name '.claude' -o -name '.copilot' -o -name '.gemini' \
    -o -name '.aider' -o -name '.windsurf' \
    -o -name 'Credentials' -o -name 'Database' \
    -o -name 'credentials' -o -name 'secrets' \
    -o -name 'wallets' -o -name 'tokens' \
  \) -print)
if [ -n "$BAD" ]; then     echo;     echo "BAD=$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' -o -name '.env.*' -o -name '*.env' \
    -o -name '*.pem' -o -name '*.key' \
    -o -name '*.p12' -o -name '*.pfx' -o -name '*.secret' \
    -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' \
    -o -name '*.db-shm' -o -name '*.db-wal' \
    -o -name '.cursor' -o -name '.codex' -o -name '.agents' \
    -o -name '.claude' -o -name '.copilot' -o -name '.gemini' \
    -o -name '.aider' -o -name '.windsurf' \
    -o -name 'Credentials' -o -name 'Database' \
    -o -name 'credentials' -o -name 'secrets' \
    -o -name 'wallets' -o -name 'tokens' \
  \) -print)! SECURITY FAILURE BAD=$(find . \
  -not -path './.git/*' \
  \( \
    -name '.env' -o -name '.env.*' -o -name '*.env' \
    -o -name '*.pem' -o -name '*.key' \
    -o -name '*.p12' -o -name '*.pfx' -o -name '*.secret' \
    -name '*.db' -o -name '*.sqlite' -o -name '*.sqlite3' \
    -o -name '*.db-shm' -o -name '*.db-wal' \
    -o -name '.cursor' -o -name '.codex' -o -name '.agents' \
    -o -name '.claude' -o -name '.copilot' -o -name '.gemini' \
    -o -name '.aider' -o -name '.windsurf' \
    -o -name 'Credentials' -o -name 'Database' \
    -o -name 'credentials' -o -name 'secrets' \
    -o -name 'wallets' -o -name 'tokens' \
  \) -print)!"
    echo "$BAD"
    exit 1
fi
echo "SECURITY CHECK PASSED"
echo
echo "=== FILE COUNT ==="
find . -type f -not -path './.git/*' | wc -l
echo
echo "=== TOP LEVEL ==="
find . -mindepth 1 -maxdepth 1 -not -name .git -printf '%f\n' | sort
cd /home/ava-core/Ava-Directory
echo "=== SECURITY CHECK ==="
find .   -not -path './.git/*'   \(     -name '.env' -o     -name '.env.*' -o     -name '*.env' -o     -name '*.pem' -o     -name '*.key' -o     -name '*.p12' -o     -name '*.pfx' -o     -name '*.secret' -o     -name '*.db' -o     -name '*.sqlite' -o     -name '*.sqlite3' -o     -name '*.db-shm' -o     -name '*.db-wal' -o     -name '.cursor' -o     -name '.codex' -o     -name '.agents' -o     -name '.claude' -o     -name '.copilot' -o     -name '.gemini' -o     -name '.aider' -o     -name '.windsurf' -o     -name 'Credentials' -o     -name 'Database' -o     -name 'credentials' -o     -name 'secrets' -o     -name 'wallets' -o     -name 'tokens'   \) -print
echo
echo "=== GIT IGNORE TEST ==="
git check-ignore -v   .env   .cursor/test   .codex/test   .agents/test   Credentials/test   Database/test   test.db   test.sqlite
echo
echo "=== FILE COUNT ==="
find . -type f -not -path './.git/*' | wc -l
echo
echo "=== STATUS ==="
git status --short
set -euo pipefail
cd /home/ava-core
echo "=== INSTALLING AVA DIRECTORY AUTO-SYNC ==="
mkdir -p /home/ava-core/operations/system-tools/directory-sync
cat > /home/ava-core/operations/system-tools/directory-sync/ava-directory-sync.sh <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

SOURCE="/home/ava-core"
EXPORT="/home/ava-core/Ava-Directory"
LOG="/home/ava-core/context/ava-directory-sync.log"

mkdir -p "$(dirname "$LOG")"

exec >>"$LOG" 2>&1

echo
echo "============================================================"
echo "AVA DIRECTORY SYNC"
echo "$(date -Is)"
echo "============================================================"

cd "$SOURCE"

# ------------------------------------------------------------
# PRIVATE / GENERATED EXCLUSIONS
# ------------------------------------------------------------

EXCLUDES=(
    ".git"
    ".git/"
    "Ava-Directory"
    "Ava-Directory/"
    ".cursor"
    ".cursor/"
    ".codex"
    ".codex/"
    ".agents"
    ".agents/"
    ".claude"
    ".claude/"
    ".copilot"
    ".copilot/"
    ".gemini"
    ".gemini/"
    ".aider"
    ".aider/"
    ".windsurf"
    ".windsurf/"
    ".ai"
    ".ai/"
    ".cargo"
    ".cargo/"
    ".ssh"
    ".ssh/"
    ".cloudflared"
    ".cloudflared/"
    ".gnupg"
    ".gnupg/"
    ".pki"
    ".pki/"
    ".ollama"
    ".ollama/"
    ".npm"
    ".npm/"
    ".cache"
    ".cache/"
    ".local"
    ".local/"
    ".gradle"
    ".gradle/"
    ".rustup"
    ".rustup/"
    "Credentials"
    "Credentials/"
    "Database"
    "Database/"
    "credentials"
    "credentials/"
    "secrets"
    "secrets/"
    "wallets"
    "wallets/"
    "tokens"
    "tokens/"
    ".env"
    ".env.*"
    "*.env"
    "*.pem"
    "*.key"
    "*.p12"
    "*.pfx"
    "*.secret"
    "*.db"
    "*.sqlite"
    "*.sqlite3"
    "*.db-shm"
    "*.db-wal"
    "*.log"
    "logs/"
    "runtime/"
    "tmp/"
    "temp/"
    "node_modules/"
    "__pycache__/"
    ".venv/"
    "venv/"
    "dist/"
    "build/"
)

RSYNC_ARGS=()

for item in "${EXCLUDES[@]}"; do
    RSYNC_ARGS+=(--exclude="$item")
done

# ------------------------------------------------------------
# REBUILD PUBLIC EXPORT
# ------------------------------------------------------------

echo "Rebuilding sanitized public export..."

find "$EXPORT" \
    -mindepth 1 \
    -maxdepth 1 \
    ! -name ".git" \
    -exec rm -rf {} +

rsync -a "${RSYNC_ARGS[@]}" \
    "$SOURCE/" \
    "$EXPORT/"

# Repository must never appear inside itself.
rm -rf "$EXPORT/Ava-Directory"

# ------------------------------------------------------------
# PUBLIC REPOSITORY IGNORE RULES
# ------------------------------------------------------------

cat > "$EXPORT/.gitignore" <<'EOF'
.env
.env.*
*.env

*.pem
*.key
*.p12
*.pfx
*.secret

Credentials/
credentials/
secrets/
wallets/
tokens/

Database/
database/

.cursor/
.codex/
.agents/
.claude/
.copilot/
.gemini/
.aider/
.windsurf/
.ai/
.cargo/

node_modules/
__pycache__/
.venv/
venv/
.cache/
.npm/
.yarn/

.ssh/
.cloudflared/

*.db
*.sqlite
*.sqlite3
*.db-shm
*.db-wal

*.log
logs/
runtime/
tmp/
temp/

dist/
build/

*.backup*
*.bak
*.orig
*.old
EOF

# ------------------------------------------------------------
# DIRECTORY INDEX GENERATOR
# ------------------------------------------------------------

echo "Generating DIRECTORY.txt files..."

python3 <<'PY'
import os

ROOT = "/home/ava-core/Ava-Directory"

PRIVATE_DIRS = {
    ".git",
    ".cursor",
    ".codex",
    ".agents",
    ".claude",
    ".copilot",
    ".gemini",
    ".aider",
    ".windsurf",
    ".ai",
    ".cargo",
    ".ssh",
    ".cloudflared",
    "Credentials",
    "Database",
    "credentials",
    "secrets",
    "wallets",
    "tokens",
    "node_modules",
    "__pycache__",
    ".venv",
    "venv",
    ".cache",
    ".npm",
    "dist",
    "build",
    "runtime",
    "tmp",
    "temp",
}

PRIVATE_FILES = {
    ".env",
}

PRIVATE_SUFFIXES = (
    ".pem",
    ".key",
    ".p12",
    ".pfx",
    ".secret",
    ".db",
    ".sqlite",
    ".sqlite3",
    ".db-shm",
    ".db-wal",
    ".log",
)

def hidden_or_private(name):
    if name in PRIVATE_FILES:
        return True
    if name.startswith(".env."):
        return True
    if name.endswith(PRIVATE_SUFFIXES):
        return True
    return False

for current, dirs, files in os.walk(ROOT):
    rel = os.path.relpath(current, ROOT)

    # Never descend into private material.
    dirs[:] = sorted(
        d for d in dirs
        if d not in PRIVATE_DIRS
        and not hidden_or_private(d)
    )

    visible_dirs = sorted(
        d for d in dirs
        if d not in PRIVATE_DIRS
        and not hidden_or_private(d)
    )

    visible_files = sorted(
        f for f in files
        if f != "DIRECTORY.txt"
        and not hidden_or_private(f)
    )

    path = os.path.join(current, "DIRECTORY.txt")

    lines = [
        "AVA DIRECTORY INDEX",
        "===================",
        "",
        f"Path: /{'' if rel == '.' else rel}",
        "",
        "Directories:",
    ]

    if visible_dirs:
        lines.extend(f"  [DIR]  {d}/" for d in visible_dirs)
    else:
        lines.append("  (none)")

    lines.extend([
        "",
        "Files:",
    ])

    if visible_files:
        lines.extend(f"  [FILE] {f}" for f in visible_files)
    else:
        lines.append("  (none)")

    lines.extend([
        "",
        f"Directory count: {len(visible_dirs)}",
        f"File count:      {len(visible_files)}",
        "",
    ])

    content = "\n".join(lines)

    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)

print("DIRECTORY.txt generation complete.")
PY

# ------------------------------------------------------------
# FINAL SECURITY SWEEP
# ------------------------------------------------------------

echo "Running final security sweep..."

BAD="$(
    find "$EXPORT" \
        -not -path "$EXPORT/.git/*" \
        \( \
            -name '.env' -o \
            -name '.env.*' -o \
            -name '*.env' -o \
            -name '*.pem' -o \
            -name '*.key' -o \
            -name '*.p12' -o \
            -name '*.pfx' -o \
            -name '*.secret' -o \
            -name '*.db' -o \
            -name '*.sqlite' -o \
            -name '*.sqlite3' -o \
            -name '*.db-shm' -o \
            -name '*.db-wal' -o \
            -name '.cursor' -o \
            -name '.codex' -o \
            -name '.agents' -o \
            -name '.claude' -o \
            -name '.copilot' -o \
            -name '.gemini' -o \
            -name '.aider' -o \
            -name '.windsurf' -o \
            -name 'Credentials' -o \
            -name 'Database' -o \
            -name 'credentials' -o \
            -name 'secrets' -o \
            -name 'wallets' -o \
            -name 'tokens' \
        \) -print
)"

if [[ -n "$BAD" ]]; then
    echo "!!! SECURITY FAILURE !!!"
    echo "$BAD"
    exit 1
fi

echo "SECURITY CHECK PASSED"

# ------------------------------------------------------------
# GIT
# ------------------------------------------------------------

cd "$EXPORT"

git add -A

if git diff --cached --quiet; then
    echo "No public changes detected."
else
    git commit -m "Automated AVA Directory update"
    git push origin main
    echo "Public repository updated."
fi

echo
echo "=== SYNC COMPLETE ==="
echo "Files:       $(find . -type f -not -path './.git/*' | wc -l)"
echo "Directories: $(find . -type d -not -path './.git*' | wc -l)"
echo "Indexes:     $(find . -name DIRECTORY.txt -not -path './.git/*' | wc -l)"
echo
SCRIPT

chmod +x /home/ava-core/operations/system-tools/directory-sync/ava-directory-sync.sh
echo
echo "=== INSTALLING CRON ==="
CRON_TMP="$(mktemp)"
crontab -l 2>/dev/null     | grep -v 'ava-directory-sync.sh'     > "$CRON_TMP" || true
# Every hour, at 5 minutes past the hour.
echo "5 * * * * /home/ava-core/operations/system-tools/directory-sync/ava-directory-sync.sh" >> "$CRON_TMP"
crontab "$CRON_TMP"
rm -f "$CRON_TMP"
echo
echo "=== RUNNING FIRST SYNC NOW ==="
/home/ava-core/operations/system-tools/directory-sync/ava-directory-sync.sh
python 3 meta.py
py meta.py
python3 meta.py
python3 -m pip install --upgrade meta-ai-api
# 1. Create a virtual environment in the current folder
python3 -m venv .venv
# 2. Activate it
source .venv/bin/activate
# 3. Install the package
pip install --upgrade meta-ai-api
# 4. Run the chat script
python meta.py
python3 file_mapper.py
