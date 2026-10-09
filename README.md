# Lighthouse DocumentReference for VistA TIU notes (FSH IG)

A draft FHIR R4 IG (US Core 6.1.0 based) defining how Lighthouse presents VistA TIU notes it obtains from internal VA services.
It constrains `DocumentReference.docStatus`, carries the VistA TIU status in the `alternate-codes` extension,
enforces the status pairing with invariants, defines status search and error responses, and documents the
excluded TIU statuses and the translation of internal status labels (informative).

- `input/fsh/`: profile, invariants, terminology, ConceptMap, SearchParameters, CapabilityStatement, examples
- `input/pagecontent/`: Home, Design, Internal Services and Open Issues pages
- `input/tests/`: four deliberately invalid instances, not built into the IG; each should fail one rule

Build with SUSHI (`sushi build .`) and then the IG Publisher. To check the invariants directly:

    java -jar validator_cli.jar -version 4.0.1 -ig fsh-generated/resources -ig hl7.fhir.us.core#6.1.0 input/tests/*.json

Pages build: https://jlyle1.github.io/ces-doc-status/
