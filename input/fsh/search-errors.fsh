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


Instance: tiu-amended-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for an unserved TIU status"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiu-document-status=AMENDED."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = LighthouseSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'AMENDED' for search parameter 'tiu-document-status' is not supported. Documents with this status are not available through this API. Supported values: UNSIGNED, UNCOSIGNED, COMPLETED."
* issue[0].location[0] = "http.tiu-document-status"


Instance: tiu-mixed-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for served and unserved TIU statuses together"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiu-document-status=COMPLETED,AMENDED. The whole request is rejected; the issue names only the unserved value, so the client can resend without it."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = LighthouseSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'AMENDED' for search parameter 'tiu-document-status' is not supported. Documents with this status are not available through this API. No results were returned for any value in this request. Supported values: UNSIGNED, UNCOSIGNED, COMPLETED."
* issue[0].location[0] = "http.tiu-document-status"


Instance: tiu-unknown-code
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for a value that is not a VistA TIU status"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiu-document-status=SIGNED. SIGNED is not a VistA TIU status."
* issue[0].severity = #error
* issue[0].code = #code-invalid
* issue[0].details.coding[0] = LighthouseSearchError#unknown-status "Unknown status"
* issue[0].details.text = "The value 'SIGNED' for search parameter 'tiu-document-status' is not a VistA TIU status code. Supported values: UNSIGNED, UNCOSIGNED, COMPLETED."
* issue[0].location[0] = "http.tiu-document-status"


Instance: doc-status-amended-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for an unserved docStatus"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&doc-status=amended. amended is a valid docStatus code, but Lighthouse serves only preliminary and final."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = LighthouseSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'amended' for search parameter 'doc-status' is not supported. Documents with this status are not available through this API. Supported values: preliminary, final."
* issue[0].location[0] = "http.doc-status"


Instance: upstream-unavailable
InstanceOf: OperationOutcome
Usage: #example
Title: "Upstream failure"
Description: "Response body (HTTP 502, 503 or 504) for any DocumentReference request when the upstream source fails, times out or returns an unusable response."
* issue[0].severity = #error
* issue[0].code = #transient
* issue[0].details.coding[0] = LighthouseSearchError#upstream-error "Upstream error"
* issue[0].details.text = "Documents could not be retrieved from the source system. No results were returned. Retry later."
