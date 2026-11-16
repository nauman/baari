# Baari walkthrough: daily work, dashboard and threads

The approved revised walkthrough introduces Baari, shows its read-only local
operator dashboard and repository threads, then follows an invoice CSV task
through architecture, bounded work, checks, reconciliation and a shared worklog.
It closes with the product URL, installation and `baari explain`.

The isolated Python service, thread actors and dashboard registry are fictional
demo fixtures using released Baari v0.27.1 commands. This is an explanatory demo,
not a production billing integration.
The video combines captured command output with explanatory title cards; it does
not claim to record Claude, Codex or Gemini executing autonomously.

The narration source is [narration.json](narration.json). Voice: AI-generated
Aiden, using the approved relaxed conversational instruction from the existing
Kuickr voice-production guide. Captions follow the same script.

The work item references governing architecture, one authorization boundary and
CSV-export acceptance. The demonstrated sequence is `work start`, `work check`,
`work reconcile`, `work finish`, and `work log`. Wave membership is explicit.
A workflow finish is not a commit or release.
