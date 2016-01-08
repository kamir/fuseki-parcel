#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <PATH_TO_FUSEKI_BINARY_RELEASE>"
  exit 1
fi

if [ -f $1 ]
then
    echo [OK] Binary distribution file $1 exists.
else
    echo [PROBLEM] file $1 does not exist!
    exit -1
fi


#
# Example: How to call the script?
#
# POINT_VERSION=1 VALIDATOR_DIR=./../cm_ext ./build-parcel.sh ./../jena/jena-fuseki2/jena-fuseki-server/target/jena-fuseki-server-2.4.0-SNAPSHOT.jar

#
# The parcel name and version reflects the name of the service which is shipped.
#
PARCELNAME=FUSEKI
PARCELVERSION=2.3
VALIDATOR_DIR=${VALIDATOR_DIR:-/tmp/cm_ext}
POINT_VERSION=${POINT_VERSION:-1}

SRC_DIR=${SRC_DIR:-parcel-src}
BUILD_DIR=${BUILD_DIR:-build-parcel}
PARCEL_NAME=$(echo FUSEKI-${PARCELVERSION}.${POINT_VERSION}.fuseki.p0.${POINT_VERSION})
SHORT_VERSION=$(echo ${PARCELVERSION}.${POINT_VERSION})
FULL_VERSION=$(echo ${SHORT_VERSION}.fuseki.p0.${POINT_VERSION})

FUSEKI_BINARY_HOME_PATH=./csd-src

#
# Is Validator available ?
#
if [ -f $VALIDATOR_DIR/validator/target/validator.jar ]
then
    echo [OK] Validator is available.
else
    echo [PROBLEM] Validator does not exist!
    echo "         $VALIDATOR_DIR/validator/target/validator.jar"
    exit -1
fi




echo
echo "FUSEKI-Binary:    $1"
echo 
echo "PARCEL-NAME:      $PARCELNAME"
echo "PARCEL-VERSION:   $PARCELVERSION"
echo "POINT-VERSION:    $POINT_VERSION"
echo
echo "Validator tool:   $VALIDATOR_DIR"
echo
echo "SRC DIR:          $SRC_DIR"
echo "BUILD DIR:        $BUILD_DIR"
echo "PARCEL Name:      $PARCEL_NAME"
echo "SHORT Version:    $SHORT_VERSION"
echo "FULL Version:     $FULL_VERSION"
echo
echo "FUSEKI BIN HOME:  $FUSEKI_BINARY_HOME_PATH"
echo

# Clean up Build Directory
if [ -d $BUILD_DIR ];
then
  rm -rf $BUILD_DIR
fi

# Make Build Directory
mkdir $BUILD_DIR

cp -r $SRC_DIR $BUILD_DIR/$PARCEL_NAME

#
# Here we might change the FUSEKI Jar and War file later on.
# But we must be in line with the binary tools coming with Fuseki.
#
# For now we use the "pre packaged binaries for Fuseki 2.3
#
cp -r $FUSEKI_BINARY_HOME_PATH/main $BUILD_DIR/$PARCEL_NAME

cd $BUILD_DIR

for file in `ls $PARCEL_NAME/meta/**`
do
  sed -i "" "s/<VERSION-FULL>/${FULL_VERSION}/g" $file
  sed -i "" "s/<VERSION-SHORT>/${SHORT_VERSION}/g" $file
done

for file in `ls $PARCEL_NAME/meta/**`
do
  cat $file
done

ls
ls $PARCEL_NAME

echo
echo "[OK] PREPARATION IS DONE."
echo

# validate directory
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -d $PARCEL_NAME

echo
echo "[OK] VALIDATION IS DONE."
echo
		
# http://superuser.com/questions/61185/why-do-i-get-files-like-foo-in-my-tarball-on-os-x
export COPYFILE_DISABLE=true

# create parcel
tar zcvf ${PARCEL_NAME}-el6.parcel ${PARCEL_NAME}

echo
echo "[OK] Parcel is ready."
echo

# validate parcel
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -f ${PARCEL_NAME}-el6.parcel

echo
echo "[OK] Parcel is validation is done."
echo


# create manifest
$VALIDATOR_DIR/make_manifest/make_manifest.py

echo
echo "[OK] Manifest validation is done."
echo

