// =====================================================================
// SearchParameters (R4 core has none for docStatus) and the server
// CapabilityStatement that advertises them.
// =====================================================================

Instance: DocumentReference-doc-status
InstanceOf: SearchParameter
Usage: #definition
Title: "DocumentReference docStatus"
* url = "http://va.gov/fhir/ces-doc-status/SearchParameter/DocumentReference-doc-status"
* name = "DocumentReferenceDocStatus"
* status = #draft
* experimental = false
* description = "Search DocumentReferences by docStatus (preliminary | final). R4 core defines no search parameter for this element; R5 defines doc-status."
* code = #doc-status
* base = #DocumentReference
* type = #token
* expression = "DocumentReference.docStatus"
* xpath = "f:DocumentReference/f:docStatus"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false


Instance: DocumentReference-tiu-status
InstanceOf: SearchParameter
Usage: #definition
Title: "DocumentReference source VistA TIU status"
* url = "http://va.gov/fhir/ces-doc-status/SearchParameter/DocumentReference-tiu-status"
* name = "DocumentReferenceTIUStatus"
* status = #draft
* experimental = false
* description = "Search DocumentReferences by the source VistA TIU status carried in the alternate-codes extension on docStatus (e.g. UNSIGNED, UNCOSIGNED, COMPLETED). Replaces the undeclared tiuDocumentStatus parameter."
* code = #tiu-status
* base = #DocumentReference
* type = #token
* expression = "DocumentReference.docStatus.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept)"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false


Instance: ces-documentreference-server
InstanceOf: CapabilityStatement
Usage: #definition
Title: "CES DocumentReference Server"
* url = "http://va.gov/fhir/ces-doc-status/CapabilityStatement/ces-documentreference-server"
* name = "CESDocumentReferenceServer"
* status = #draft
* experimental = false
* date = "2026-10-01"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* description = "Expected capabilities of CES for DocumentReference: the profile served, the statuses available, and the supported search parameters."
* rest[0].mode = #server
* rest[0].documentation = """
CES serves DocumentReferences only for VistA TIU notes whose status is UNSIGNED, UNCOSIGNED or COMPLETED.
Notes in the other eleven TIU statuses are never returned: a search
for them returns an empty Bundle, not an error. See the informative ConceptMap tiu-status-to-docstatus-completed-unsigned-uncosigned.
"""
* rest[0].resource[0].type = #DocumentReference
* rest[0].resource[0].profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
* rest[0].resource[0].supportedProfile[0] = Canonical(VistADocRefUnsignedUncosignedCompleted)
* rest[0].resource[0].documentation = "Only preliminary (UNSIGNED/UNCOSIGNED) and final (COMPLETED) documents are exposed. The source TIU status is in the alternate-codes extension on docStatus."
* rest[0].resource[0].interaction[0].code = #read
* rest[0].resource[0].interaction[1].code = #search-type
* rest[0].resource[0].searchParam[0].name = "patient"
* rest[0].resource[0].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
* rest[0].resource[0].searchParam[0].type = #reference
* rest[0].resource[0].searchParam[1].name = "doc-status"
* rest[0].resource[0].searchParam[1].definition = Canonical(DocumentReference-doc-status)
* rest[0].resource[0].searchParam[1].type = #token
* rest[0].resource[0].searchParam[1].documentation = "Only preliminary and final are ever matched."
* rest[0].resource[0].searchParam[2].name = "tiu-status"
* rest[0].resource[0].searchParam[2].definition = Canonical(DocumentReference-tiu-status)
* rest[0].resource[0].searchParam[2].type = #token
* rest[0].resource[0].searchParam[2].documentation = "Only UNSIGNED, UNCOSIGNED and COMPLETED are ever matched. Other TIU values return an empty Bundle."
