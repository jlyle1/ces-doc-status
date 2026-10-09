// =====================================================================
// Profile: DocumentReference for a VistA TIU note served by Lighthouse.
// Lighthouse exposes status only as docStatus (preliminary | final).
// =====================================================================

Alias: $ed-conceptmap = http://hl7.org/fhir/StructureDefinition/elementdefinition-conceptmap
Alias: $USCoreDocRef = http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference

Profile: LighthouseTIUDocumentReference
Parent: $USCoreDocRef
Id: lighthouse-tiu-docref
Title: "Lighthouse DocumentReference (VistA TIU note)"
Description: """
A US Core DocumentReference for a VistA TIU note that Lighthouse obtains from internal services. docStatus is
required and limited to preliminary or final. Lighthouse does not expose the underlying VistA TIU status; the
informative ConceptMap linked from the docStatus binding shows which TIU statuses each docStatus value covers.
"""
* ^status = #draft
* ^experimental = false

* docStatus 1..1 MS
* docStatus from LighthouseDocStatus (required)
* docStatus ^short = "preliminary | final"
* docStatus ^definition = "preliminary for notes awaiting signature or cosignature; final for signed (completed) notes."
// Informative link from the bound value set to the ConceptMap that explains which TIU statuses are covered
// (the extension context is ElementDefinition.binding.valueSet, not binding)
* docStatus ^binding.valueSet.extension[+].url = $ed-conceptmap
* docStatus ^binding.valueSet.extension[=].valueCanonical = Canonical(tiu-status-to-docstatus-completed-unsigned-uncosigned)
