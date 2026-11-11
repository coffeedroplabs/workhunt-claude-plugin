---
type: llm
---

The track skill records the application without asking first, then states the dates it resolved so the user can correct them.
PASS if the reply says Contoso, Software Engineer was added (logged, added or tracked all count) and gives both the applied date and the phone screen date as calendar dates. Offering to fix a date if it is wrong is what the skill asks for, not a request for confirmation.
Ignore whether the dates are right and whether the reply links the tracker: other graders check the recorded dates and the link.
FAIL if it says it has not recorded the application yet and asks whether to, omits either date, or says it updated an existing application.
