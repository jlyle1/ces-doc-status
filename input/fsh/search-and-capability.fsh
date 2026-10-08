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
* date = "2026-10-08"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* description = "Expected capabilities of CES for DocumentReference: the profile served, the statuses available, and the supported search parameters."
* rest[0].mode = #server
* rest[0].documentation = """
CES serves DocumentReferences only for VistA TIU notes whose status is UNSIGNED, UNCOSIGNED or COMPLETED.
Notes in the other eleven TIU statuses are outside the scope of this API and are never returned.
See the informative ConceptMap tiu-status-to-docstatus-completed-unsigned-uncosigned.

* Searches that do not filter on status return in-scope notes only: HTTP 200, with no OperationOutcome.
The exclusion applies to every response, so it is stated here rather than in each Bundle.
* Searches that filter on an out-of-scope status (with tiu-status or doc-status) fail with HTTP 400 and an
OperationOutcome (issue.code not-supported, details.coding ces-search-error#status-not-served). This includes a
comma-separated list in which any value is out of scope; the OperationOutcome names only the out-of-scope values.
An empty Bundle is not returned, because it would imply that no such notes exist.
* Values that are not codes in the relevant code system fail with HTTP 400 and an OperationOutcome
(issue.code code-invalid, details.coding ces-search-error#unknown-status).
* These responses do not depend on the Prefer: handling header.
"""
* rest[0].resource[0].type = #DocumentReference
* rest[0].resource[0].profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
* rest[0].resource[0].supportedProfile[0] = Canonical(VistADocRefUnsignedUncosignedCompleted)
* rest[0].resource[0].documentation = "Only preliminary (UNSIGNED/UNCOSIGNED) and final (COMPLETED) documents are exposed. The source TIU status is in the alternate-codes extension on docStatus."
* rest[0].resource[0].interaction[0].code = #read
* rest[0].resource[0].interaction[0].documentation = "A read of a note outside the scope of this API (any TIU status other than UNSIGNED, UNCOSIGNED or COMPLETED) returns 404 Not Found."
* rest[0].resource[0].interaction[1].code = #search-type
* rest[0].resource[0].searchParam[0].name = "patient"
* rest[0].resource[0].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
* rest[0].resource[0].searchParam[0].type = #reference
* rest[0].resource[0].searchParam[1].name = "doc-status"
* rest[0].resource[0].searchParam[1].definition = Canonical(DocumentReference-doc-status)
* rest[0].resource[0].searchParam[1].type = #token
* rest[0].resource[0].searchParam[1].documentation = "Matches preliminary and final. amended or entered-in-error returns 400 not-supported; any other value returns 400 code-invalid."
* rest[0].resource[0].searchParam[2].name = "tiu-status"
* rest[0].resource[0].searchParam[2].definition = Canonical(DocumentReference-tiu-status)
* rest[0].resource[0].searchParam[2].type = #token
* rest[0].resource[0].searchParam[2].documentation = "Codes from the VistA TIU Status code system (http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status), sent as code or system|code, e.g. COMPLETED. Codes are case-sensitive. Matches UNSIGNED, UNCOSIGNED and COMPLETED. Any other TIU status returns 400 not-supported; a value not in the code system returns 400 code-invalid."
