### Three artifacts, three jobs

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

A search for a status CES does not serve returns an empty Bundle, not an error. The CapabilityStatement documents this. An OperationOutcome is not used to carry the exclusion, because no error condition arises and a notice would have to accompany every response.

### Testing

`input/tests/` contains three invalid instances that are not built into the guide. With the FHIR validator, each one fails on exactly one rule:

| File | Fails on |
|---|---|
| DocumentReference-invalid-unsigned-final.json | ces-docstatus-1 |
| DocumentReference-invalid-completed-preliminary.json | ces-docstatus-2 |
| DocumentReference-invalid-undictated.json | required binding to CES-served TIU statuses |
