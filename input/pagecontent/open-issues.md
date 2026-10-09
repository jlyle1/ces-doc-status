### Excluded statuses

Lighthouse serves only notes behind 3 of the 11 document statuses (`preliminary` and `final`). It's clear that an "undictated" or "untranscribed" note may be useless in a document API, but "amended" seems to be a clear gap for most use cases. This may be exactly what is required for the (unspecified) use case. The runtime behavior is specified (see [Design](design.html#excluded-statuses-at-runtime) and the CapabilityStatement), so clients that filter on `amended` or `entered-in-error` get an explicit error rather than an empty result.

### Preliminary does not distinguish unsigned from uncosigned

Lighthouse exposes only `docStatus`, so a client cannot tell a note awaiting signature from one awaiting cosignature. If a use case needs that distinction, it would need a separate element (for example, the VistA TIU status in an extension) and a way for internal services to supply it. Neither is planned.

### docStatus parameter name

The search parameter is `docStatus`, following Lighthouse's camelCase convention. R5 core defines the same parameter as `doc-status`. Whether Lighthouse should also accept `doc-status`, for clients written against R5 conventions, is open.

### References to excluded notes

If Lighthouse populates `DocumentReference.relatesTo` (for example, an addendum whose parent note is AMENDED), some references will point at notes this API does not serve and will not resolve (a read returns 404). Whether `relatesTo` is populated, and if so whether the CapabilityStatement should say so, needs to be confirmed.

### Internal service behavior Lighthouse depends on

The [Internal Services](internal-services.html) page assumes service behavior that is not yet confirmed:

- Whether the services can filter on status, including lists of values. If not, Lighthouse filters the results itself.
- Whether any service returns notes with other statuses. Lighthouse drops them either way.
- How each service signals failure (HTTP status, empty response, partial response), so Lighthouse can tell a failure from "no documents."

### TIU status coverage

The VistA TIU Status code system (reference) holds all 14 entries in the TIU STATUS file (#8925.6). The availability ConceptMap marks 3 as served (UNSIGNED, UNCOSIGNED, COMPLETED) and 11 as `unmatched`. TEST, ACTIVE and INACTIVE apply to document titles (#8925.1 field .07, screened to statuses appropriate for document definitions), not to document instances, so they are not expected on notes at all. A separate semantic ConceptMap covering the document statuses (for example AMENDED → amended, RETRACTED → entered-in-error) could be added. It would be informative and unbound.
