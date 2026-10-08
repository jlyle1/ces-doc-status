// =====================================================================
// Profile: DocumentReference as served by CES from VistA TIU.
// Normative constraints live here: the two bindings and the pairing invariants.
// =====================================================================

Alias: $alternate-codes = http://hl7.org/fhir/StructureDefinition/alternate-codes
Alias: $ed-conceptmap = http://hl7.org/fhir/StructureDefinition/elementdefinition-conceptmap
Alias: $USCoreDocRef = http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference
Alias: $tiu = http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status
Alias: $cesTiu = http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status

Profile: VistADocRefUnsignedUncosignedCompleted
Parent: $USCoreDocRef
Id: vista-docref-unsigned-uncosigned-completed
Title: "VistA DocumentReference (Unsigned, Uncosigned, Completed)"
Description: """
A US Core DocumentReference for a VistA TIU note as served by CES. Only notes whose TIU status is
UNSIGNED, UNCOSIGNED or COMPLETED are served. docStatus is limited to preliminary or final.
The status as CES reports it (UNSIGNED, UNCOSIGNED or SIGNED) is carried on docStatus in the
alternate-codes extension, optionally alongside the VistA TIU source status.
"""
* ^status = #draft
* ^experimental = false

* obeys ces-docstatus-1 and ces-docstatus-2 and ces-docstatus-3

// docStatus: required, constrained to the values CES emits
* docStatus 1..1 MS
* docStatus from CESDocStatus (required)
* docStatus ^short = "preliminary | final"
* docStatus ^definition = "preliminary for UNSIGNED or UNCOSIGNED TIU notes; final for COMPLETED TIU notes (reported by CES as SIGNED)."
// Informative link from the bound value set to the ConceptMap that explains excluded TIU statuses
// (the extension context is ElementDefinition.binding.valueSet, not binding)
* docStatus ^binding.valueSet.extension[+].url = $ed-conceptmap
* docStatus ^binding.valueSet.extension[=].valueCanonical = Canonical(tiu-status-to-docstatus-completed-unsigned-uncosigned)

// Source TIU status, carried on docStatus
* docStatus.extension contains $alternate-codes named tiuStatus 1..1 MS
* docStatus.extension[tiuStatus] ^short = "TIU status as reported by CES, optionally with the VistA source status"
* docStatus.extension[tiuStatus].valueCodeableConcept 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding 1..2 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding ^slicing.discriminator[0].type = #value
* docStatus.extension[tiuStatus].valueCodeableConcept.coding ^slicing.discriminator[0].path = "system"
* docStatus.extension[tiuStatus].valueCodeableConcept.coding ^slicing.rules = #closed
* docStatus.extension[tiuStatus].valueCodeableConcept.coding ^slicing.description = "The CES status (required) and, optionally, the VistA TIU status it came from."
* docStatus.extension[tiuStatus].valueCodeableConcept.coding contains ces 1..1 MS and vista 0..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces] ^short = "Status as reported by CES (UNSIGNED | UNCOSIGNED | SIGNED)"
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces] from CESTIUStatusVS (required)
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces].system 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces].system = $cesTiu (exactly)
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces].code 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[vista] ^short = "VistA TIU source status (UNSIGNED | UNCOSIGNED | COMPLETED)"
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[vista] from CESServedTIUStatus (required)
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[vista].system 1..1 MS
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[vista].system = $tiu (exactly)
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[vista].code 1..1 MS


Invariant: ces-docstatus-1
Description: "If the CES TIU status is UNSIGNED or UNCOSIGNED, docStatus SHALL be preliminary."
Severity: #error
Expression: "docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status' and (code = 'UNSIGNED' or code = 'UNCOSIGNED')).exists() implies docStatus = 'preliminary'"

Invariant: ces-docstatus-2
Description: "If the CES TIU status is SIGNED, docStatus SHALL be final."
Severity: #error
Expression: "docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status' and code = 'SIGNED').exists() implies docStatus = 'final'"

Invariant: ces-docstatus-3
Description: "If the VistA TIU status is present, it SHALL agree with the CES TIU status: COMPLETED with SIGNED, UNSIGNED with UNSIGNED, UNCOSIGNED with UNCOSIGNED."
Severity: #error
Expression: "(docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status' and code = 'COMPLETED').exists() implies docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status' and code = 'SIGNED').exists()) and (docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status' and code = 'UNSIGNED').exists() implies docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status' and code = 'UNSIGNED').exists()) and (docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status' and code = 'UNCOSIGNED').exists() implies docStatus.extension('http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept).coding.where(system = 'http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status' and code = 'UNCOSIGNED').exists())"
