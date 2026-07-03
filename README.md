# Dotfiles

Personal dotfiles and safe agent setup.

Security boundary: this repo may contain personal workflow preferences, but it must not contain credentials, work/customer data, or company-specific agent config. Put secrets and private overlays in ignored local files or their owning private repos.

## Install

From a checked-out repo:

```bash
./install.sh
```

### macOS bootstrap

On a fresh Apple Silicon Mac:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone <dotfiles-repo-url> ~/dotfiles
cd ~/dotfiles
brew bundle --file Brewfile
./install.sh --status
./install.sh --dry-run
./install.sh
```

Then install the agent npm tools from a Node 24+ shell:

```bash
npm install -g \
  @mariozechner/pi-coding-agent \
  @mariozechner/pi-ai \
  @openai/codex \
  @google/gemini-cli \
  @anthropic-ai/claude-code \
  mcp-remote@0.1.38 \
  @tobilu/qmd \
  eas-cli \
  @playwright/cli
```

Private auth/session state still needs to be restored manually from 1Password or provider login flows.

If you are using Claude, Codex, or pi on a clean machine, tell the agent:

```text
Read AGENTS.md and install this dotfiles repo end-to-end. Run status first, install safe missing prerequisites, run the dry run, then run the installer and verify the agent surfaces.
```

The agent-facing procedure lives in `AGENTS.md`. The installer is idempotent and prints what it detects before mutating anything. It refuses to overwrite regular files, refuses to repoint existing AI config symlinks unless `--force-links` is passed, leaves existing non-matching git checkouts untouched, and relies on component installers that are safe to rerun. Preview first with:

```bash
./install.sh --dry-run
./install.sh --status
```

Default install does this:

1. Stows base dotfiles with GNU Stow:
   - `config/`
   - `git/`
   - `zsh/`
2. Links safe AI config from `ai/`:
   - pi settings, MCP config, and keybindings
   - generic Claude instructions and concierge agent
   - generic Codex config
   - generic Memento config template
3. Clones public/open-source setup repos when missing.
4. Installs Memento Vault.
5. Registers the Memento pi package with only the generic skills enabled if `pi` exists.
6. Installs personal pi extensions if `pi` exists.
7. Installs Beislið workflow skills.
8. Installs pinned `mcp-remote` when `npm` exists.
9. Installs pinned Worktrunk CLI when `cargo` exists.

Skip parts with:

```bash
./install.sh --no-stow
./install.sh --no-ai
./install.sh --no-memento
./install.sh --no-pi-extensions
./install.sh --no-beislid
./install.sh --no-clone
./install.sh --no-mcp-remote
./install.sh --no-worktrunk
./install.sh --force-links
```

## Expected local checkouts

The installer clones the known public/open-source setup repos below when missing. If a path already exists, it is reused only when its `origin` matches the expected public URL. Non-git directories or different repos are left untouched. It does not clone private repos or restore private overlays.

| Component | Default path | Public clone URL | Purpose |
|---|---|---|---|
| Memento Vault | `~/Projects/memento-vault` | `https://github.com/sandsower/memento-vault.git` | durable memory, MCP server, Claude hooks, pi extension |
| pi extensions | `~/Personal/pi-extensions` | `https://github.com/sandsower/pi-extensions.git` | usage tracker, safety gate, task state, MCP bridge, subagent runner |
| Beislið | `~/Personal/beislid/main` | `https://github.com/sandsower/beislid.git` | workflow skills and optional show-me pi tools; bare repo lives at `~/Personal/beislid.git` |

Override paths when your machine layout differs:

```bash
MEMENTO_REPO=~/src/memento-vault \
PI_EXTENSIONS_REPO=~/src/pi-extensions \
BEISLID_REPO=~/src/beislid/main \
./install.sh
```

Override clone URLs if a repo moves:

```bash
MEMENTO_REPO_URL=https://github.com/sandsower/memento-vault.git \
PI_EXTENSIONS_REPO_URL=https://github.com/sandsower/pi-extensions.git \
BEISLID_REPO_URL=https://github.com/sandsower/beislid.git \
./install.sh
```

## Credentials and private overlays

Do not commit these here:

- API keys, tokens, auth JSON, SSH keys, cookies, or MCP bearer config
- work-specific agent config, reviewer lists, ticket config, or project rules
- command aliases that expose private infrastructure
- session histories, logs, caches, generated state, or local Claude/Codex settings

Use local-only files instead, for example:

- `~/.private_commands.sh` for shell secrets/private aliases
- `~/.gitconfig.local` for machine/user-specific Git identity
- `~/.claude/*` for private project agents and ticket workflow config
- `~/.config/memento-vault/memento.yml` for private Memento project rules after bootstrap

The tracked `git/.gitconfig` includes `~/.gitconfig.local`; create that file locally with your user identity.

## Agent-led setup

A clean agent session should be able to complete setup by following `AGENTS.md`. The top-level installer is intended to be the central setup piece on a new machine, not just a dotfile stow helper.

Agent flow:

1. read the docs and installer
2. run `./install.sh --status`
3. install safe missing prerequisites with approval
4. locate or clone optional component repos
5. run `./install.sh --dry-run`
6. run `./install.sh`
7. verify pi/Claude/Codex surfaces
8. report missing private overlays without creating or committing them

Use the manual sections below when doing the same work yourself.

## Agent stack setup

### Memento Vault

If the checkout exists, `./install.sh` runs:

```bash
env MEMENTO_VAULT_PATH="$HOME/Personal/memento" ~/Projects/memento-vault/install.sh --experimental --mcp
# then normalizes ~/.pi/agent/settings.json to load only Memento's generic pi skills
```

Manual status checks after install:

```bash
~/.claude/hooks/memento-status.sh 2>/dev/null || true
pi --version
```

Inside pi, run:

```text
/memento-status
/memento-queue
```

### Personal pi extensions

If the checkout exists, `./install.sh` runs:

```bash
pi install ~/Personal/pi-extensions
```

Expected pi tools after restart include usage reporting, safety gate, task state, MCP bridge, and subagent runner. Inside pi, check:

```text
/usage
/safety
/tasks
/mcp
/subagents
```

### Beislið skills

If the checkout exists, `./install.sh` runs:

```bash
~/Personal/beislid/main/install.sh --with-security-hooks --with-pi-show-me
```

That installs portable workflow skills into supported agent skill directories and optional pi show-me tools.

## Worktrunk setup

If `cargo` exists, `./install.sh` installs the pinned Worktrunk CLI:

```bash
cargo install worktrunk --version 0.46.1
```

`config/.config/worktrunk/config.toml` keeps the worktree path global and includes one local-convenience `pre-start` hook. The hook is intentionally repo-name agnostic: for any project, it copies `.env` / `.env.*` files from the primary worktree and symlinks existing package-level `node_modules` directories into the new worktree.

This is useful for local solo development, but it can spread credentials or shared mutable dependency state. Disable it for a command with:

```bash
WORKTRUNK_LOCAL_FILES=0 wt switch --create <branch>
```

The hook stays defensive:

- never commits or prints secret values
- copies `.env*` files instead of symlinking them
- skips dependency/build/coverage/worktrunk-managed directories while discovering env files
- refuses to overwrite regular files or existing symlinks
- only replaces an existing path when it is already the expected broken symlink

## MCP setup

`ai/pi/mcp.json` launches Linear MCP through `/usr/bin/env mcp-remote`, so `mcp-remote` must be on `PATH`. Install it outside this repo, pinned through your package manager or global npm tooling:

```bash
npm install -g mcp-remote@0.1.38
```

OAuth/auth caches are runtime state and must stay outside this repo.

## Verification before commit

Run these scans before committing dotfiles changes:

```bash
rg -n -i "api[_-]?key|token|secret|password|bearer|authorization" .
rg -n -i "<known-private-company-terms>|<known-private-project-paths>|<known-private-key-names>" .
git status --short
```

Replace the placeholders with private terms from your local context before publishing or committing. The scans can match documentation. Investigate every hit and make sure it is not a value or private work context.

## Legacy scripts

- `install.sh` is the supported installer.
- `install_arc.sh` is an old Arch package helper.
- `install_osx.sh` is disabled until its remote installers are pinned.
- `config/.config/eww/install.sh` is disabled until its source/toolchain are pinned.
