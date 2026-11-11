---
expect:
  applicationId: string
  status: [tailored, applied, screening, interview, offer, rejected, withdrawn, ghosted]
---

{
  "id": "1b7e2f3a-4c5d-4e6f-9071-8293a4b5c6d7",
  "company": "Litware",
  "role": "Backend Engineer",
  "status": "{{input.status}}",
  "appliedDate": "2026-10-14T00:00:00+00:00",
  "nextDate": "{{input.nextDate}}",
  "notes": "Panel with the platform team",
  "updatedAt": "2026-11-03T15:40:00+00:00",
  "sessionId": null,
  "resumeId": null,
  "trackerUrl": "https://app.workhunt.ai/applications"
}
