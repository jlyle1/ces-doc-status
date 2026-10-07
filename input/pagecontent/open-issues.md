### SIGNED vs COMPLETED

CES reports returning documents with a TIU status of SIGNED. VistA's TIU STATUS file (#8925.6) has no SIGNED status; the corresponding value is COMPLETED. This guide uses COMPLETED. It needs to be confirmed where SIGNED is produced, and whether CES should emit COMPLETED in the alternate-codes extension.

### TIU status coverage

The code system holds all 14 entries in the TIU STATUS file (#8925.6). The availability ConceptMap marks 3 as matched (UNSIGNED, UNCOSIGNED, COMPLETED) and 11 as `unmatched`. TEST, ACTIVE and INACTIVE apply to document titles (#8925.1 field .07, screened to statuses appropriate for document definitions), not to document instances, so they are not expected on notes at all. A separate semantic ConceptMap covering the document statuses (for example AMENDED → amended, RETRACTED → entered-in-error) could be added. It would be informative and unbound.

### Excluded statuses

The CES service only provides 3 of 11 status values. It's clear that an "undictated" or "untranscribed" note may be useless in a document API, but "amended" seems to be a clear gap for most use cases.  This may be exactly what is required for the (unspecified) use case, but it is likely to cause confusion unless clearly indicated.

### tiuDocumentStatus

CES currently filters on an undeclared `tiuDocumentStatus` parameter. This guide replaces it with the declared `tiu-status` SearchParameter, which works against data carried in the resource. Whether CES adopts the new parameter, or keeps its own with a declared, expression-less definition, is open.

### alternate-codes maturity

The alternate-codes extension is draft (maturity 1) in the FHIR Extensions Pack. It is still preferred over defining a new extension, but its definition could change.
