// =====================================================================
// Terminology: VistA TIU status codes, the constrained value sets,
// and the informative ConceptMap documenting data availability.
// =====================================================================

Alias: $compStatus = http://hl7.org/fhir/composition-status

CodeSystem: VistATIUStatus
Id: vista-tiu-status
Title: "VistA TIU Status"
Description: """
Status values for VistA TIU documents (TIU STATUS file, #8925.6), as served by Lighthouse.
All 14 entries in the TIU STATUS file (^TIU(8925.6)), as listed on VIVIAN. Code = .01 NAME; the IEN is
noted in each definition. Some internal services label COMPLETED as SIGNED; Lighthouse
reports COMPLETED. See the Internal Services page.
"""
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #UNDICTATED "Undictated" "IEN 1. Document has been requested but not yet dictated."
* #UNTRANSCRIBED "Untranscribed" "IEN 2. Document has been dictated but not yet transcribed."
* #UNRELEASED "Unreleased" "IEN 3. Document has been entered but not released by the author or transcriptionist."
* #UNVERIFIED "Unverified" "IEN 4. Document has been released but not yet verified."
* #UNSIGNED "Unsigned" "IEN 5. Document is awaiting the author's signature."
* #UNCOSIGNED "Uncosigned" "IEN 6. Document is signed by the author and awaiting cosignature."
* #COMPLETED "Completed" "IEN 7. Document is signed (and cosigned, if required)."
* #AMENDED "Amended" "IEN 8. Completed document that has subsequently been amended."
* #PURGED "Purged" "IEN 9. Document has been purged."
* #TEST "Test" "IEN 10. Applies to document titles (TIU DOCUMENT DEFINITION #8925.1, field .07 STATUS), not document instances."
* #ACTIVE "Active" "IEN 11. Applies to document titles (TIU DOCUMENT DEFINITION #8925.1, field .07 STATUS), not document instances."
* #INACTIVE "Inactive" "IEN 13. Applies to document titles (TIU DOCUMENT DEFINITION #8925.1, field .07 STATUS), not document instances."
* #DELETED "Deleted" "IEN 14. Document has been deleted."
* #RETRACTED "Retracted" "IEN 15. Document has been retracted."


ValueSet: LighthouseDocStatus
Id: lighthouse-doc-status
Title: "Lighthouse DocumentReference docStatus"
Description: "The docStatus values Lighthouse returns for VistA TIU notes: preliminary (unsigned or uncosigned notes) and final (completed notes)."
* ^status = #draft
* ^experimental = false
* $compStatus#preliminary
* $compStatus#final


ValueSet: LighthouseServedTIUStatus
Id: lighthouse-served-tiu-status
Title: "VistA TIU Status Values Served by Lighthouse"
Description: "The VistA TIU status values for which Lighthouse returns documents. All other TIU statuses are excluded; see the TIU-to-docStatus ConceptMap."
* ^status = #draft
* ^experimental = false
* VistATIUStatus#UNSIGNED
* VistATIUStatus#UNCOSIGNED
* VistATIUStatus#COMPLETED


Instance: tiu-status-to-docstatus-completed-unsigned-uncosigned
InstanceOf: ConceptMap
Usage: #definition
Title: "VistA TIU Status to docStatus for Lighthouse: Completed, Unsigned, Uncosigned (informative)"
Description: """
INFORMATIVE. Documents how VistA TIU statuses relate to DocumentReference.docStatus as served by Lighthouse,
and makes the eleven excluded statuses explicit (equivalence = unmatched). This map does not constrain
instances: the profile's bindings and invariants do. It exists to explain data availability.
"""
* url = "http://va.gov/fhir/ces-doc-status/ConceptMap/tiu-status-to-docstatus-completed-unsigned-uncosigned"
* name = "TIUStatusToDocStatusCompletedUnsignedUncosigned"
* title = "VistA TIU Status to docStatus for Lighthouse: Completed, Unsigned, Uncosigned (informative)"
* status = #draft
* experimental = false
* purpose = "Explains which VistA TIU statuses appear in Lighthouse responses, and as which docStatus. Informative only."
* sourceCanonical = Canonical(VistATIUStatusAll)
* targetCanonical = Canonical(LighthouseDocStatus)
* group[0].source = "http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status"
* group[0].target = "http://hl7.org/fhir/composition-status"

// Served
* group[0].element[0].code = #UNSIGNED
* group[0].element[0].display = "Unsigned"
* group[0].element[0].target[0].code = #preliminary
* group[0].element[0].target[0].display = "Preliminary"
* group[0].element[0].target[0].equivalence = #wider
* group[0].element[0].target[0].comment = "Many-to-one with UNCOSIGNED. The TIU value is retained on docStatus via the alternate-codes extension."

* group[0].element[1].code = #UNCOSIGNED
* group[0].element[1].display = "Uncosigned"
* group[0].element[1].target[0].code = #preliminary
* group[0].element[1].target[0].display = "Preliminary"
* group[0].element[1].target[0].equivalence = #wider
* group[0].element[1].target[0].comment = "Many-to-one with UNSIGNED. The TIU value is retained on docStatus via the alternate-codes extension."

* group[0].element[2].code = #COMPLETED
* group[0].element[2].display = "Completed"
* group[0].element[2].target[0].code = #final
* group[0].element[2].target[0].display = "Final"
* group[0].element[2].target[0].equivalence = #equivalent

// Explicitly not served
* group[0].element[3].code = #UNDICTATED
* group[0].element[3].display = "Undictated"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "Not served by Lighthouse."

* group[0].element[4].code = #UNVERIFIED
* group[0].element[4].display = "Unverified"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "Not served by Lighthouse."

* group[0].element[5].code = #UNRELEASED
* group[0].element[5].display = "Unreleased"
* group[0].element[5].target[0].equivalence = #unmatched
* group[0].element[5].target[0].comment = "Not served by Lighthouse."

* group[0].element[6].code = #UNTRANSCRIBED
* group[0].element[6].display = "Untranscribed"
* group[0].element[6].target[0].equivalence = #unmatched
* group[0].element[6].target[0].comment = "Not served by Lighthouse."

* group[0].element[7].code = #AMENDED
* group[0].element[7].display = "Amended"
* group[0].element[7].target[0].equivalence = #unmatched
* group[0].element[7].target[0].comment = "Not served by Lighthouse."

* group[0].element[8].code = #DELETED
* group[0].element[8].display = "Deleted"
* group[0].element[8].target[0].equivalence = #unmatched
* group[0].element[8].target[0].comment = "Not served by Lighthouse."

* group[0].element[9].code = #RETRACTED
* group[0].element[9].display = "Retracted"
* group[0].element[9].target[0].equivalence = #unmatched
* group[0].element[9].target[0].comment = "Not served by Lighthouse."

* group[0].element[10].code = #ACTIVE
* group[0].element[10].display = "Active"
* group[0].element[10].target[0].equivalence = #unmatched
* group[0].element[10].target[0].comment = "Not served by Lighthouse. Concept applies to document title (#8925.1), not document instance."

* group[0].element[11].code = #PURGED
* group[0].element[11].display = "Purged"
* group[0].element[11].target[0].equivalence = #unmatched
* group[0].element[11].target[0].comment = "Not served by Lighthouse."

* group[0].element[12].code = #TEST
* group[0].element[12].display = "Test"
* group[0].element[12].target[0].equivalence = #unmatched
* group[0].element[12].target[0].comment = "Not served by Lighthouse. Concept applies to document title (#8925.1), not document instance."

* group[0].element[13].code = #INACTIVE
* group[0].element[13].display = "Inactive"
* group[0].element[13].target[0].equivalence = #unmatched
* group[0].element[13].target[0].comment = "Not served by Lighthouse. Concept applies to document title (#8925.1), not document instance."


ValueSet: VistATIUStatusAll
Id: vista-tiu-status-all
Title: "All VistA TIU Status Values"
Description: "All codes in the VistA TIU Status code system. Source scope of the informative ConceptMap."
* ^status = #draft
* ^experimental = false
* include codes from system VistATIUStatus


// ---------------------------------------------------------------------
// INTERNAL ONLY. Status labels used by internal services, and the translation Lighthouse applies
// to them. Nothing here appears in Lighthouse requests or responses.
// ---------------------------------------------------------------------

CodeSystem: InternalTIUStatus
Id: internal-tiu-status
Title: "Internal TIU Status Labels"
Description: """
INFORMATIVE, INTERNAL ONLY. TIU status labels that internal services may use in place of VistA values.
Some services label the VistA TIU status COMPLETED as SIGNED; UNSIGNED and UNCOSIGNED pass unchanged.
Lighthouse translates these to VistA TIU Status; they never appear in Lighthouse requests or responses.
"""
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #UNSIGNED "Unsigned" "VistA TIU status UNSIGNED (IEN 5), unchanged."
* #UNCOSIGNED "Uncosigned" "VistA TIU status UNCOSIGNED (IEN 6), unchanged."
* #SIGNED "Signed" "Internal label for VistA TIU status COMPLETED (IEN 7). Same meaning."


ValueSet: InternalTIUStatusVS
Id: internal-tiu-status
Title: "Internal TIU Status Labels"
Description: "INFORMATIVE, INTERNAL ONLY. All internal TIU status labels."
* ^status = #draft
* ^experimental = false
* include codes from system InternalTIUStatus


Instance: internal-tiu-status-to-vista-tiu-status
InstanceOf: ConceptMap
Usage: #definition
Title: "Internal TIU Status Labels to VistA TIU Status"
Description: """
INFORMATIVE, INTERNAL ONLY. The translation Lighthouse applies to statuses from internal services: SIGNED becomes
COMPLETED; UNSIGNED and UNCOSIGNED are unchanged. Lighthouse applies the reverse when a service expects it.
"""
* url = "http://va.gov/fhir/ces-doc-status/ConceptMap/internal-tiu-status-to-vista-tiu-status"
* name = "InternalTIUStatusToVistATIUStatus"
* title = "Internal TIU Status Labels to VistA TIU Status"
* status = #draft
* experimental = false
* purpose = "Lets Lighthouse report VistA values without depending on the labels internal services use for them."
* sourceCanonical = Canonical(InternalTIUStatusVS)
* targetCanonical = Canonical(LighthouseServedTIUStatus)
* group[0].source = "http://va.gov/fhir/ces-doc-status/CodeSystem/internal-tiu-status"
* group[0].target = "http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status"
* group[0].element[0].code = #UNSIGNED
* group[0].element[0].display = "Unsigned"
* group[0].element[0].target[0].code = #UNSIGNED
* group[0].element[0].target[0].display = "Unsigned"
* group[0].element[0].target[0].equivalence = #equal
* group[0].element[1].code = #UNCOSIGNED
* group[0].element[1].display = "Uncosigned"
* group[0].element[1].target[0].code = #UNCOSIGNED
* group[0].element[1].target[0].display = "Uncosigned"
* group[0].element[1].target[0].equivalence = #equal
* group[0].element[2].code = #SIGNED
* group[0].element[2].display = "Signed"
* group[0].element[2].target[0].code = #COMPLETED
* group[0].element[2].target[0].display = "Completed"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "Same meaning, different label."
