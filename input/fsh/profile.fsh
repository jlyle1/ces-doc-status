// =====================================================================
// Profile: DocumentReference as served by CES from VistA TIU.
// Normative constraints live here: the two bindings and the pairing invariants.
// =====================================================================

Alias: $alternate-codes = http://hl7.org/fhir/StructureDefinition/alternate-codes
Alias: $ed-conceptmap = http://hl7.org/fhir/StructureDefinition/elementdefinition-conceptmap
Alias: $USCoreDocRef = http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference
Alias: $tiu = http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status

Profile: VistADocRefUnsignedUncosignedCompleted
Parent: $USCoreDocRef
Id: vista-docref-unsigned-uncosigned-completed
Title: "VistA DocumentReference (Unsigned, Uncosigned, Completed)"
Description: """
A US Core DocumentReference for a VistA TIU note as served by CES. Only notes whose TIU status is
UNSIGNED, UNCOSIGNED or COMPLETED are served. docStatus is limited to preliminary or final, and
the source TIU status is carried on docStatus in the alternate-codes extension.
"""
* ^status = #draft
* ^experimental = false

* obeys ces-docstatus-1 and ces-docstatus-2

// docStatus: required, constrained to the values CES emits
* docStatus 1..1 MS
* docStatus from CESDocStatus (required)
* docStatus ^short = "preliminary | final"
* docStatus ^definition = "preliminary for UNSIGNED or UNCOSIGNED TIU notes; final for COMPLETED TIU notes."
// Informative link from the bound value set to the ConceptMap that explains excluded TIU statuses
// (the extension context is ElementDefinition.binding.valueSet, not binding)
* docStatus ^binding.valueSet.extension[+].url = $ed-conceptmap
* docStatus ^binding.valueSet.extension[=].valueCanonical = Canonical(tiu-status-to-docstatus-completed-unsigned-uncosigned)

// Source TIU status, carried on docStatus
* docStatus.extension contains $alternate-codes named tiuStatus 1..1 MS
* docStatus.extension[tiuStatus] ^short = "Source VistA TIU status"
* docStatus.extension[tiuStatus].valueCodeableConcept 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding from CESServedTIUStatus (required)
* docStatus.extension[tiuStatus].valueCodeableConcept.coding.system 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding.code 1..1 MS


Invariant: ces-docstatus-1
Description: "If the source TIU status is UNSIGNED or UNCOSIGNED, docStatus SHALL be preliminary."
Severity: #error
Expression: "docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status' and (code = 'UNSIGNED' or code = 'UNCOSIGNED')).exists() implies docStatus = 'preliminary'"

Invariant: ces-docstatus-2
Description: "If the source TIU status is COMPLETED, docStatus SHALL be final."
Severity: #error
Expression: "docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status' and code = 'COMPLETED').exists() implies docStatus = 'final'"
