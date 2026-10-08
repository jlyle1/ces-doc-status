### Lighthouse and CES

Clients call Lighthouse. Lighthouse obtains TIU notes from CES and presents them as this guide describes. CES does none of that work: it does not enforce the profile or reject unserved statuses, it uses status labels of its own, and its responses resemble FHIR without reliably conforming to it. Lighthouse is responsible for everything a client sees:

- **Status values.** Lighthouse reports VistA TIU statuses. Where CES uses its own label (SIGNED for COMPLETED), Lighthouse translates it.
- **Conformance.** Lighthouse builds each DocumentReference so that it conforms to the profile, whatever form CES's response takes. CES output is input to Lighthouse, not something Lighthouse passes through.
- **Scope.** Lighthouse returns only notes in the three served statuses, and drops anything else CES returns.
- **Search.** Lighthouse checks status filters before calling CES, rejects unserved and unknown values itself, and translates the rest into CES's terms.
- **Errors.** Lighthouse returns the error responses described below. It never turns an upstream failure into an empty result.

[Upstream: CES](upstream-ces.html) describes the CES side of the interface.

### Artifact design responsibilities

The design separates what constrains instances from what explains them.

**Bindings constrain values.** `docStatus` is bound (required) to preliminary and final. The VistA TIU status carried in alternate-codes is bound (required) to UNSIGNED, UNCOSIGNED and COMPLETED. These bindings are the normative statement of data availability: an instance carrying any other value is invalid.

**Invariants constrain pairings.** Bindings check each value on its own, so on their own they would accept `docStatus = final` with a TIU status of UNSIGNED. Invariants `lh-docstatus-1` and `lh-docstatus-2` close that gap by requiring UNSIGNED or UNCOSIGNED to pair with `preliminary`, and COMPLETED with `final`. Both are checked by the standard FHIR validator.

**The ConceptMap explains.** The TIU-to-docStatus ConceptMap is not needed for conformance. It documents the relationship between the full VistA TIU status list and `docStatus`, and it records the statuses Lighthouse excludes as `unmatched` rather than leaving them silently absent. It is linked from the profile through the [elementdefinition-conceptmap](http://hl7.org/fhir/extensions/StructureDefinition-elementdefinition-conceptmap.html) extension on the `docStatus` binding's value set, so a reader of the profile can find it.

### Why carry the TIU status in the resource

UNSIGNED and UNCOSIGNED both become `preliminary`, so `docStatus` alone loses the distinction. Carrying the TIU status on `docStatus` keeps it available to clients, and it gives the `tiu-document-status` search parameter an element to index. A search parameter evaluated only against the source system, with no corresponding element, would be legal FHIR, but clients could not verify the results.

The standard `alternate-codes` extension was chosen instead of a new extension because it is defined for exactly this use: an alternate coding, with equivalent meaning, of the concept represented by a `code`.

### VistA values, not CES labels

CES reports COMPLETED as SIGNED. SIGNED is not a VistA TIU status (the TIU STATUS file, #8925.6, has no such entry), and it carries no distinction a client needs: it means the same as COMPLETED. Exposing it would tie the Lighthouse API to an upstream naming choice and put a value in the TIU status extension that does not exist in the source system. Lighthouse therefore reports COMPLETED and searches on COMPLETED. A client that sends SIGNED gets `code-invalid`, like any other value outside the VistA code system.

The CES labels and the translation are recorded on the [upstream page](upstream-ces.html), so the mapping is documented without being part of the public contract.

### Search

R4 defines no search parameter on `DocumentReference.docStatus` (R5 adds `doc-status`), so this guide defines one with the same code.

`tiu-document-status` follows the FHIR convention for search parameter codes (lowercase, hyphenated). The name deliberately echoes CES's `tiuDocumentStatus`, so the correspondence is easy to see, while the different spelling marks the different layer: `tiu-document-status` takes VistA values and is answered by Lighthouse; `tiuDocumentStatus` takes CES values and is answered by CES. It uses this expression:

`DocumentReference.docStatus.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept)`

alternate-codes is a simple extension with a CodeableConcept value, so the expression ends at the value. It does not drill into sub-extensions the way US Core's race parameter does. Token matching against a CodeableConcept checks its codings.

### Excluded statuses at runtime

The response depends on whether the client asked about a status. See [Example queries](#example-queries) for each case.

**A filtered search gets an explicit answer.** A client that names a status is asking about documents in that status. An empty Bundle would tell it there are none, which is false: they may exist in VistA, and this API does not search for or return them. A 400 says the question can't be answered here. A mixed list is rejected as a whole for the same reason; returning only the served values would imply the rest are known not to exist. Because the served statuses are fixed, Lighthouse makes this check itself, before calling CES.

**An unfiltered search does not.** It asks for no status in particular, so the standing scope rule, stated once in the CapabilityStatement, is sufficient. Attaching an OperationOutcome to every response would be noise that clients learn to ignore. `206 Partial Content` is not used: it belongs to HTTP range requests and does not mean "some records are out of scope."

**`not-supported` vs `code-invalid`.** A real VistA TIU status that Lighthouse does not serve is `not-supported`; a value outside the VistA TIU Status code system is `code-invalid`. Each carries a code from [Lighthouse Search Error Codes](CodeSystem-lighthouse-search-error.html) in `details.coding`, so clients can branch without parsing text. `Prefer: handling` does not change any of these responses: it governs unknown parameters, and these parameters are known.

**Upstream failure is an error, not an empty result.** If CES fails, times out or returns something Lighthouse cannot use, Lighthouse returns 502, 503 or 504 with an OperationOutcome (`transient`, `upstream-error`). It does not return an empty or partial Bundle, for the same reason it does not return an empty Bundle for AMENDED: the client would read it as "none."

**Reads return 404,** consistent with search: an out-of-scope note is not a resource this API exposes, and 403 would wrongly suggest that different credentials could retrieve it.

### Example queries

Each query below has an example response in this guide. The patient `example-patient` has three notes in scope: one UNSIGNED, one UNCOSIGNED and one COMPLETED.

**Queries that succeed (HTTP 200)**

| Query | Result | Example |
|---|---|---|
| `DocumentReference?patient=example-patient` | All three notes. No OperationOutcome. | [search-unfiltered](Bundle-search-unfiltered.html) |
| `…&tiu-document-status=UNSIGNED,UNCOSIGNED` | The two preliminary notes. `doc-status=preliminary` returns the same. | [search-tiu-preliminary](Bundle-search-tiu-preliminary.html) |
| `…&tiu-document-status=COMPLETED` | The completed note. | [search-tiu-completed](Bundle-search-tiu-completed.html) |
| `…&tiu-document-status=http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status\|COMPLETED` | Same as COMPLETED, using `system\|code`. | [search-tiu-completed](Bundle-search-tiu-completed.html) |
| `…&doc-status=final` | Same as COMPLETED. | [search-tiu-completed](Bundle-search-tiu-completed.html) |
| `DocumentReference?patient=other-patient&tiu-document-status=UNCOSIGNED` | Empty Bundle. UNCOSIGNED is served, so "none" is true. | [search-served-status-none-found](Bundle-search-served-status-none-found.html) |

**Queries that fail (HTTP 400, OperationOutcome)**

| Query | Issue code | Why | Example |
|---|---|---|---|
| `…&tiu-document-status=AMENDED` | `not-supported` | A real VistA TIU status that Lighthouse does not serve. Any of the other excluded statuses gets the same response. | [tiu-amended-not-supported](OperationOutcome-tiu-amended-not-supported.html) |
| `…&tiu-document-status=COMPLETED,AMENDED` | `not-supported` | One unserved value rejects the whole request. The issue names only AMENDED. | [tiu-mixed-not-supported](OperationOutcome-tiu-mixed-not-supported.html) |
| `…&doc-status=amended` | `not-supported` | A valid docStatus that Lighthouse does not serve. | [doc-status-amended-not-supported](OperationOutcome-doc-status-amended-not-supported.html) |
| `…&tiu-document-status=SIGNED` | `code-invalid` | Not a VistA TIU status. | [tiu-unknown-code](OperationOutcome-tiu-unknown-code.html) |
| `…&tiu-document-status=completed` | `code-invalid` | Codes are case-sensitive. Same response shape as SIGNED. | [tiu-unknown-code](OperationOutcome-tiu-unknown-code.html) |

**Upstream failure (HTTP 502, 503 or 504, OperationOutcome)**

| Query | Issue code | Why | Example |
|---|---|---|---|
| Any search or read | `transient` | CES failed, timed out or returned an unusable response. | [upstream-unavailable](OperationOutcome-upstream-unavailable.html) |

**Read**

| Request | Result |
|---|---|
| `GET DocumentReference/{id}` for a note in scope | 200, the note |
| `GET DocumentReference/{id}` for an out-of-scope note (e.g. AMENDED) | 404 Not Found |

Profile conformance is checked separately: `input/tests/` holds invalid DocumentReference instances, not built into the guide, each failing one profile rule under the FHIR validator.
