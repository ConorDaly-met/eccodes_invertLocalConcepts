# eccodes_invertLocalConcepts

This tests the eccodes version in use for the invertedLocalConcepts bug which affects compiled FORTRAN (and C?) encoding of GRIB files.

Information on the bug is available at https://jira.ecmwf.int/browse/ECC-1200

## Usage

- `testEccodesInvertLocalconcepts.sh [<eccodes.ver.no>]`

   This will build the readSample executable against the currently loaded eccodes api and will test for the encoding bug.

   If `<eccodes.ver.no>` is given, the program will first use the module commands to load the requested eccodes version.



