# CES DocumentReference docStatus constraints (FSH IG)

A draft FHIR R4 IG (US Core 6.1.0 based) that constrains `DocumentReference.docStatus` for VistA TIU notes served by CES.
It carries the source TIU status in the `alternate-codes` extension, enforces the status pairing with invariants,
and documents the excluded TIU statuses in an informative ConceptMap.

- `input/fsh/`: profile, invariants, terminology, ConceptMap, SearchParameters, CapabilityStatement, examples
- `input/pagecontent/`: Home, Design and Open Issues pages
- `input/tests/`: three deliberately invalid instances, not built into the IG; each should fail one rule

Build with SUSHI (`sushi build .`) and then the IG Publisher. To check the invariants directly:

    java -jar validator_cli.jar -version 4.0.1 -ig fsh-generated/resources -ig hl7.fhir.us.core#6.1.0 input/tests/*.json

