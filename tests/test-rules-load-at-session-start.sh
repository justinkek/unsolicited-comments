#!/usr/bin/env bash

. "$(dirname "$0")/built.sh"

REPOSITORY="$(cd "$(dirname "$0")/.." && pwd)"
LOADER="$BUILT_HOOKS/load-rules.sh"

pass=0
fail=0

assert() {
  local label="$1" outcome="$2" detail="$3"
  if [ "$outcome" = "0" ]; then
    printf "  PASS  %s\n" "$label"
    pass=$((pass + 1))
  else
    printf "  FAIL  %s — %s\n" "$label" "$detail"
    fail=$((fail + 1))
  fi
}

home="$(mktemp -d)"
trap 'rm -rf "$home"' EXIT

printf "Test group: a session is handed the rules the refusal enforces\n"

said="$(printf '{"hook_event_name":"SessionStart","session_id":"s"}' | env HOME="$home" bash "$LOADER" 2>/dev/null)"

printf '%s' "$said" | jq --exit-status '.hookSpecificOutput.hookEventName == "SessionStart"' >/dev/null 2>&1
assert "the loader answers SessionStart in JSON" "$?" "it printed '$(printf '%s' "$said" | head -c 60)'"

carried="$(printf '%s' "$said" | jq --raw-output '.hookSpecificOutput.additionalContext' 2>/dev/null)"
[ "$carried" = "$(cat "$REPOSITORY/rules/comments.md")" ]
assert "and carries rules/comments.md whole" "$?" "the session reads something other than the rules file"

printf '%s' "$carried" | grep --quiet --fixed-strings 'refused outright'
assert "the rules say the refusal has no escape hatch" "$?" "a session would ask to be let through"

plain="$(printf '{}' | env HOME="$home" bash "$LOADER" 2>/dev/null)"
[ "$plain" = "$(cat "$REPOSITORY/rules/comments.md")" ]
assert "a hand run prints the rules as text" "$?" "a person piping it by hand reads JSON"

printf "\n%d passed, %d failed\n" "$pass" "$fail"
[ "$fail" -eq 0 ]
