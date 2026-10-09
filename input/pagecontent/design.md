### Lighthouse and internal services

Clients call Lighthouse. Lighthouse obtains TIU notes from internal services (including AIScribe, CES, VFNA) and presents them as this guide describes. The services do not enforce the profile or reject unserved statuses. Some layers may resemble FHIR without reliably conforming to it. Lighthouse is responsible for what a client sees:

- **Status values.** Services return docStatus (`preliminary` or `final`). Lighthouse exposes only docStatus; it does not expose VistA TIU statuses or the labels services use internally.
- **Conformance.** Lighthouse builds each DocumentReference so that it conforms to the profile, whatever form service responses take. 
- **Scope.** Lighthouse returns only `preliminary` and `final` notes at this time.
- **Search.** Lighthouse checks `docStatus` filters before calling services, rejects unserved and unknown values itself, and passes the rest on in whatever form the services expect.
- **Errors.** Lighthouse returns the error responses described below. It never turns an upstream failure into an empty result.

[Internal Services](internal-services.html) notes what Lighthouse does with what the services return.

### Artifact design responsibilities

The design separates what constrains instances from what explains them.

**The binding constrains values.** `docStatus` is required and bound (required) to `preliminary` and `final`. This is the normative statement of data availability: an instance carrying any other value is invalid.

**The terminology explains.** The VistA TIU Status code system and the TIU-to-docStatus ConceptMap are reference material. They are not needed for conformance. The ConceptMap records which VistA TIU statuses lie behind each `docStatus` value (UNSIGNED and UNCOSIGNED behind `preliminary`, COMPLETED behind `final`) and marks the other eleven as `unmatched` rather than leaving them silently absent. It is linked from the profile through the [elementdefinition-conceptmap](http://hl7.org/fhir/extensions/StructureDefinition-elementdefinition-conceptmap.html) extension on the `docStatus` binding's value set, so a reader of the profile can find it.

Lighthouse does not expose the TIU status itself. `preliminary` therefore does not tell a client whether a note awaits signature or cosignature.

### The docStatus search parameter

R4 defines no search parameter on `DocumentReference.docStatus`, so this guide defines one. Its code is `docStatus`, following Lighthouse's camelCase convention and matching the element name. R5 core defines the same parameter as `doc-status`; a client moving between the two needs to use the right spelling.

### Excluded statuses at runtime

The response depends on whether the client asked about a status. The [Search](search.html) page shows each case.

**A filtered search gets an explicit answer.** A client that names a status is asking about documents in that status. An empty Bundle for `docStatus=amended` would tell it there are none, which is false: amended notes may exist in VistA, and this API does not search for or return them. A 400 says the question can't be answered here. A mixed list is rejected as a whole for the same reason; returning only the served values would imply the rest are known not to exist. Because the served values are fixed, Lighthouse makes this check itself, before calling any internal service.

**An unfiltered search does not.** It asks for no status in particular, so the standing scope rule, stated once in the CapabilityStatement, is sufficient. Attaching an OperationOutcome to every response would be noise that clients learn to ignore. `206 Partial Content` is not used: it belongs to HTTP range requests and does not mean "some records are out of scope."

**`not-supported` vs `code-invalid`.** A real docStatus code that Lighthouse does not serve (`amended`, `entered-in-error`) is `not-supported`; a value outside the docStatus code system is `code-invalid`. Each carries a code from [Lighthouse Search Error Codes](CodeSystem-lighthouse-search-error.html) in `details.coding`, so clients can branch without parsing text. `Prefer: handling` does not change any of these responses: it governs unknown parameters, and `docStatus` is known.

**Upstream failure is an error, not an empty result.** If an internal service fails, times out or returns something Lighthouse cannot use, Lighthouse returns 502, 503 or 504 with an OperationOutcome (`transient`, `upstream-error`). It does not return an empty or partial Bundle, for the same reason it does not return an empty Bundle for `amended`: the client would read it as "none."

**Reads return 404,** consistent with search: an out-of-scope note is not a resource this API exposes, and 403 would wrongly suggest that different credentials could retrieve it.

Profile conformance is checked separately: `input/tests/` holds an invalid DocumentReference instance, not built into the guide, that fails the `docStatus` binding under the FHIR validator.
