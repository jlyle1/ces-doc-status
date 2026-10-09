// =====================================================================
// Lighthouse search error codes and OperationOutcome examples.
// =====================================================================

CodeSystem: LighthouseSearchError
Id: lighthouse-search-error
Title: "Lighthouse Search Error Codes"
Description: "Codes identifying specific Lighthouse search failures, carried in OperationOutcome.issue.details.coding so clients can branch on them without parsing text."
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #status-not-served "Status not served" "The search filtered on a status whose documents this API does not serve. Such documents may exist in VistA; this API will not search for or return them."
* #unknown-status "Unknown status" "The search filtered on a value that is not a code in the parameter's status code system."
* #upstream-error "Upstream error" "Lighthouse could not obtain a usable response from an internal service. No results are returned; the failure says nothing about whether matching documents exist."


Instance: docstatus-amended-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for an unserved docStatus"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&docStatus=amended. amended is a valid docStatus code, but Lighthouse serves only preliminary and final. docStatus=entered-in-error gets the same response."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = LighthouseSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'amended' for search parameter 'docStatus' is not supported. Documents with this status are not available through this API. Supported values: preliminary, final."
* issue[0].location[0] = "http.docStatus"


Instance: docstatus-mixed-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for served and unserved docStatus values together"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&docStatus=final,amended. The whole request is rejected; the issue names only the unserved value, so the client can resend without it."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = LighthouseSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'amended' for search parameter 'docStatus' is not supported. Documents with this status are not available through this API. No results were returned for any value in this request. Supported values: preliminary, final."
* issue[0].location[0] = "http.docStatus"


Instance: docstatus-unknown-code
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for a value that is not a docStatus code"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&docStatus=signed. signed is not a code in http://hl7.org/fhir/composition-status."
* issue[0].severity = #error
* issue[0].code = #code-invalid
* issue[0].details.coding[0] = LighthouseSearchError#unknown-status "Unknown status"
* issue[0].details.text = "The value 'signed' for search parameter 'docStatus' is not a docStatus code. Supported values: preliminary, final."
* issue[0].location[0] = "http.docStatus"


Instance: upstream-unavailable
InstanceOf: OperationOutcome
Usage: #example
Title: "Upstream failure"
Description: "Response body (HTTP 502, 503 or 504) for any DocumentReference request when an internal service fails, times out or returns an unusable response."
* issue[0].severity = #error
* issue[0].code = #transient
* issue[0].details.coding[0] = LighthouseSearchError#upstream-error "Upstream error"
* issue[0].details.text = "Documents could not be retrieved from the source system. No results were returned. Retry later."
