### Purpose

Lighthouse serves VistA TIU notes as FHIR R4 DocumentReferences. It obtains them from internal VA services. Lighthouse returns only notes whose VistA TIU status is UNSIGNED, UNCOSIGNED or COMPLETED, and it reports them with `docStatus` set to `preliminary` (UNSIGNED or UNCOSIGNED) or `final` (COMPLETED). This guide is Lighthouse's contract for these documents: which ones a client will get, what each status means, how to search on status, and what happens when a client asks for a status Lighthouse does not serve.

Status values in this guide are VistA's. Internal services may use labels of their own (for example, COMPLETED reported as SIGNED). Lighthouse translates them, and they do not appear in Lighthouse requests or responses. [Internal Services](internal-services.html) notes the translation.

This is a draft working guide, not a published specification.

### What this guide defines

The profile [Lighthouse DocumentReference (VistA TIU note)](StructureDefinition-lighthouse-tiu-docref.html) is based on US Core DocumentReference 6.1.0. It requires `docStatus` and binds it to [Lighthouse docStatus](ValueSet-lighthouse-doc-status.html) (preliminary, final). It also requires the VistA TIU status on `docStatus`, carried in the standard [alternate-codes](http://hl7.org/fhir/extensions/StructureDefinition-alternate-codes.html) extension and bound to [VistA TIU Status Values Served by Lighthouse](ValueSet-lighthouse-served-tiu-status.html). Two invariants tie the values together: UNSIGNED and UNCOSIGNED require `preliminary`, and COMPLETED requires `final`.

The ConceptMap [VistA TIU Status to docStatus for Lighthouse](ConceptMap-tiu-status-to-docstatus-completed-unsigned-uncosigned.html) is informative. It explains how TIU statuses relate to `docStatus` and lists the eleven statuses Lighthouse does not serve with equivalence `unmatched`.

Two SearchParameters fill gaps in R4. [doc-status](SearchParameter-DocumentReference-doc-status.html) searches on `docStatus`, which has no core search parameter in R4. [tiu-document-status](SearchParameter-DocumentReference-tiu-document-status.html) searches on the VistA TIU status.

The [Lighthouse DocumentReference Server](CapabilityStatement-lighthouse-documentreference-server.html) CapabilityStatement advertises the profile and both parameters, and documents the status filtering and error responses.

See [Design](design.html) for the reasoning and example queries, and [Open Issues](open-issues.html) for what is still unresolved.
