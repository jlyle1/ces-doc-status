This page is informative. Lighthouse obtains TIU notes from several internal VA services. Their design is outside the scope of this guide; this page records only what Lighthouse does with what they return. Nothing on this page is part of Lighthouse's public contract.

### What the services provide

Internal services return VistA TIU notes. Their responses may resemble FHIR without reliably conforming to it, so Lighthouse treats them as input to normalize, not as resources to pass through.

### Status labels

Some services use their own label for a VistA status. The labels are recorded in [Internal TIU Status Labels](CodeSystem-internal-tiu-status.html), and the translation in the ConceptMap [Internal TIU Status Labels to VistA TIU Status](ConceptMap-internal-tiu-status-to-vista-tiu-status.html).

| Internal label | VistA TIU status (what Lighthouse reports) |
|---|---|
| UNSIGNED | UNSIGNED |
| UNCOSIGNED | UNCOSIGNED |
| SIGNED | COMPLETED |

### Search

Lighthouse validates the client's request first. A request that fails with 400 is never passed on. For the rest, Lighthouse translates status values into whatever terms the internal services expect (for example, COMPLETED to SIGNED).

### Response handling

For each note it receives, Lighthouse:

1. Reads the status and translates it to the VistA TIU status.
2. Drops the note if the status is not UNSIGNED, UNCOSIGNED or COMPLETED.
3. Sets `docStatus` and the alternate-codes extension from the VistA status.
4. Builds the rest of the DocumentReference to conform to the [profile](StructureDefinition-lighthouse-tiu-docref.html).

If an internal service fails or its response can't be used, Lighthouse returns 502, 503 or 504 with an OperationOutcome (see [Design](design.html#excluded-statuses-at-runtime)).
