### Purpose

CES serves VistA TIU notes as FHIR R4 DocumentReferences. It returns only notes whose TIU status is UNSIGNED, UNCOSIGNED or COMPLETED, and it reports them with `docStatus` set to `preliminary` (UNSIGNED or UNCOSIGNED) or `final` (COMPLETED). CES labels COMPLETED as SIGNED; this guide defines SIGNED as a CES code mapped to VistA's COMPLETED, so neither name misstates the other. This guide makes that behavior explicit and computable, so a client can tell which documents it will get, what each status means, and which VistA statuses it will never see.

This is a draft working guide, not a published specification.

### What this guide defines

The profile [VistA DocumentReference (Unsigned, Uncosigned, Completed)](StructureDefinition-vista-docref-unsigned-uncosigned-completed.html) is based on US Core DocumentReference 6.1.0. It requires `docStatus` and binds it to [CES docStatus](ValueSet-ces-doc-status.html) (preliminary, final). It also requires the TIU status as CES reports it on `docStatus`, carried in the standard [alternate-codes](http://hl7.org/fhir/extensions/StructureDefinition-alternate-codes.html) extension and bound to [CES TIU Status](ValueSet-ces-tiu-status.html) (UNSIGNED, UNCOSIGNED, SIGNED). The same extension may also carry the VistA source status, bound to [VistA TIU Status Values Served by CES](ValueSet-ces-served-tiu-status.html). Three invariants tie the values together: UNSIGNED and UNCOSIGNED require `preliminary`, SIGNED requires `final`, and a VistA coding, if present, must agree with the CES coding.

The ConceptMap [VistA TIU Status to docStatus for CES (Completed, Unsigned, Uncosigned)](ConceptMap-tiu-status-to-docstatus-completed-unsigned-uncosigned.html) is informative. It explains how TIU statuses relate to `docStatus` and lists the eleven statuses CES does not serve with equivalence `unmatched`. The ConceptMap [VistA TIU Status to CES TIU Status](ConceptMap-vista-tiu-status-to-ces-tiu-status.html) states that CES's SIGNED is VistA's COMPLETED.

Two SearchParameters fill gaps in R4. [doc-status](SearchParameter-DocumentReference-doc-status.html) searches on `docStatus`, which has no core search parameter in R4. [tiuDocumentStatus](SearchParameter-DocumentReference-tiuDocumentStatus.html) searches on the TIU status. It formally declares the `tiuDocumentStatus` parameter CES already accepts, under the same name.

The [CES DocumentReference Server](CapabilityStatement-ces-documentreference-server.html) CapabilityStatement advertises the profile and both parameters, and documents the status filtering.

See [Design](design.html) for the reasoning and [Open Issues](open-issues.html) for what is still unresolved.
