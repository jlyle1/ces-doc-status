// =====================================================================
// The docStatus SearchParameter (R4 core has none) and the Lighthouse
// CapabilityStatement that advertises it.
// =====================================================================

Instance: DocumentReference-docStatus
InstanceOf: SearchParameter
Usage: #definition
Title: "DocumentReference docStatus"
* url = "http://va.gov/fhir/ces-doc-status/SearchParameter/DocumentReference-docStatus"
* name = "DocumentReferenceDocStatus"
* status = #draft
* experimental = false
* description = "Search DocumentReferences by docStatus (preliminary | final). R4 core defines no search parameter for this element. The code follows Lighthouse's camelCase convention and matches the element name; R5 core's equivalent is doc-status."
* code = #docStatus
* base = #DocumentReference
* type = #token
* expression = "DocumentReference.docStatus"
* xpath = "f:DocumentReference/f:docStatus"
* xpathUsage = #normal
* multipleOr = true
* multipleAnd = false


Instance: lighthouse-documentreference-server
InstanceOf: CapabilityStatement
Usage: #definition
Title: "Lighthouse DocumentReference Server (VistA TIU notes)"
* url = "http://va.gov/fhir/ces-doc-status/CapabilityStatement/lighthouse-documentreference-server"
* name = "LighthouseDocumentReferenceServer"
* status = #draft
* experimental = false
* date = "2026-10-09"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* description = "Expected capabilities of Lighthouse for DocumentReferences of VistA TIU notes: the profile served, the statuses available, docStatus search and the error responses."
* rest[0].mode = #server
* rest[0].documentation = """
Lighthouse serves DocumentReferences for VistA TIU notes it obtains from internal services, and only for notes whose
docStatus is preliminary or final. Notes that would be amended or entered-in-error, and notes in other TIU statuses,
are outside the scope of this API and are never returned. See the informative ConceptMap
tiu-status-to-docstatus-completed-unsigned-uncosigned.

* Searches that do not filter on docStatus return in-scope notes only: HTTP 200, with no OperationOutcome.
The exclusion applies to every response, so it is stated here rather than in each Bundle.
* Searches on docStatus=amended or docStatus=entered-in-error fail with HTTP 400 and an OperationOutcome
(issue.code not-supported, details.coding lighthouse-search-error#status-not-served). This includes a
comma-separated list in which any value is out of scope; the OperationOutcome names only the out-of-scope values.
An empty Bundle is not returned, because it would imply that no such notes exist.
* docStatus values that are not codes in http://hl7.org/fhir/composition-status fail with HTTP 400 and an
OperationOutcome (issue.code code-invalid, details.coding lighthouse-search-error#unknown-status).
* If an internal service fails, times out or returns an unusable response, the request fails with HTTP 502, 503 or 504
and an OperationOutcome (issue.code transient, details.coding lighthouse-search-error#upstream-error). An empty or
partial Bundle is not returned.
* These responses do not depend on the Prefer: handling header.
"""
* rest[0].resource[0].type = #DocumentReference
* rest[0].resource[0].profile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference"
* rest[0].resource[0].supportedProfile[0] = Canonical(LighthouseTIUDocumentReference)
* rest[0].resource[0].documentation = "Only preliminary and final documents are exposed."
* rest[0].resource[0].interaction[0].code = #read
* rest[0].resource[0].interaction[0].documentation = "A read of a note outside the scope of this API returns 404 Not Found."
* rest[0].resource[0].interaction[1].code = #search-type
* rest[0].resource[0].searchParam[0].name = "patient"
* rest[0].resource[0].searchParam[0].definition = "http://hl7.org/fhir/SearchParameter/clinical-patient"
* rest[0].resource[0].searchParam[0].type = #reference
* rest[0].resource[0].searchParam[1].name = "docStatus"
* rest[0].resource[0].searchParam[1].definition = Canonical(DocumentReference-docStatus)
* rest[0].resource[0].searchParam[1].type = #token
* rest[0].resource[0].searchParam[1].documentation = "Codes from http://hl7.org/fhir/composition-status, sent as code or system|code. Codes are case-sensitive. Matches preliminary and final. amended or entered-in-error returns 400 not-supported; any other value returns 400 code-invalid."
