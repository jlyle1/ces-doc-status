// =====================================================================
// Example search responses (HTTP 200) for the queries listed on the
// Design page. Error responses (HTTP 400) are in search-errors.fsh.
// =====================================================================

RuleSet: SearchsetBase(query, total)
* type = #searchset
* total = {total}
* link[0].relation = "self"
* link[0].url = "http://example.org/fhir/DocumentReference?{query}"

RuleSet: MatchEntry(i, id)
* entry[{i}].fullUrl = "http://example.org/fhir/DocumentReference/{id}"
* entry[{i}].resource = {id}
* entry[{i}].search.mode = #match


Instance: search-unfiltered
InstanceOf: Bundle
Usage: #example
Title: "Search with no status filter"
Description: "Response (HTTP 200) to GET DocumentReference?patient=example-patient. Returns every in-scope note, with no OperationOutcome; out-of-scope notes are excluded by the standing rule in the CapabilityStatement."
* insert SearchsetBase(patient=example-patient, 3)
* insert MatchEntry(0, example-docref-unsigned)
* insert MatchEntry(1, example-docref-uncosigned)
* insert MatchEntry(2, example-docref-completed)


Instance: search-tiu-preliminary
InstanceOf: Bundle
Usage: #example
Title: "Search for UNSIGNED or UNCOSIGNED notes"
Description: "Response (HTTP 200) to GET DocumentReference?patient=example-patient&tiuDocumentStatus=UNSIGNED,UNCOSIGNED. doc-status=preliminary returns the same entries."
* insert SearchsetBase(patient=example-patient&tiuDocumentStatus=UNSIGNED%2CUNCOSIGNED, 2)
* insert MatchEntry(0, example-docref-unsigned)
* insert MatchEntry(1, example-docref-uncosigned)


Instance: search-tiu-signed
InstanceOf: Bundle
Usage: #example
Title: "Search for SIGNED notes"
Description: "Response (HTTP 200) to GET DocumentReference?patient=example-patient&tiuDocumentStatus=SIGNED. tiuDocumentStatus=COMPLETED (the VistA synonym), tiuDocumentStatus=http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status|SIGNED and doc-status=final return the same entries."
* insert SearchsetBase(patient=example-patient&tiuDocumentStatus=SIGNED, 1)
* insert MatchEntry(0, example-docref-completed)


Instance: search-served-status-none-found
InstanceOf: Bundle
Usage: #example
Title: "Search for a served status with no matching notes"
Description: "Response (HTTP 200) to GET DocumentReference?patient=other-patient&tiuDocumentStatus=UNCOSIGNED, for a patient with no uncosigned notes. UNCOSIGNED is served, so an empty Bundle is a true statement that there are none. Contrast with tiuDocumentStatus=AMENDED, which returns 400."
* type = #searchset
* total = 0
* link[0].relation = "self"
* link[0].url = "http://example.org/fhir/DocumentReference?patient=other-patient&tiuDocumentStatus=UNCOSIGNED"
