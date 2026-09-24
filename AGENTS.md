# Working in this repository

(audience: agents)

Two things reach a session: `rules/comments.md`, which `hooks/load-rules.sh`
prints at session start, and `hooks/refuse-a-comment.sh`, which runs before
every tool call and denies an edit that adds a comment line to code.

The rules say an edit that adds a comment is refused, and the hook is what makes
that true. A change to what the hook refuses is a change to what the rules
promise, so both land in the same pull request.

This plugin is built by the ai-plugin-sdk. `./build` calls it: the SDK is a
checkout at `../ai-plugin-sdk`, or wherever `AI_PLUGIN_SDK` names.

## Before you push

    tests/run-tests                                 this plugin's own behaviour
    ../ai-plugin-sdk/tests/run-tests "$PWD"         the SDK's, against this plugin

CI runs both.

## Every merge is a release

An install names no ref, so what main points at is what a person gets. Every
merge raises the version, in `plugin.json` and in `package.json`, which a test
holds together. CI fails a pull request whose version matches its base.

## Where a change belongs

| Change | File |
| --- | --- |
| a rule a session must follow | `rules/comments.md` |
| what counts as a comment, and which files are exempt | `hooks/refuse-a-comment.sh`, with a case in `tests/test-refuse-a-comment.sh` |
| what a shell command is read for | `hooks/refuse-a-comment.sh`, with a case in `tests/test-refuse-a-comment-bash.sh` |
| which hooks run on which event | `plugin.json` |
| the prose around the install table | `install-page/` |
| what an install copies | nothing by hand - `distributions/` is built by `./build` |

`distributions/`, `INSTALL.md` and `COMPATIBILITY.md` are generated and
committed, because an install fetches files from the repository. Run `./build`
after changing anything it copies. The SDK's suite rebuilds and fails on any
difference.

This plugin knows nothing of the repository it was extracted from, and a test
refuses any word that would say otherwise.
