// =====================================================================
// Examples: one per served TIU status.
// A deliberately invalid pairing lives in input/tests/ (not built into the IG).
// =====================================================================

Alias: $loinc = http://loinc.org
Alias: $uscoreDocCat = http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category
Alias: $altCodes = http://hl7.org/fhir/StructureDefinition/alternate-codes

Instance: example-patient
InstanceOf: http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient
Usage: #example
Title: "Example Patient"
* identifier[0].system = "urn:ietf:rfc:3986"
* identifier[0].value = "urn:uuid:6f1c2d7e-3b0a-4c5e-9a3e-2f8d1b7c4e10"
* name[0].family = "Example"
* name[0].given[0] = "Pat"
* gender = #unknown


RuleSet: ProgressNoteBase
* status = #current
* type = $loinc#11506-3 "Progress note"
* category[0] = $uscoreDocCat#clinical-note "Clinical Note"
* subject = Reference(example-patient)
* date = "2026-09-29T14:30:00-04:00"
* content[0].attachment.contentType = #text/plain
* content[0].attachment.data = "RXhhbXBsZSBwcm9ncmVzcyBub3RlIHRleHQu"


Instance: example-docref-unsigned
InstanceOf: VistADocRefUnsignedUncosignedCompleted
Usage: #example
Title: "Unsigned TIU note (preliminary)"
Description: "TIU status UNSIGNED, served as docStatus preliminary."
* insert ProgressNoteBase
* docStatus = #preliminary
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces] = CESTIUStatus#UNSIGNED "Unsigned"


Instance: example-docref-uncosigned
InstanceOf: VistADocRefUnsignedUncosignedCompleted
Usage: #example
Title: "Uncosigned TIU note (preliminary)"
Description: "TIU status UNCOSIGNED, served as docStatus preliminary."
* insert ProgressNoteBase
* docStatus = #preliminary
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces] = CESTIUStatus#UNCOSIGNED "Uncosigned"


Instance: example-docref-completed
InstanceOf: VistADocRefUnsignedUncosignedCompleted
Usage: #example
Title: "Completed TIU note (final)"
Description: "VistA TIU status COMPLETED, reported by CES as SIGNED and served as docStatus final. Carries both codings."
* insert ProgressNoteBase
* docStatus = #final
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[ces] = CESTIUStatus#SIGNED "Signed"
* docStatus.extension[tiuStatus].valueCodeableConcept.coding[vista] = VistATIUStatus#COMPLETED "Completed"
