# Baari v0.27.1 · launch drafts

## LinkedIn

I built Baari to help people and coding agents keep track of repository work.
Then I watched the workflow become part of the problem: too many records to
connect, too many steps just to explain what happened.

Baari v0.27.1 adds a simpler daily flow: one work item, an explicit delivery wave,
acceptance checks, and a consolidated worklog.

The part I care about most is what stays underneath it. Architecture still governs
the change. Agents get a bounded handoff. Failed or stale required checks block
completion. Finishing a task does not magically mean it shipped.

The demo follows one small job: downloading an invoice as CSV while keeping another
customer’s invoice inaccessible. The next agent can read the work and its evidence
from the repository instead of reconstructing it from a chat.

It’s written in Go, local first, and designed for developers working with Claude,
Codex or Gemini. Existing repositories opt in explicitly.

Release and installation: https://github.com/nauman/baari/releases/tag/v0.27.1

I’d like to hear where your agent workflow loses context today.

## X / tweet

Baari v0.27.1: simpler daily work for people and coding agents.

One work item. Explicit waves. Acceptance checks. A shared worklog.

Architecture stays required. Finished ≠ shipped.

Go. Local first. Explicit opt-in.

https://github.com/nauman/baari

## Asset notes

Use the launch image or the narrated invoice walkthrough. The demo is fictional;
the CLI output is captured from the released binary. Voice is AI-generated Aiden.
The new baari.kuickr.co address is excluded from launch claims until verified live.
