### Artifact design responsibilities

The design separates what constrains instances from what explains them.

**Bindings constrain values.** `docStatus` is bound (required) to preliminary and final. The TIU status carried in alternate-codes is bound (required) to UNSIGNED, UNCOSIGNED and COMPLETED. These bindings are the normative statement of data availability: an instance carrying any other value is invalid.

**Invariants constrain pairings.** Bindings check each value on its own, so on their own they would accept `docStatus = final` with a TIU status of UNSIGNED. Invariants `ces-docstatus-1` and `ces-docstatus-2` close that gap by requiring UNSIGNED or UNCOSIGNED to pair with `preliminary`, and COMPLETED with `final`. Both are checked by the standard FHIR validator.

**The ConceptMap explains.** The ConceptMap is not needed for conformance. It documents the relationship between the full VistA TIU status list and `docStatus`, and it records the statuses CES excludes as `unmatched` rather than leaving them silently absent. It is linked from the profile through the [elementdefinition-conceptmap](http://hl7.org/fhir/extensions/StructureDefinition-elementdefinition-conceptmap.html) extension on the `docStatus` binding's value set, so a reader of the profile can find it.

### Why carry the TIU status in the resource

UNSIGNED and UNCOSIGNED both become `preliminary`, so `docStatus` alone loses the distinction. Carrying the source value on `docStatus` keeps it available to clients, and it gives the `tiu-status` search parameter an element to index. A search parameter evaluated only against VistA, with no corresponding element, would be legal FHIR, but clients could not verify the results, and a generic FHIR server could not support it.

The standard `alternate-codes` extension was chosen instead of a new extension because it is defined for exactly this use: an alternate coding, with equivalent meaning, of the concept represented by a `code`.

### Search

R4 defines no search parameter on `DocumentReference.docStatus` (R5 adds `doc-status`), so this guide defines one with the same code. The `tiu-status` parameter uses this expression:

`DocumentReference.docStatus.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept)`

alternate-codes is a simple extension with a CodeableConcept value, so the expression ends at the value. It does not drill into sub-extensions the way US Core's race parameter does. Token matching against a CodeableConcept checks its codings.

### Excluded statuses at runtime

The response depends on whether the client asked about a status.

| Request | Response |
|---|---|
| Search with no status filter | 200, in-scope notes only, no OperationOutcome |
| `tiu-status=AMENDED` (any unserved TIU status, or `doc-status=amended`) | 400, OperationOutcome `not-supported` ([example](OperationOutcome-tiu-status-amended-not-supported.html)) |
| `tiu-status=COMPLETED,AMENDED` | 400 for the whole request, naming only `AMENDED` ([example](OperationOutcome-tiu-status-mixed-not-supported.html)) |
| `tiu-status=SIGNED` (not a TIU status code) | 400, OperationOutcome `code-invalid` ([example](OperationOutcome-tiu-status-unknown-code.html)) |
| Read of an out-of-scope note by id | 404 |

**A filtered search gets an explicit answer.** A client that names a status is asking about documents in that status. An empty Bundle would tell it there are none, which is false: they may exist in VistA, and this API does not search for or return them. A 400 says the question can't be answered here. A mixed list is rejected as a whole for the same reason; returning only the served values would imply the rest are known not to exist.

**An unfiltered search does not.** It asks for no status in particular, so the standing scope rule, stated once in the CapabilityStatement, is sufficient. Attaching an OperationOutcome to every response would be noise that clients learn to ignore. `206 Partial Content` is not used: it belongs to HTTP range requests and does not mean "some records are out of scope."

**`not-supported` vs `code-invalid`.** A real TIU status that CES does not serve is `not-supported`; a value outside the code system is `code-invalid`. Each carries a code from [CES Search Error Codes](CodeSystem-ces-search-error.html) in `details.coding`, so clients can branch without parsing text. `Prefer: handling` does not change any of these responses: it governs unknown parameters, and these parameters are known.

**Reads return 404,** consistent with search: an out-of-scope note is not a resource this API exposes, and 403 would wrongly suggest that different credentials could retrieve it.

### Testing

`input/tests/` contains three invalid instances that are not built into the guide. With the FHIR validator, each one fails on exactly one rule:

| File | Fails on |
|---|---|
| DocumentReference-invalid-unsigned-final.json | ces-docstatus-1 |
| DocumentReference-invalid-completed-preliminary.json | ces-docstatus-2 |
| DocumentReference-invalid-undictated.json | required binding to CES-served TIU statuses |
