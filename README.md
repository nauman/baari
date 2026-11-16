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

## Daily work in v0.27.1

Architecture governs execution; Workbench is optional. In a repository that has
explicitly adopted the daily flow, one owning work item holds outcome, scope,
acceptance, governance references and wave assignment.

```sh
baari work show WORK-001
baari work start WORK-001
# Implement the bounded outcome.
baari work check WORK-001
baari work reconcile WORK-001
baari work finish WORK-001 --summary "Invoice download verified"
baari work log WORK-001
```

Ordinary operations record portable activity and acceptance receipts. The worklog
joins those records with available delivery facts. Reconciliation reads by default;
projection writes require explicit apply with the exact expected revision. Finish
neither commits nor ships. Pending human review is a handoff, not permission for
an agent to invent approval or keep widening the feature.

Fresh repositories may opt in with `baari work init --daily`, then `work add` and
`work edit`. Existing repositories retain their legacy owners until explicit
adoption. Ambiguous prose/group/provider-owner migration, machine-local active
selection and wave-exit attestation remain unsupported. Use `--help` rather than
assuming flags. See [the invoice walkthrough](walkthrough/README.md).

See the [Baari landing page](https://baari.kuickr.co/) for the current
command surface and shipped-versus-planned boundary.

## Publishing the site

The public site is hosted in the dev-docs Space on Kuickr at
[baari.kuickr.co](https://baari.kuickr.co/). Only explicitly selected public pages
are served; private documentation stays private. GitHub Pages keeps the installer,
release ledger and a forwarding home page.

`landing.html` owns the public landing copy. Run `python3 tools/build-kuickr.py`
to produce `.kuickr-build/index.html` from that source, the release-generated
`commands.json`, and the pinned Nodepad tokens. Publish that output to the
existing `dev-docs-74/baari/index.html` Page; do not edit the hosted projection.
The build inlines the exact ledger so the sandbox does not need private asset
access. New releases must rebuild and republish this projection after the release
runner refreshes `commands.json`.
