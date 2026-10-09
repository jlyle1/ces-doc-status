// =====================================================================
// Example search responses (HTTP 200) for the queries on the Search page.
// Error responses are in search-errors.fsh.
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


Instance: search-preliminary
InstanceOf: Bundle
Usage: #example
Title: "Search for preliminary notes"
Description: "Response (HTTP 200) to GET DocumentReference?patient=example-patient&docStatus=preliminary."
* insert SearchsetBase(patient=example-patient&docStatus=preliminary, 2)
* insert MatchEntry(0, example-docref-unsigned)
* insert MatchEntry(1, example-docref-uncosigned)


Instance: search-final
InstanceOf: Bundle
Usage: #example
Title: "Search for final notes"
Description: "Response (HTTP 200) to GET DocumentReference?patient=example-patient&docStatus=final. docStatus=http://hl7.org/fhir/composition-status|final returns the same entries."
* insert SearchsetBase(patient=example-patient&docStatus=final, 1)
* insert MatchEntry(0, example-docref-completed)


Instance: search-served-status-none-found
InstanceOf: Bundle
Usage: #example
Title: "Search for a served status with no matching notes"
Description: "Response (HTTP 200) to GET DocumentReference?patient=other-patient&docStatus=preliminary, for a patient with no preliminary notes. preliminary is served, so an empty Bundle is a true statement that there are none. Contrast with docStatus=amended, which returns 400."
* type = #searchset
* total = 0
* link[0].relation = "self"
* link[0].url = "http://example.org/fhir/DocumentReference?patient=other-patient&docStatus=preliminary"
