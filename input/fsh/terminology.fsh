// =====================================================================
// Terminology: VistA TIU status codes, the constrained value sets,
// and the informative ConceptMap documenting data availability.
// =====================================================================

Alias: $compStatus = http://hl7.org/fhir/composition-status

CodeSystem: VistATIUStatus
Id: vista-tiu-status
Title: "VistA TIU Status"
Description: """
Status values for VistA TIU documents (TIU STATUS file, #8925.6), as used by CES.
All 14 entries in the TIU STATUS file (^TIU(8925.6)), as listed on VIVIAN. Code = .01 NAME; the IEN is
noted in each definition. CES reports COMPLETED as SIGNED, which is not a VistA TIU
status; SIGNED is defined in the CES TIU Status code system instead.
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


ValueSet: CESDocStatus
Id: ces-doc-status
Title: "CES DocumentReference docStatus"
Description: "The docStatus values CES returns: preliminary (unsigned or uncosigned notes) and final (completed notes)."
* ^status = #draft
* ^experimental = false
* $compStatus#preliminary
* $compStatus#final


ValueSet: CESServedTIUStatus
Id: ces-served-tiu-status
Title: "VistA TIU Status Values Served by CES"
Description: "The VistA TIU status values for which CES returns documents. Binds the optional VistA coding on docStatus. All other TIU statuses are excluded; see the TIU-to-docStatus ConceptMap. CES reports COMPLETED as SIGNED; see CES TIU Status."
* ^status = #draft
* ^experimental = false
* VistATIUStatus#UNSIGNED
* VistATIUStatus#UNCOSIGNED
* VistATIUStatus#COMPLETED


Instance: tiu-status-to-docstatus-completed-unsigned-uncosigned
InstanceOf: ConceptMap
Usage: #definition
Title: "VistA TIU Status to docStatus for CES: Completed, Unsigned, Uncosigned (informative)"
Description: """
INFORMATIVE. Documents how VistA TIU statuses relate to DocumentReference.docStatus as served by CES,
and makes the eleven excluded statuses explicit (equivalence = unmatched). This map does not constrain
instances: the profile's bindings and invariants do. It exists to explain data availability.
"""
* url = "http://va.gov/fhir/ces-doc-status/ConceptMap/tiu-status-to-docstatus-completed-unsigned-uncosigned"
* name = "TIUStatusToDocStatusCompletedUnsignedUncosigned"
* title = "VistA TIU Status to docStatus for CES: Completed, Unsigned, Uncosigned (informative)"
* status = #draft
* experimental = false
* purpose = "Explains which VistA TIU statuses appear in CES responses, and as which docStatus. Informative only."
* sourceCanonical = Canonical(VistATIUStatusAll)
* targetCanonical = Canonical(CESDocStatus)
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
* group[0].element[2].target[0].comment = "CES reports this status as SIGNED (CES TIU Status code system)."

// Explicitly not served
* group[0].element[3].code = #UNDICTATED
* group[0].element[3].display = "Undictated"
* group[0].element[3].target[0].equivalence = #unmatched
* group[0].element[3].target[0].comment = "Not returned by CES."

* group[0].element[4].code = #UNVERIFIED
* group[0].element[4].display = "Unverified"
* group[0].element[4].target[0].equivalence = #unmatched
* group[0].element[4].target[0].comment = "Not returned by CES."

* group[0].element[5].code = #UNRELEASED
* group[0].element[5].display = "Unreleased"
* group[0].element[5].target[0].equivalence = #unmatched
* group[0].element[5].target[0].comment = "Not returned by CES."

* group[0].element[6].code = #UNTRANSCRIBED
* group[0].element[6].display = "Untranscribed"
* group[0].element[6].target[0].equivalence = #unmatched
* group[0].element[6].target[0].comment = "Not returned by CES."

* group[0].element[7].code = #AMENDED
* group[0].element[7].display = "Amended"
* group[0].element[7].target[0].equivalence = #unmatched
* group[0].element[7].target[0].comment = "Not returned by CES."

* group[0].element[8].code = #DELETED
* group[0].element[8].display = "Deleted"
* group[0].element[8].target[0].equivalence = #unmatched
* group[0].element[8].target[0].comment = "Not returned by CES."

* group[0].element[9].code = #RETRACTED
* group[0].element[9].display = "Retracted"
* group[0].element[9].target[0].equivalence = #unmatched
* group[0].element[9].target[0].comment = "Not returned by CES."

* group[0].element[10].code = #ACTIVE
* group[0].element[10].display = "Active"
* group[0].element[10].target[0].equivalence = #unmatched
* group[0].element[10].target[0].comment = "Not returned by CES. Concept applies to document title (#8925.1), not document instance."

* group[0].element[11].code = #PURGED
* group[0].element[11].display = "Purged"
* group[0].element[11].target[0].equivalence = #unmatched
* group[0].element[11].target[0].comment = "Not returned by CES."

* group[0].element[12].code = #TEST
* group[0].element[12].display = "Test"
* group[0].element[12].target[0].equivalence = #unmatched
* group[0].element[12].target[0].comment = "Not returned by CES. Concept applies to document title (#8925.1), not document instance."

* group[0].element[13].code = #INACTIVE
* group[0].element[13].display = "Inactive"
* group[0].element[13].target[0].equivalence = #unmatched
* group[0].element[13].target[0].comment = "Not returned by CES. Concept applies to document title (#8925.1), not document instance."


ValueSet: VistATIUStatusAll
Id: vista-tiu-status-all
Title: "All VistA TIU Status Values"
Description: "All codes in the VistA TIU Status code system. Source scope of the informative ConceptMap."
* ^status = #draft
* ^experimental = false
* include codes from system VistATIUStatus


// ---------------------------------------------------------------------
// CES's own status labels. CES reports VistA COMPLETED as SIGNED; SIGNED is
// not a VistA TIU status, so it is defined here rather than added to VistATIUStatus.
// ---------------------------------------------------------------------

CodeSystem: CESTIUStatus
Id: ces-tiu-status
Title: "CES TIU Status"
Description: """
TIU note status as CES reports it. CES reports the VistA TIU status COMPLETED as SIGNED, and reports
UNSIGNED and UNCOSIGNED unchanged. These codes are CES's labels, not VistA's: SIGNED does not appear in
the TIU STATUS file (#8925.6). The ConceptMap VistA TIU Status to CES TIU Status states the correspondence.
"""
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #complete
* #UNSIGNED "Unsigned" "Document is awaiting the author's signature. Same meaning as VistA TIU status UNSIGNED (IEN 5)."
* #UNCOSIGNED "Uncosigned" "Document is signed by the author and awaiting cosignature. Same meaning as VistA TIU status UNCOSIGNED (IEN 6)."
* #SIGNED "Signed" "Document is signed (and cosigned, if required). CES's label for VistA TIU status COMPLETED (IEN 7); the meaning is unchanged."


ValueSet: CESTIUStatusVS
Id: ces-tiu-status
Title: "CES TIU Status"
Description: "All CES TIU status codes: the statuses CES reports for the notes it serves."
* ^status = #draft
* ^experimental = false
* include codes from system CESTIUStatus


Instance: vista-tiu-status-to-ces-tiu-status
InstanceOf: ConceptMap
Usage: #definition
Title: "VistA TIU Status to CES TIU Status"
Description: """
How the VistA TIU statuses CES serves are labeled in CES responses. COMPLETED is relabeled SIGNED with no
change in meaning. Statuses CES does not serve are listed in the TIU-to-docStatus ConceptMap.
"""
* url = "http://va.gov/fhir/ces-doc-status/ConceptMap/vista-tiu-status-to-ces-tiu-status"
* name = "VistATIUStatusToCESTIUStatus"
* title = "VistA TIU Status to CES TIU Status"
* status = #draft
* experimental = false
* purpose = "Lets the CES specification use SIGNED without misrepresenting the VistA value it stands for."
* sourceCanonical = Canonical(CESServedTIUStatus)
* targetCanonical = Canonical(CESTIUStatusVS)
* group[0].source = "http://va.gov/fhir/ces-doc-status/CodeSystem/vista-tiu-status"
* group[0].target = "http://va.gov/fhir/ces-doc-status/CodeSystem/ces-tiu-status"
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
* group[0].element[2].code = #COMPLETED
* group[0].element[2].display = "Completed"
* group[0].element[2].target[0].code = #SIGNED
* group[0].element[2].target[0].display = "Signed"
* group[0].element[2].target[0].equivalence = #equivalent
* group[0].element[2].target[0].comment = "Same meaning, different label. CES reports COMPLETED as SIGNED."
