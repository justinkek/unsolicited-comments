## Which version is installed

    claude plugin list

ZCode lists it in Settings, Marketplace instead, and any session can be asked:
every skill says the version it was built from.

## Where the refusal runs

The refusal is a hook that runs before a tool call. A client that runs no hooks
still gets the rules through the reload skill, but nothing refuses the edit.
Codex hands the hook its shell commands, so a comment written through a shell
redirect is refused there and one written through a patch is not.

## What a removal leaves behind

Nothing: the uninstall steps remove the directory the plugin keeps to itself,
`~/.unsolicited-comments`, along with the plugin.
