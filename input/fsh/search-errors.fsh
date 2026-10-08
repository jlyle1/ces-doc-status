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
* #unknown-status "Unknown status" "The search filtered on a value that is not a code in the status code system for that parameter."


Instance: tiu-status-amended-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for an unserved TIU status"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiu-status=AMENDED."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = CESSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'AMENDED' for search parameter 'tiu-status' is not supported. Documents with this status are not available through this API. Supported values: UNSIGNED, UNCOSIGNED, COMPLETED."
* issue[0].location[0] = "http.tiu-status"


Instance: tiu-status-mixed-not-supported
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for served and unserved TIU statuses together"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiu-status=COMPLETED,AMENDED. The whole request is rejected; the issue names only the unserved value, so the client can resend without it."
* issue[0].severity = #error
* issue[0].code = #not-supported
* issue[0].details.coding[0] = CESSearchError#status-not-served "Status not served"
* issue[0].details.text = "The value 'AMENDED' for search parameter 'tiu-status' is not supported. Documents with this status are not available through this API. No results were returned for any value in this request. Supported values: UNSIGNED, UNCOSIGNED, COMPLETED."
* issue[0].location[0] = "http.tiu-status"


Instance: tiu-status-unknown-code
InstanceOf: OperationOutcome
Usage: #example
Title: "Search for a value that is not a TIU status"
Description: "Response body (HTTP 400) for GET DocumentReference?patient=...&tiu-status=SIGNED. SIGNED is not a code in the VistA TIU Status code system (see Open Issues)."
* issue[0].severity = #error
* issue[0].code = #code-invalid
* issue[0].details.coding[0] = CESSearchError#unknown-status "Unknown status"
* issue[0].details.text = "The value 'SIGNED' for search parameter 'tiu-status' is not a VistA TIU status code. Supported values: UNSIGNED, UNCOSIGNED, COMPLETED."
* issue[0].location[0] = "http.tiu-status"
