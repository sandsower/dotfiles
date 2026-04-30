- Never use the ticket number in the commit, this is added automatically by a git precommit hook
- Never co-sign commits
- Never autocommit unless prompted
- Always give me the information assuming the terminal will wrap the commands given, in a single line if it's a CLI command
- Keep PR descriptions succinct and simple - no verbose text for straightforward changes
- Always include the ticket number in the PR title when the project uses tickets (e.g. "TICKET-123: Add logout button")
- commands are text wrapping, can you make sure you never do that?
- Use `pushd`/`popd` instead of `cd` when changing directories
- Default to `git merge` instead of `git rebase` — only rebase when I explicitly ask for it
- Linear MCP tools are deferred — always load them via `ToolSearch` (e.g. `+linear get issue`) before first use in a session

## Taumar skill routing

Before answering planning, design, or spec questions conversationally, scan the user's prompt for these triggers and invoke the matching skill instead of writing the answer yourself:

- "spec it out", "before you build", "let's discuss before building", "PRD this", "shape this", "discuss and spec" → `taumar:spec`
- "grill me", "stress test", "challenge this", "poke holes", "push back on this" → `taumar:grill-me`
- "design this", "plan the implementation", "before I write code", "how should we build" → `taumar:blueprint`
- "create a skill", "modify a skill", "improve this skill", "build a new skill" → `skill-creator`

Auto mode does not bypass these triggers. If a trigger phrase appears, the matching skill must fire even when the request seems clear and direct action seems faster. Conversational answers to these prompts are a routing failure, not a shortcut.

## Tone

Before writing any content that other people will read (PR descriptions, commit messages, design docs, code comments, Linear updates, PR review comments, Slack replies, blog posts, etc.), route through `tone-practice`. It drafts concise factual text, stops for Vic to rewrite in his own voice, and saves both versions as a paired artifact under the correct voice bucket. For large text, it opens the draft in vim via a tmux side pane and resumes when Vic runs `/tone-practice finish`.

Three voice registers, picked by audience:
- **terse** — self-documenting text: commits, PR bodies, Linear ticket bodies, design docs, code comments. Audience is "whoever reads the record later."
- **colleague** — text going to named colleagues: PR review comments, Linear replies, Slack replies on work topics. Audience expects a collaborative eng-to-eng tone.
- **pro** — publication-ready: blog posts, marketing, external professional writing. Audience is strangers.

If the register is ambiguous, ask Vic rather than guessing.

For quick rewrites without capturing an artifact (e.g., the text is trivial and training data would be noise), invoke the matching voice skill directly: `tone`, `tone-colleague`, or `tone-pro`.

Refining the voice skills: run `refine-tone tone-colleague` (or `tone` / `tone-pro`) to mine accumulated artifacts and propose evidence-based rule updates.

## Credentials

Never read or print long-lived secrets directly. Do not open credentials files, shell private-command files, auth JSON, token stores, or tracked dotfiles looking for keys. Use already-exported environment variables, password-manager CLIs, or a local wrapper script that keeps secret values out of prompts, command lines, logs, and responses.

## Memento vault

Personal knowledge vault at `~/Personal/memento/`. All session knowledge is captured automatically on session end. Use `/memento` to force capture mid-session. The concierge agent searches the vault for past decisions and sessions.

During ticket or project setup, if the work touches an area Vic has worked on before, check the memento vault via concierge for past decisions or gotchas before moving on.
