Lighthouse supports one status search parameter, `docStatus`. It serves `preliminary` and `final` notes only. Each query below has an example response in this guide. The patient `example-patient` has three notes in scope: two `preliminary` and one `final`. [Design](design.html#excluded-statuses-at-runtime) explains the reasoning.

### Queries that succeed (HTTP 200)

| Query | Result | Example |
|---|---|---|
| `DocumentReference?patient=example-patient` | All three notes. No OperationOutcome. | [search-unfiltered](Bundle-search-unfiltered.html) |
| `…&docStatus=preliminary` | The two preliminary notes. | [search-preliminary](Bundle-search-preliminary.html) |
| `…&docStatus=final` | The final note. | [search-final](Bundle-search-final.html) |
| `…&docStatus=http://hl7.org/fhir/composition-status\|final` | Same as `final`, using `system\|code`. | [search-final](Bundle-search-final.html) |
| `…&docStatus=preliminary,final` | All three notes, the same as no filter. | [search-unfiltered](Bundle-search-unfiltered.html) |
| `DocumentReference?patient=other-patient&docStatus=preliminary` | Empty Bundle. `preliminary` is served, so "none" is true. | [search-served-status-none-found](Bundle-search-served-status-none-found.html) |

### Queries that fail (HTTP 400, OperationOutcome)

| Query | Issue code | Why | Example |
|---|---|---|---|
| `…&docStatus=amended` | `not-supported` | A valid docStatus that Lighthouse does not serve. | [docstatus-amended-not-supported](OperationOutcome-docstatus-amended-not-supported.html) |
| `…&docStatus=entered-in-error` | `not-supported` | Same as `amended`. | [docstatus-amended-not-supported](OperationOutcome-docstatus-amended-not-supported.html) |
| `…&docStatus=final,amended` | `not-supported` | One unserved value rejects the whole request. The issue names only `amended`. | [docstatus-mixed-not-supported](OperationOutcome-docstatus-mixed-not-supported.html) |
| `…&docStatus=signed` | `code-invalid` | Not a docStatus code. | [docstatus-unknown-code](OperationOutcome-docstatus-unknown-code.html) |
| `…&docStatus=Final` | `code-invalid` | Codes are case-sensitive. Same response shape as `signed`. | [docstatus-unknown-code](OperationOutcome-docstatus-unknown-code.html) |

### Upstream failure (HTTP 502, 503 or 504, OperationOutcome)

| Query | Issue code | Why | Example |
|---|---|---|---|
| Any search or read | `transient` | An internal service failed, timed out or returned an unusable response. | [upstream-unavailable](OperationOutcome-upstream-unavailable.html) |

### Read

| Request | Result |
|---|---|
| `GET DocumentReference/{id}` for a note in scope | 200, the note |
| `GET DocumentReference/{id}` for an out-of-scope note (e.g. amended) | 404 Not Found |
