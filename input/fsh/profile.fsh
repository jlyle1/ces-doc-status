// =====================================================================
// Profile: DocumentReference for a VistA TIU note that Lighthouse obtains
// from CES. Normative constraints live here: the two bindings and the
// pairing invariants.
// =====================================================================

Alias: $alternate-codes = http://hl7.org/fhir/StructureDefinition/alternate-codes
Alias: $ed-conceptmap = http://hl7.org/fhir/StructureDefinition/elementdefinition-conceptmap
Alias: $USCoreDocRef = http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference
Alias: $tiu = http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status

Profile: LighthouseCESDocumentReference
Parent: $USCoreDocRef
Id: lighthouse-ces-docref
Title: "Lighthouse DocumentReference (CES-provided TIU note)"
Description: """
A US Core DocumentReference for a VistA TIU note that Lighthouse obtains from CES. Lighthouse serves only
notes whose VistA TIU status is UNSIGNED, UNCOSIGNED or COMPLETED. docStatus is limited to preliminary or
final, and the VistA TIU status is carried on docStatus in the alternate-codes extension. Status values are
VistA's: Lighthouse does not expose the labels CES uses for them.
"""
* ^status = #draft
* ^experimental = false

* obeys lh-docstatus-1 and lh-docstatus-2

// docStatus: required, constrained to the values Lighthouse emits
* docStatus 1..1 MS
* docStatus from LighthouseDocStatus (required)
* docStatus ^short = "preliminary | final"
* docStatus ^definition = "preliminary for UNSIGNED or UNCOSIGNED TIU notes; final for COMPLETED TIU notes."
// Informative link from the bound value set to the ConceptMap that explains excluded TIU statuses
// (the extension context is ElementDefinition.binding.valueSet, not binding)
* docStatus ^binding.valueSet.extension[+].url = $ed-conceptmap
* docStatus ^binding.valueSet.extension[=].valueCanonical = Canonical(tiu-status-to-docstatus-completed-unsigned-uncosigned)

// VistA TIU status, carried on docStatus
* docStatus.extension contains $alternate-codes named tiuStatus 1..1 MS
* docStatus.extension[tiuStatus] ^short = "VistA TIU status"
* docStatus.extension[tiuStatus].valueCodeableConcept 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding from LighthouseServedTIUStatus (required)
* docStatus.extension[tiuStatus].valueCodeableConcept.coding.system 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding.code 1..1 MS


Invariant: lh-docstatus-1
Description: "If the VistA TIU status is UNSIGNED or UNCOSIGNED, docStatus SHALL be preliminary."
Severity: #error
Expression: "docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status' and (code = 'UNSIGNED' or code = 'UNCOSIGNED')).exists() implies docStatus = 'preliminary'"

Invariant: lh-docstatus-2
Description: "If the VistA TIU status is COMPLETED, docStatus SHALL be final."
Severity: #error
Expression: "docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status' and code = 'COMPLETED').exists() implies docStatus = 'final'"
