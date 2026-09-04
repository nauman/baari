# baari — compiled releases

Public distribution repository for Baari, a local-first CLI for cross-repo
coordination, documentation health, delivery sequences, CI guardrails,
worktrees, and test databases.

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
