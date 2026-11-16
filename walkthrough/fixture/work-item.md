---
schema: baari-work-item/v1
id: WORK-001
title: Download an owned invoice as CSV
state: ready
kind: task
owner: demo-agent
outcome: A customer downloads their own invoice as a usable CSV
scope:
  - Authorize invoice access and return the existing CSV format
exclusions:
  - Payment processing, provider integrations and UI changes
architecture:
  - architecture.md
headless: true
acceptance:
  - id: CSV-OWNER
    description: Owner receives the expected CSV and another customer is denied
    verify: [python3, check_invoice.py]
---

Fictional service-level demonstration. No real customer data or payment provider.
