#!/usr/bin/env bash
set -euo pipefail

cat >&2 <<'EOF'
This installer is intentionally disabled.

It used to install Rust nightly, clone eww from the default branch, build it,
and copy the binary into /usr/bin with sudo. Re-enable only after pinning the
source commit/toolchain and reviewing the build path.
EOF

exit 1
