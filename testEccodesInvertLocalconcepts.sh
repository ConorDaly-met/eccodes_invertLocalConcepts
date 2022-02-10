#!/bin/bash

if [ "X$(hostname | cut -f1 -d-)" == "Xcca" ]; then
	source /scratch/ms/ie/duuw/hm_home/cca_dini25a_l90_arome/lib/config-sh/choose_PrgEnv.cca gnu
	if [ -z "${ECCODES_DEFINITION_PATH}" ]; then
		export ECCODES_DEFINITION_PATH=/perm/ms/ie/ducd/metapp/eccodes/localDefs:${ECCODES_DIR}/share/ecdodes/definitions
	fi
fi
if [ $# -gt 0 ]; then
	ECVER=$1
	module switch eccodes eccodes/${ECVER}
	module load eccodes/${ECVER}
	shift
fi

bindir=$(dirname $0)
if [ $(echo $bindir | cut -c1) == '.' ]; then
	bindir=$(pwd)/$bindir
fi
srcdir=${bindir}/src
datadir=${bindir}/data
TMPDIR=tmp$$
mkdir $TMPDIR && cd $TMPDIR

ECCODESVER=$(codes_info -v)
echo
echo "ECCODES VERSION: ${ECCODESVER}"
ECCODESMAJMINVER=$(echo $ECCODESVER | cut -f1,2 -d. | tr -d '.')
echo "ECCODES VERSION: ${ECCODESMAJMINVER}"

if [ ${ECCODESMAJMINVER} -lt 218 ]; then
	echo "ECCODES VERSION: ${ECCODESVER}  -  OK"
	exit 0
fi
echo
cp ${datadir}/sample.grib2 .
gfortran $ECCODES_INCLUDE $ECCODES_LIB -o getCodesVersion ${srcdir}/getCodesVersion.f90
./getCodesVersion

gfortran $ECCODES_INCLUDE $ECCODES_LIB -o readSample ${srcdir}/readSample.f90
./readSample
STATUS=$?
echo
ls -l
grib_ls -p paramId,discipline,parameterCategory,parameterNumber,shortName sample_out.grib2
cd - && rm -r $TMPDIR
if [ $STATUS -eq 0 ]; then
	echo "ECCODES VERSION: ${ECCODESVER}  -  OK"
	exit $STATUS
else
	echo "ECCODES VERSION: ${ECCODESVER}  -  FAILED"
	exit $STATUS
fi

