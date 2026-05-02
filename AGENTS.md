# AGENTS.md

Instructions for coding agents working in this dotfiles repo.

## Prime directive

Personal preferences are allowed. Credentials and private work context are not.

Never commit or print:

- API keys, tokens, bearer values, auth JSON, cookies, SSH keys, or private env files
- work/customer/company-specific docs, agent config, reviewer lists, ticket config, project rules, paths, or branch names
- session histories, logs, caches, telemetry, generated state, or local Claude/Codex runtime settings

If a file might contain secrets or private work context, leave it local and document how to recreate it.

## Before editing

1. Check status:

   ```bash
   git status --short
   ```

2. Inspect the relevant installer/docs before changing behavior:

   ```bash
   read README.md
   read install.sh
   read ai/README.md
   ```

3. Preserve local-only overlays. Do not move private files into this repo just because the installer references them.

## Clean-run agent bootstrap

If Vic starts a fresh Claude/Codex/pi session in this repo and says "install everything", do not stop at telling him to run the installer. Drive the setup.

Agent flow:

1. Read `AGENTS.md`, `README.md`, `install.sh`, and `ai/README.md`.
2. Run `./install.sh --status` and summarize missing prerequisites.
3. Install safe public prerequisites when normal package managers are available and Vic has approved mutation. Examples:
   - GNU Stow if missing.
   - `mcp-remote@0.1.38` if Linear MCP support is wanted.
   - `worktrunk@0.46.1` if `cargo` is available.
4. Treat `./install.sh` as the central new-machine setup entry point. It can clone and install the known public/open-source setup repos when they are missing.
5. Check optional local checkouts:
   - `MEMENTO_REPO` or `~/Projects/memento-vault`
   - `PI_EXTENSIONS_REPO` or `~/Personal/pi-extensions`
   - `BEISLID_REPO` or `~/Personal/beislid/main`
6. If a checkout is missing and `./install.sh` will clone it from the documented public URL, mention that before running the installer. For any private/personal repo not documented here, ask Vic for the source URL or restored path. Do not guess or search private context.
7. Run `./install.sh --dry-run`.
8. If the dry run is sane, run `./install.sh`. If it refuses to repoint an existing symlink, inspect the target; only rerun with `--force-links` when the existing symlink is known stale.
9. Restart or tell Vic to restart affected agents, then verify with the status commands below.
10. Restore private overlays only from local ignored files, password manager output, or explicit user-provided values. Never invent or commit them.

Verification commands after install:

```bash
./install.sh --status
command -v pi || true
command -v mcp-remote || true
command -v wt || true
```

Inside pi, check the installed surfaces:

```text
/usage
/safety
/tasks
/mcp
/subagents
/memento-status
/memento-queue
```

If a host tool is unavailable, record the exact missing command and continue with the rest of the setup. Do not mark the install complete until missing pieces are listed.

## Installer contract

`./install.sh` is the supported entry point. It must stay safe to rerun and must not silently replace user config.

It may:

- stow repo-backed dotfiles
- link files from `ai/` into agent config locations
- call installers from existing local checkouts
- print missing optional components and next steps

It must not:

- clone private repos automatically
- fetch and execute remote scripts from moving branches
- write secrets
- overwrite regular files with symlinks
- repoint existing symlinks unless Vic passes `--force-links` or sets `FORCE_LINKS=1`
- reuse an existing checkout if its `origin` does not match the expected public repo
- propagate `.env*`, `.claude`, package caches, or runtime state across worktrees

When adding a new setup step, include:

- a skip flag if it is optional
- an environment variable override for nonstandard paths
- a status/dry-run-friendly command path
- detection for already-installed state
- refusal behavior for conflicting local state
- README documentation

## Expected optional components

These may or may not exist on a fresh machine. `./install.sh` clones the documented public repos when missing unless `--no-clone` is passed. If cloning fails, warn and continue.

### Memento Vault

Default checkout:

```text
~/Projects/memento-vault
```

Install command when present:

```bash
env MEMENTO_VAULT_PATH="$HOME/Personal/memento" ~/Projects/memento-vault/install.sh --experimental --mcp
# then normalize ~/.pi/agent/settings.json so Memento loads only skills/generic
```

Do not commit local vault contents, remote API keys, or private project rules to dotfiles. The repo-backed `ai/memento-vault/memento.yml` is only a generic template.

### Personal pi extensions

Default checkout:

```text
~/Personal/pi-extensions
```

Install command when present:

```bash
pi install ~/Personal/pi-extensions
```

This should provide usage tracking, safety gate, task state, MCP bridge, and subagent tools. Keep extension source in its own repo. Do not vendor it here.

### Beislið workflow skills

Default checkout:

```text
~/Personal/beislid/main
```

The bare repo lives at `~/Personal/beislid.git`; additional worktrees can be created under `~/Personal/beislid/`.

Install command when present:

```bash
~/Personal/beislid/main/install.sh --with-security-hooks --with-pi-show-me
```

Keep project-specific workflow configuration outside dotfiles.

## Agent config boundaries

Safe to keep in `ai/`:

- generic Claude preferences
- generic portable Claude prompt
- generic concierge/memento search agent
- pi UI/model/MCP defaults with no auth values
- Codex defaults with no broad home-directory trust
- Memento config template with no private project rules

Keep local/private:

- Claude `settings.json` and `settings.local.json`
- MCP bearer configs
- Claude/Codex auth files
- private project agents and ticket workflow config
- plugin runtime state and cache manifests
- trusted project roots

## Worktrunk private conveniences

Do not re-add global Worktrunk hooks that automatically propagate `.env*`, `.claude`, workflow state, local E2E folders, or `node_modules` into every new worktree.

If Vic asks to restore that behavior, recreate it as trusted per-repo setup or a private local overlay. The hook must be opt-in, refuse to overwrite regular files, avoid printing secret paths/values, and document the assumed repo/worktree layout.

## Security review checklist

Before declaring the repo clean, run:

```bash
rg -n -i "api[_-]?key|token|secret|password|bearer|authorization" .
rg -n -i "<known-private-company-terms>|<known-private-project-paths>|<known-private-key-names>" .
rg -n "curl .*\|.*sh|wget .*\|.*sh|git clone https://|npx -y|/HEAD/|/master/" .
git status --short
```

Replace the placeholders with private terms from the local context before publishing or committing. Investigate every hit. Documentation mentions of words like `token` are acceptable only when no value is present and no private work context is revealed.

## If you find a secret

1. Do not print it.
2. Remove it from the repo-backed file.
3. Move the setting to a local ignored file or password manager workflow.
4. Tell Vic what kind of credential needs rotation without revealing the value.
5. Re-run the scans.

## Commit guidance

Do not commit unless Vic asks. When committing, keep private overlay changes out of this repo and show `git status --short` first.
