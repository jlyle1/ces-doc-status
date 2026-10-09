### Purpose

Lighthouse serves VistA TIU notes as FHIR R4 DocumentReferences. It obtains them from internal VA services. Lighthouse returns only notes whose `docStatus` is `preliminary` or `final`. This guide is Lighthouse's contract for these documents: which ones a client will get, how to search on `docStatus`, and what happens when a client asks for a status Lighthouse does not serve.

**Start with [Search](search.html).** It lists the queries a client can send and the response to each, with examples.

This is a draft working guide, not a published specification.

### What this guide defines

The [docStatus](SearchParameter-DocumentReference-docStatus.html) SearchParameter fills a gap in R4, which has no core search parameter for `DocumentReference.docStatus`. The [Lighthouse DocumentReference Server](CapabilityStatement-lighthouse-documentreference-server.html) CapabilityStatement advertises it and documents the status filtering and error responses. Error responses carry codes from [Lighthouse Search Error Codes](CodeSystem-lighthouse-search-error.html).

The profile [Lighthouse DocumentReference (VistA TIU note)](StructureDefinition-lighthouse-tiu-docref.html), based on US Core DocumentReference 6.1.0, requires `docStatus` and binds it to [Lighthouse docStatus](ValueSet-lighthouse-doc-status.html) (preliminary, final).

For reference, the guide also records which VistA TIU statuses lie behind each `docStatus` value: the [VistA TIU Status](CodeSystem-vista-tiu-status.html) code system and the informative ConceptMap [VistA TIU Status to docStatus](ConceptMap-tiu-status-to-docstatus-completed-unsigned-uncosigned.html), which lists the eleven statuses Lighthouse does not serve. Lighthouse does not expose TIU statuses. [Internal Services](internal-services.html) notes a label some services use internally.

See [Design](design.html) for the reasoning and [Open Issues](open-issues.html) for what is still unresolved.
