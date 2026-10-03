# sample-6 — PRD

## Problem Statement

Teams that need a single aggregate figure from a catalog of scored records today have
no simple, dependable way to get one: they must fetch the raw records themselves and
compute the aggregate by hand, and they have no controlled way to exercise how an
aggregating caller behaves once the underlying catalog is unexpectedly empty.

## Solution

A two-service system: Service2 holds a fixed catalog of scored records and can be
switched, through an internal control, between serving its full catalog and serving an
empty one. Service1 asks Service2 for the current catalog and reports a single number —
the average score across all records — so any caller gets one dependable aggregate
without reading raw records itself.

## Actors

- **User** — any client that calls Service1 to get the current average score. Access is
open: no sign-in or credential is required.
- **Operator** — an internal role that switches Service2 between full mode and empty
mode through its internal operations endpoint, to exercise both catalog states. Never
a User, and never reachable through Service1 or any user-facing surface.

## User Stories

1. As a User, I want to call Service1 and get the average score of Service2's current
catalog, so that I get one dependable aggregate number without reading raw records
myself.
2. As a User, I want a request to a path Service1 does not serve to return a structured
404 body, so that I can tell a mistaken request apart from a valid response.
3. As an Operator, I want to switch Service2 between full mode and empty mode through
its internal operations endpoint, so that I can exercise both catalog states when
testing the system.

## Product Decisions

- Service1's average endpoint is open access: any client may call it, no sign-in or API
key is required.
- Service2's operations endpoint (the full/empty mode switch) is internal only — it is
never exposed through Service1, the API gateway, or any user-facing surface; only the
Operator reaches it.
- Service1 computes the average as the sum of every record's score divided by the
record count, discarding any remainder to return a whole number. The same computation
runs for every catalog Service2 serves — there is no separate path or separate result
for any particular catalog.
- Service2 starts in full mode and serves its empty catalog only after the Operator
switches it through the operations endpoint.
- Both Service1 and Service2 log how many records they handled per request.
- Service1's OpenAPI contract documents exactly one response for its average endpoint —
the successful average — with no 4xx or 5xx response documented on that operation.
The structured 404 applies only to paths Service1 does not serve.
- Service2's empty mode is in scope and is specified and validated like any other
catalog state it can serve.

## Out of Scope

- What Service1 returns when Service2's catalog is empty — not specified by this
project: no computed value, no default, and no error response for that case.
- Any empty-catalog variant, alternative response, or optional field on either
service's OpenAPI contract.
- Authentication or authorization for Service1 access — access is open by decision
above.
- Any user interface — this project is API-only; there is no web app.

## Open Questions

None — the brief fully specifies both services' behavior and data.

## Further Notes

Service2's full-mode catalog, reproduced verbatim for the spec and seed data:

With this full catalog, Service1's average is 35 (sum 358 ÷ 10 records, truncated).