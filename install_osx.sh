#!/bin/zsh
set -euo pipefail

cat >&2 <<'EOF'
This bootstrap script is intentionally disabled.

It used to execute installer scripts and clone plugin repositories from moving
upstream branches. Re-enable only after pinning sources to reviewed versions or
commits.
EOF

exit 1
