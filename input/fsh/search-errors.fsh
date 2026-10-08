// =====================================================================
// Search error codes and OperationOutcome examples for searches on
// statuses CES does not serve.
// =====================================================================

CodeSystem: CESSearchError
Id: ces-search-error
Title: "CES Search Error Codes"
Description: "Codes identifying specific CES search failures, carried in OperationOutcome.issue.details.coding so clients can branch on them without parsing text."
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #status-not-served "Status not served" "The search filtered on a status whose documents this API does not serve. Such documents may exist in VistA; this API will not search for or return them."
* #unknown-status "Unknown status" "The search filtered on a value that is not a code in any status code system for that parameter."


Instance: tiu-status-amended-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for an unserved TIU status"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiuDocumentStatus=AMENDED."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = CESSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'AMENDED' for search parameter 'tiuDocumentStatus' is not supported. Documents with this status are not available through this API. Supported values: UNSIGNED, UNCOSIGNED, SIGNED."
* issue[0].location[0] = "http.tiuDocumentStatus"


Instance: tiu-status-mixed-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for served and unserved TIU statuses together"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiuDocumentStatus=SIGNED,AMENDED. The whole request is rejected; the issue names only the unserved value, so the client can resend without it."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = CESSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'AMENDED' for search parameter 'tiuDocumentStatus' is not supported. Documents with this status are not available through this API. No results were returned for any value in this request. Supported values: UNSIGNED, UNCOSIGNED, SIGNED."
* issue[0].location[0] = "http.tiuDocumentStatus"


Instance: tiu-status-unknown-code
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for a value that is not a TIU status"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiuDocumentStatus=FINAL. FINAL is in neither the CES TIU Status nor the VistA TIU Status code system."
* issue[0].severity = #error
* issue[0].code = #code-invalid
* issue[0].details.coding[0] = CESSearchError#unknown-status "Unknown status"
* issue[0].details.text = "The value 'FINAL' for search parameter 'tiuDocumentStatus' is not a TIU status code. Supported values: UNSIGNED, UNCOSIGNED, SIGNED."
* issue[0].location[0] = "http.tiuDocumentStatus"


Instance: doc-status-amended-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for an unserved docStatus"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&doc-status=amended. amended is a valid docStatus code, but CES serves only preliminary and final."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = CESSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'amended' for search parameter 'doc-status' is not supported. Documents with this status are not available through this API. Supported values: preliminary, final."
* issue[0].location[0] = "http.doc-status"
