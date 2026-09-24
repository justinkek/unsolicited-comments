# unsolicited-comments

(audience: humans)

Code that explains itself.

An agent writing code reaches for a comment to say what a name or a test should
have said. This plugin refuses the edit. Every `Edit`, `Write` and shell command
that would add a comment line to code is denied before it runs, and the session
is told how to carry what the comment would have said instead:

1. assert the invariant at runtime, using a value the code already has
2. rename the function or variable so the constraint reads off the code
3. write a test whose failure teaches it
4. write it up in the repository's own docs, separate from the code

There is no escape hatch. A yes in chat does not unlock it; where none of those
four can carry it, the agent says what it would have written and where, and a
person adds it by hand.

## What counts as a comment

Only the lines an edit adds. A comment already in the file, or one that was
moved or re-indented, is not a new one.

| Refused | Left alone |
| --- | --- |
| `//`, `#`, `/* */` and ` * ` lines in code | a shebang |
| a header block at the top of a new file | a licence header: `SPDX-License-Identifier`, `Copyright`, `Licensed under` |
| a heredoc, `printf >`, `tee` or `sed -i` writing one | `#include`, `#define` and other directives in C family files |
| | markdown, text, JSON, YAML, TOML, ignore files, Dockerfiles, Makefiles |
| | comment markers inside a quoted string |

## Installing

[INSTALL.md](INSTALL.md) has a page per client, and
[COMPATIBILITY.md](COMPATIBILITY.md) says what runs where. The refusal is a hook,
so a client that runs no hooks gets the rules and nothing enforcing them.
