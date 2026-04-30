#!/bin/bash
INPUT=$(cat)
NOTIF_TYPE=$(echo "$INPUT" | jq -r '.notification_type // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

case "$NOTIF_TYPE" in
  "permission_prompt") URGENCY="critical" ; BODY="Permission required" ;;
  *)                   URGENCY="normal"   ; BODY="Needs attention" ;;
esac

# Desktop notification with a generic title/body to avoid leaking work context
# during screen sharing, notification sync, or lock-screen display.
(
  ACTION=$(dunstify --action="focus,Focus" -u "$URGENCY" "Claude" "$BODY")
  if [ "$ACTION" = "focus" ]; then
    i3-msg '[class="kitty"]' focus >/dev/null 2>&1
    TARGET=$(tmux list-panes -a -F '#{pane_current_path} #{pane_current_command} #{session_name}:#{window_index}.#{pane_index}' 2>/dev/null | grep -F "$CWD" | grep ' claude ' | head -1 | awk '{print $3}')
    [ -n "$TARGET" ] && tmux switch-client -t "$TARGET" 2>/dev/null
  fi
) &
disown

exit 0
