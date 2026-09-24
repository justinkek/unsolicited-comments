#!/usr/bin/env bash

payload="$(cat)"

rules="$(dirname "$0")/../rules/comments.md"
[ -f "$rules" ] || exit 0

. "$(dirname "$0")/lib/say.sh"

hook_say "$(hook_event_of "$payload")" < "$rules"
