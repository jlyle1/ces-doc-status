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

The response depends on whether the client asked about a status.

| Request | Response |
|---|---|
| Search with no status filter | 200, in-scope notes only, no OperationOutcome |
| `tiuDocumentStatus=SIGNED` (or `COMPLETED`, accepted as a synonym) | 200, notes reported as SIGNED |
| `tiuDocumentStatus=AMENDED` (any unserved VistA TIU status, or `doc-status=amended`) | 400, OperationOutcome `not-supported` ([example](OperationOutcome-tiu-status-amended-not-supported.html)) |
| `tiuDocumentStatus=SIGNED,AMENDED` | 400 for the whole request, naming only `AMENDED` ([example](OperationOutcome-tiu-status-mixed-not-supported.html)) |
| `tiuDocumentStatus=FINAL` (in neither TIU status code system) | 400, OperationOutcome `code-invalid` ([example](OperationOutcome-tiu-status-unknown-code.html)) |
| Read of an out-of-scope note by id | 404 |

**A filtered search gets an explicit answer.** A client that names a status is asking about documents in that status. An empty Bundle would tell it there are none, which is false: they may exist in VistA, and this API does not search for or return them. A 400 says the question can't be answered here. A mixed list is rejected as a whole for the same reason; returning only the served values would imply the rest are known not to exist.

**An unfiltered search does not.** It asks for no status in particular, so the standing scope rule, stated once in the CapabilityStatement, is sufficient. Attaching an OperationOutcome to every response would be noise that clients learn to ignore. `206 Partial Content` is not used: it belongs to HTTP range requests and does not mean "some records are out of scope."

**`not-supported` vs `code-invalid`.** A real VistA TIU status that CES does not serve is `not-supported`; a value in neither TIU status code system is `code-invalid`. Each carries a code from [CES Search Error Codes](CodeSystem-ces-search-error.html) in `details.coding`, so clients can branch without parsing text. `Prefer: handling` does not change any of these responses: it governs unknown parameters, and these parameters are known.

**Reads return 404,** consistent with search: an out-of-scope note is not a resource this API exposes, and 403 would wrongly suggest that different credentials could retrieve it.

### Testing

`input/tests/` contains four invalid instances that are not built into the guide. With the FHIR validator, each one fails on exactly one rule:

| File | Fails on |
|---|---|
| DocumentReference-invalid-unsigned-final.json | ces-docstatus-1 |
| DocumentReference-invalid-completed-preliminary.json | ces-docstatus-2 |
| DocumentReference-invalid-undictated.json | required binding on the VistA coding (UNDICTATED is not served) |
| DocumentReference-invalid-vista-ces-mismatch.json | ces-docstatus-3 (CES SIGNED with VistA UNSIGNED) |
