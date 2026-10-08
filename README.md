# baari — compiled releases

Public distribution repository for Baari, a local-first CLI for cross-repo
coordination, documentation health, delivery sequences, CI guardrails,
worktrees, and test databases. Native work supports local groups/tasks/bugs,
Markdown owner pointers and named Jira/Linear connections. Lean plans bind
Architecture/Design and executable acceptance; revision-bound evidence and
derived ledgers keep workflow, verification and Git delivery distinct. Release,
publication and configured external-runner operations use the same CLI.

This repository contains the install page, standalone installer, and
checksummed release binaries. `commands.json` is the latest versioned command
ledger emitted by the binary and drives the landing page's non-executing
virtual terminal. Source code is not published here.

## Install

```sh
brew install nauman/tap/baari
```

Without Homebrew:

```sh
curl --proto '=https' --tlsv1.2 -fsSL https://nauman.github.io/baari/install.sh | sh
```

See the [Baari landing page](https://nauman.github.io/baari/) for the current
command surface and shipped-versus-planned boundary.
