### Artifact design responsibilities

The design separates what constrains instances from what explains them.

**Bindings constrain values.** `docStatus` is bound (required) to preliminary and final. The CES TIU status carried in alternate-codes is bound (required) to UNSIGNED, UNCOSIGNED and SIGNED, and the optional VistA coding beside it to UNSIGNED, UNCOSIGNED and COMPLETED. These bindings are the normative statement of data availability: an instance carrying any other value is invalid.

**Invariants constrain pairings.** Bindings check each value on its own, so on their own they would accept `docStatus = final` with a TIU status of UNSIGNED. Invariants `ces-docstatus-1` and `ces-docstatus-2` close that gap by requiring UNSIGNED or UNCOSIGNED to pair with `preliminary`, and SIGNED with `final`. `ces-docstatus-3` requires a VistA coding, when present, to agree with the CES coding. Both are checked by the standard FHIR validator.

**The ConceptMap explains.** The ConceptMap is not needed for conformance. It documents the relationship between the full VistA TIU status list and `docStatus`, and it records the statuses CES excludes as `unmatched` rather than leaving them silently absent. It is linked from the profile through the [elementdefinition-conceptmap](http://hl7.org/fhir/extensions/StructureDefinition-elementdefinition-conceptmap.html) extension on the `docStatus` binding's value set, so a reader of the profile can find it.

### Why carry the TIU status in the resource

UNSIGNED and UNCOSIGNED both become `preliminary`, so `docStatus` alone loses the distinction. Carrying the source value on `docStatus` keeps it available to clients, and it gives the `tiuDocumentStatus` search parameter an element to index. A search parameter evaluated only against VistA, with no corresponding element, would be legal FHIR, but clients could not verify the results, and a generic FHIR server could not support it.

The standard `alternate-codes` extension was chosen instead of a new extension because it is defined for exactly this use: an alternate coding, with equivalent meaning, of the concept represented by a `code`.

### SIGNED and COMPLETED

CES reports VistA's COMPLETED status as SIGNED. SIGNED is not a VistA TIU status, so adding it to the VistA TIU Status code system would misstate VistA, and using COMPLETED in the CES specification would misstate CES. The guide keeps both:

- **[VistA TIU Status](CodeSystem-vista-tiu-status.html)** holds the 14 entries of the TIU STATUS file (#8925.6), unchanged.
- **[CES TIU Status](CodeSystem-ces-tiu-status.html)** holds the three labels CES uses: UNSIGNED, UNCOSIGNED and SIGNED. Each definition names the VistA status it stands for.
- **[VistA TIU Status to CES TIU Status](ConceptMap-vista-tiu-status-to-ces-tiu-status.html)** states the correspondence: UNSIGNED and UNCOSIGNED `equal`, COMPLETED to SIGNED `equivalent` (same meaning, different label).

UNSIGNED and UNCOSIGNED appear in both code systems. The CES codes are not new concepts; they exist so that every value CES emits comes from one system, and a client can search and validate against that system alone.

On the wire, the alternate-codes CodeableConcept carries the CES coding (required) and may also carry the VistA coding. When both are present, they are two codings of the same concept, which is what a CodeableConcept is for. A CES-only instance is fully conformant; the VistA coding is there for clients that need the source value.

### Search

R4 defines no search parameter on `DocumentReference.docStatus` (R5 adds `doc-status`), so this guide defines one with the same code.

`tiuDocumentStatus` is the name CES already accepts, so the guide declares it under that name rather than renaming it. FHIR convention favors lowercase, hyphenated codes (`tiu-document-status`), but changing a working parameter name would break existing clients for no gain in meaning. It uses this expression:

`DocumentReference.docStatus.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept)`

alternate-codes is a simple extension with a CodeableConcept value, so the expression ends at the value. It does not drill into sub-extensions the way US Core's race parameter does. Token matching against a CodeableConcept checks its codings.

### Excluded statuses at runtime

The response depends on whether the client asked about a status. See [Example queries](#example-queries) for each case.

**A filtered search gets an explicit answer.** A client that names a status is asking about documents in that status. An empty Bundle would tell it there are none, which is false: they may exist in VistA, and this API does not search for or return them. A 400 says the question can't be answered here. A mixed list is rejected as a whole for the same reason; returning only the served values would imply the rest are known not to exist.

**An unfiltered search does not.** It asks for no status in particular, so the standing scope rule, stated once in the CapabilityStatement, is sufficient. Attaching an OperationOutcome to every response would be noise that clients learn to ignore. `206 Partial Content` is not used: it belongs to HTTP range requests and does not mean "some records are out of scope."

**`not-supported` vs `code-invalid`.** A real VistA TIU status that CES does not serve is `not-supported`; a value in neither TIU status code system is `code-invalid`. Each carries a code from [CES Search Error Codes](CodeSystem-ces-search-error.html) in `details.coding`, so clients can branch without parsing text. `Prefer: handling` does not change any of these responses: it governs unknown parameters, and these parameters are known.

**Reads return 404,** consistent with search: an out-of-scope note is not a resource this API exposes, and 403 would wrongly suggest that different credentials could retrieve it.

### Example queries

Each query below has an example response in this guide. The patient `example-patient` has three notes in scope: one UNSIGNED, one UNCOSIGNED and one SIGNED.

**Queries that succeed (HTTP 200)**

| Query | Result | Example |
|---|---|---|
| `DocumentReference?patient=example-patient` | All three notes. No OperationOutcome. | [search-unfiltered](Bundle-search-unfiltered.html) |
| `…&tiuDocumentStatus=UNSIGNED,UNCOSIGNED` | The two preliminary notes. `doc-status=preliminary` returns the same. | [search-tiu-preliminary](Bundle-search-tiu-preliminary.html) |
| `…&tiuDocumentStatus=SIGNED` | The signed note. | [search-tiu-signed](Bundle-search-tiu-signed.html) |
| `…&tiuDocumentStatus=COMPLETED` | Same as SIGNED: COMPLETED is accepted as the VistA synonym. | [search-tiu-signed](Bundle-search-tiu-signed.html) |
| `…&tiuDocumentStatus=http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status\|SIGNED` | Same as SIGNED, using `system\|code`. | [search-tiu-signed](Bundle-search-tiu-signed.html) |
| `…&doc-status=final` | Same as SIGNED. | [search-tiu-signed](Bundle-search-tiu-signed.html) |
| `DocumentReference?patient=other-patient&tiuDocumentStatus=UNCOSIGNED` | Empty Bundle. UNCOSIGNED is served, so "none" is true. | [search-served-status-none-found](Bundle-search-served-status-none-found.html) |

**Queries that fail (HTTP 400, OperationOutcome)**

| Query | Issue code | Why | Example |
|---|---|---|---|
| `…&tiuDocumentStatus=AMENDED` | `not-supported` | A real VistA TIU status that CES does not serve. Any of the other excluded statuses gets the same response. | [tiu-status-amended-not-supported](OperationOutcome-tiu-status-amended-not-supported.html) |
| `…&tiuDocumentStatus=SIGNED,AMENDED` | `not-supported` | One unserved value rejects the whole request. The issue names only AMENDED. | [tiu-status-mixed-not-supported](OperationOutcome-tiu-status-mixed-not-supported.html) |
| `…&doc-status=amended` | `not-supported` | A valid docStatus that CES does not serve. | [doc-status-amended-not-supported](OperationOutcome-doc-status-amended-not-supported.html) |
| `…&tiuDocumentStatus=FINAL` | `code-invalid` | In neither TIU status code system. | [tiu-status-unknown-code](OperationOutcome-tiu-status-unknown-code.html) |
| `…&tiuDocumentStatus=signed` | `code-invalid` | Codes are case-sensitive. Same response shape as FINAL. | [tiu-status-unknown-code](OperationOutcome-tiu-status-unknown-code.html) |

**Read**

| Request | Result |
|---|---|
| `GET DocumentReference/{id}` for a note in scope | 200, the note |
| `GET DocumentReference/{id}` for an out-of-scope note (e.g. AMENDED) | 404 Not Found |

Profile conformance is checked separately: `input/tests/` holds invalid DocumentReference instances, not built into the guide, each failing one profile rule under the FHIR validator.
