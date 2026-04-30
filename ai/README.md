# AI setup

Portable configuration for Vic's local agent stack.

## What this covers

This directory contains the safe, repo-backed parts of the local AI setup:

- pi agent config
- generic Claude global instructions and the memento concierge agent
- Codex config without trusted project roots
- Memento Vault config template without private project rules
- a symlink bootstrap script

It intentionally does not include credentials, sessions, histories, generated caches, company-specific agents, reviewer lists, private project rules, plugin runtime state, or work-specific QA secrets.

## Bootstrap

Prefer the top-level installer when setting up a machine:

```bash
~/dotfiles/install.sh
```

For AI config only:

```bash
~/dotfiles/ai/link-agent-config.sh
```

The AI-only script links these files into their expected runtime locations:

- `~/.pi/agent/settings.json`
- `~/.pi/agent/mcp.json`
- `~/.pi/agent/keybindings.json`
- `~/.claude/CLAUDE.md`
- `~/.claude/portable-claude.md`
- `~/.claude/hooks/notify.sh`
- `~/.claude/agents/concierge.md`
- `~/.codex/config.toml`
- `~/.config/memento-vault/memento.yml`

## Local/private overlay

Add machine-specific and work-specific config outside this repo after bootstrap:

- API keys and tokens from a password manager or ignored env file
- Codex trusted project roots
- project-specific Claude agents and skills
- ticket tracker config
- team reviewer lists
- extra Memento/QMD collections and project rules
- plugin install state

## Environment-dependent files

`~/.claude/hooks/notify.sh` is included because it is useful on Vic's current Linux desktop, but it is not portable as-is. It assumes:

- `dunstify` for desktop notifications
- i3 via `i3-msg`
- kitty as the terminal class
- tmux sessions and panes

The hook uses generic notification titles and bodies so it does not leak work context during screen sharing or notification sync.

the personal command-rewrite hook is intentionally not moved here. It belongs with personal command-rewrite infrastructure and requires its binary plus rewrite registry. If command rewriting is wanted on a new machine, install that private tooling first and restore the hook from its own setup path, not from this generic AI config bundle.

## After bootstrap

Manual setup still needed:

- install CLI tools (`pi`, `claude`, `codex`, `qmd`, `mcp-remote`, etc.)
- restore credentials from 1Password or ignored env files
- authenticate MCP servers
- add local trusted project roots and project-specific overlays
- run `~/dotfiles/install.sh --status`

See `TODO.md` for cleanup work and `MANUAL_REVIEW.md` for files that were inspected and deliberately left out.
