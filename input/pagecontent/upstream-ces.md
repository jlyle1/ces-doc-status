This page is informative. It describes the CES interface Lighthouse uses, so that the translation Lighthouse applies is documented. Nothing on this page is part of Lighthouse's public contract: clients never see CES's status labels or its search parameter.

### What CES provides

CES returns VistA TIU notes whose status is UNSIGNED, UNCOSIGNED or COMPLETED. Its responses resemble FHIR but do not reliably conform to it, so Lighthouse treats them as input to normalize, not as resources to pass through.

### Status labels

CES uses its own label for one status. The labels are recorded in [CES TIU Status (upstream)](CodeSystem-ces-tiu-status.html), and the translation in the ConceptMap [CES TIU Status to VistA TIU Status](ConceptMap-ces-tiu-status-to-vista-tiu-status.html).

| CES label | VistA TIU status (what Lighthouse reports) |
|---|---|
| UNSIGNED | UNSIGNED |
| UNCOSIGNED | UNCOSIGNED |
| SIGNED | COMPLETED |

### Search translation

CES filters on a `tiuDocumentStatus` parameter that takes CES labels. Lighthouse validates the client's request first, then translates it.

| Lighthouse request | CES request |
|---|---|
| `tiu-document-status=UNSIGNED` | `tiuDocumentStatus=UNSIGNED` |
| `tiu-document-status=COMPLETED` | `tiuDocumentStatus=SIGNED` |
| `tiu-document-status=UNSIGNED,COMPLETED` | `tiuDocumentStatus=UNSIGNED,SIGNED`, or one call per value (see [Open Issues](open-issues.html)) |
| `doc-status=preliminary` | `tiuDocumentStatus=UNSIGNED,UNCOSIGNED` |
| `doc-status=final` | `tiuDocumentStatus=SIGNED` |
| No status filter | No `tiuDocumentStatus` |
| Any request that fails with 400 | No CES call |

### Response handling

For each note CES returns, Lighthouse:

1. Reads the CES status and translates it to the VistA TIU status.
2. Drops the note if the status is not UNSIGNED, UNCOSIGNED or COMPLETED.
3. Sets `docStatus` and the alternate-codes extension from the VistA status.
4. Builds the rest of the DocumentReference to conform to the [profile](StructureDefinition-lighthouse-ces-docref.html).

If CES fails or its response can't be used, Lighthouse returns 502, 503 or 504 with an OperationOutcome (see [Design](design.html#excluded-statuses-at-runtime)).
