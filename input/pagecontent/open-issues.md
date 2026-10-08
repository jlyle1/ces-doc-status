### SIGNED vs COMPLETED

CES reports returning documents with a TIU status of SIGNED. VistA's TIU STATUS file (#8925.6) has no SIGNED status; the corresponding value is COMPLETED. This guide uses COMPLETED. It needs to be confirmed where SIGNED is produced, and whether CES should emit COMPLETED in the alternate-codes extension.

### TIU status coverage

The code system holds all 14 entries in the TIU STATUS file (#8925.6). The availability ConceptMap marks 3 as matched (UNSIGNED, UNCOSIGNED, COMPLETED) and 11 as `unmatched`. TEST, ACTIVE and INACTIVE apply to document titles (#8925.1 field .07, screened to statuses appropriate for document definitions), not to document instances, so they are not expected on notes at all. A separate semantic ConceptMap covering the document statuses (for example AMENDED → amended, RETRACTED → entered-in-error) could be added. It would be informative and unbound.

### Excluded statuses

The CES service only provides 3 of 11 status values. It's clear that an "undictated" or "untranscribed" note may be useless in a document API, but "amended" seems to be a clear gap for most use cases. This may be exactly what is required for the (unspecified) use case. The runtime behavior is now specified (see [Design](design.html#excluded-statuses-at-runtime) and the CapabilityStatement), so clients that filter on an excluded status get an explicit error rather than an empty result.

### Migration from empty Bundle to 400

Earlier drafts of this guide said a search for an excluded status returns an empty Bundle. If that describes CES's current behavior, the change to HTTP 400 breaks any client that treats an empty Bundle as "none in that status." Rollout (versioning, notice to known clients, any transition period) is open.

### References to excluded notes

If CES populates `DocumentReference.relatesTo` (for example, an addendum whose parent note is AMENDED), some references will point at notes this API does not serve and will not resolve (a read returns 404). Whether CES populates `relatesTo`, and if so whether the CapabilityStatement should say so, needs to be confirmed.

### tiuDocumentStatus

CES currently filters on an undeclared `tiuDocumentStatus` parameter. This guide replaces it with the declared `tiu-status` SearchParameter, which works against data carried in the resource. Whether CES adopts the new parameter, or keeps its own with a declared, expression-less definition, is open. The error behavior and the OperationOutcome examples are written for `tiu-status`; the same behavior applies to `tiuDocumentStatus` while CES still accepts it, with `location` set to `http.tiuDocumentStatus`.

### alternate-codes maturity

The alternate-codes extension is draft (maturity 1) in the FHIR Extensions Pack. It is still preferred over defining a new extension, but its definition could change.
