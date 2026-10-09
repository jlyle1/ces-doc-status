# Lighthouse DocumentReference for VistA TIU notes (FSH IG)

A draft FHIR R4 IG (US Core 6.1.0 based) defining how Lighthouse presents VistA TIU notes it obtains from internal VA services:
`docStatus` (preliminary | final), the `docStatus` search parameter, and the error responses for unserved or unknown values.
VistA TIU status terminology and ConceptMaps are kept for reference.

- `input/fsh/`: profile, terminology, ConceptMaps, SearchParameter, CapabilityStatement, examples (DocumentReferences, search Bundles, OperationOutcomes)
- `input/pagecontent/`: Home, Search, Design, Internal Services and Open Issues pages
- `input/tests/`: one deliberately invalid instance (docStatus amended), not built into the IG; it should fail the docStatus binding

Build with SUSHI (`sushi build .`) and then the IG Publisher. To check the test instance directly:

    java -jar validator_cli.jar -version 4.0.1 -ig fsh-generated/resources -ig hl7.fhir.us.core#6.1.0 input/tests/*.json

Pages build: https://jlyle1.github.io/ces-doc-status/
