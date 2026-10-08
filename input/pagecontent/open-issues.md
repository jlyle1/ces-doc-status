### SIGNED vs COMPLETED

CES reports VistA's COMPLETED status as SIGNED. The guide now defines SIGNED in a separate CES TIU Status code system and maps it to COMPLETED (see [Design](design.html#signed-and-completed)). Still to confirm:

- Whether CES will emit the CES TIU Status system URI on its coding, or only a bare code. A bare code satisfies neither the binding nor the slice discriminator.
- Whether CES can also emit the VistA coding. It is optional, but it is the only way a client sees the source value directly.
- Whether CES accepts `tiuDocumentStatus=COMPLETED` as a synonym for SIGNED, as the CapabilityStatement now says.

### TIU status coverage

The code system holds all 14 entries in the TIU STATUS file (#8925.6). The availability ConceptMap marks 3 as matched (UNSIGNED, UNCOSIGNED, COMPLETED) and 11 as `unmatched`. TEST, ACTIVE and INACTIVE apply to document titles (#8925.1 field .07, screened to statuses appropriate for document definitions), not to document instances, so they are not expected on notes at all. A separate semantic ConceptMap covering the document statuses (for example AMENDED → amended, RETRACTED → entered-in-error) could be added. It would be informative and unbound.

### Excluded statuses

The CES service only provides 3 of 11 status values. It's clear that an "undictated" or "untranscribed" note may be useless in a document API, but "amended" seems to be a clear gap for most use cases. This may be exactly what is required for the (unspecified) use case. The runtime behavior is now specified (see [Design](design.html#excluded-statuses-at-runtime) and the CapabilityStatement), so clients that filter on an excluded status get an explicit error rather than an empty result.

### Migration from empty Bundle to 400

Earlier drafts of this guide said a search for an excluded status returns an empty Bundle. If that describes CES's current behavior, the change to HTTP 400 breaks any client that treats an empty Bundle as "none in that status." Rollout (versioning, notice to known clients, any transition period) is open.

### References to excluded notes

If CES populates `DocumentReference.relatesTo` (for example, an addendum whose parent note is AMENDED), some references will point at notes this API does not serve and will not resolve (a read returns 404). Whether CES populates `relatesTo`, and if so whether the CapabilityStatement should say so, needs to be confirmed.

### tiuDocumentStatus

CES filters on a `tiuDocumentStatus` parameter that it has not formally declared. This guide declares it, under the same name, as a SearchParameter whose expression points at the CES coding carried in the resource. It is still open whether CES's implementation matches that expression: in particular, whether it searches the value it emits (SIGNED) or the VistA value (COMPLETED), and whether it will publish this SearchParameter in its CapabilityStatement.

### alternate-codes maturity

The alternate-codes extension is draft (maturity 1) in the FHIR Extensions Pack. It is still preferred over defining a new extension, but its definition could change.
