This page is informative. Lighthouse obtains TIU notes from several internal VA services. Their design is outside the scope of this guide; this page records only what Lighthouse does with what they return. Nothing on this page is part of Lighthouse's public contract.

### What the services provide

Internal services return VistA TIU notes with a status of `preliminary` or `final`. They do not return the VistA TIU status. Their responses may resemble FHIR without reliably conforming to it, so Lighthouse treats them as input to normalize, not as resources to pass through.

### Search

Lighthouse validates the client's `docStatus` filter first. A request that fails with 400 is never passed on. The rest are passed to the services in whatever form they expect.

### Response handling

For each note it receives, Lighthouse:

1. Drops the note if its status is not `preliminary` or `final`.
2. Builds the DocumentReference to conform to the [profile](StructureDefinition-lighthouse-tiu-docref.html), with `docStatus` set from the service's status.

If an internal service fails or its response can't be used, Lighthouse returns 502, 503 or 504 with an OperationOutcome (see [Design](design.html#excluded-statuses-at-runtime)).

### Internal status labels (reference)

Some services label VistA's COMPLETED status as SIGNED internally. The labels are recorded in [Internal TIU Status Labels](CodeSystem-internal-tiu-status.html) and mapped to VistA TIU statuses in [Internal TIU Status Labels to VistA TIU Status](ConceptMap-internal-tiu-status-to-vista-tiu-status.html). Because the services return `docStatus` to Lighthouse, these labels never reach Lighthouse or its clients.

| Internal label | VistA TIU status | docStatus |
|---|---|---|
| UNSIGNED | UNSIGNED | preliminary |
| UNCOSIGNED | UNCOSIGNED | preliminary |
| SIGNED | COMPLETED | final |
