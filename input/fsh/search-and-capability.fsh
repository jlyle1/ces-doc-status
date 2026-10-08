// =====================================================================
// SearchParameters (R4 core has none for docStatus) and the Lighthouse
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


Instance: DocumentReference-tiu-document-status
InstanceOf: SearchParameter
Usage: #definition
Title: "DocumentReference VistA TIU document status"
* url = "http://va.gov/fhir/ces-doc-status/SearchParameter/DocumentReference-tiu-document-status"
* name = "DocumentReferenceTIUDocumentStatus"
* status = #draft
* experimental = false
* description = "Search DocumentReferences by the VistA TIU status carried in the alternate-codes extension on docStatus (UNSIGNED, UNCOSIGNED, COMPLETED). Values are VistA TIU status codes."
* code = #tiu-document-status
* base = #DocumentReference
* type = #token
* expression = "DocumentReference.docStatus.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/alternate-codes').value.ofType(CodeableConcept)"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false


Instance: lighthouse-documentreference-server
InstanceOf: CapabilityStatement
Usage: #definition
Title: "Lighthouse DocumentReference Server (CES-provided notes)"
* url = "http://va.gov/fhir/ces-doc-status/CapabilityStatement/lighthouse-documentreference-server"
* name = "LighthouseDocumentReferenceServer"
* status = #draft
* experimental = false
* date = "2026-10-08"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* description = "Expected capabilities of Lighthouse for DocumentReferences of VistA TIU notes obtained from CES: the profile served, the statuses available, the supported search parameters and the error responses."
* rest[0].mode = #server
* rest[0].documentation = """
Lighthouse serves DocumentReferences for VistA TIU notes it obtains from CES, and only for notes whose VistA TIU
status is UNSIGNED, UNCOSIGNED or COMPLETED. Notes in the other eleven TIU statuses are outside the scope of this
API and are never returned. See the informative ConceptMap tiu-status-to-docstatus-completed-unsigned-uncosigned.
Status values are VistA TIU statuses; labels used by upstream services are not exposed.

* Searches that do not filter on status return in-scope notes only: HTTP 200, with no OperationOutcome.
The exclusion applies to every response, so it is stated here rather than in each Bundle.
* Searches that filter on an out-of-scope status (with tiu-document-status or doc-status) fail with HTTP 400 and an
OperationOutcome (issue.code not-supported, details.coding lighthouse-search-error#status-not-served). This includes a
comma-separated list in which any value is out of scope; the OperationOutcome names only the out-of-scope values.
An empty Bundle is not returned, because it would imply that no such notes exist.
* Values that are not codes in the parameter's code system fail with HTTP 400 and an OperationOutcome
(issue.code code-invalid, details.coding lighthouse-search-error#unknown-status).
* If the upstream source fails, times out or returns an unusable response, the request fails with HTTP 502, 503 or 504
and an OperationOutcome (issue.code transient, details.coding lighthouse-search-error#upstream-error). An empty or
partial Bundle is not returned.
* These responses do not depend on the Prefer: handling header.
"""
* rest[0].resource[0].type = #DocumentReference
* rest[0].resource[0].profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
* rest[0].resource[0].supportedProfile[0] = Canonical(LighthouseCESDocumentReference)
* rest[0].resource[0].documentation = "Only preliminary (UNSIGNED/UNCOSIGNED) and final (COMPLETED) documents are exposed. The VistA TIU status is in the alternate-codes extension on docStatus."
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
* rest[0].resource[0].searchParam[2].name = "tiu-document-status"
* rest[0].resource[0].searchParam[2].definition = Canonical(DocumentReference-tiu-document-status)
* rest[0].resource[0].searchParam[2].type = #token
* rest[0].resource[0].searchParam[2].documentation = "Codes from the VistA TIU Status code system (http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status), sent as code or system|code, e.g. COMPLETED. Codes are case-sensitive. Matches UNSIGNED, UNCOSIGNED and COMPLETED. Any other VistA TIU status returns 400 not-supported; any other value returns 400 code-invalid."
