#!/bin/bash
set -e

#
# The parcel name and version reflects the name of the service which is shipped.
#
PARCELNAME=FUSEKI
PARCELVERSION=2.3

if [[ $# -ne 0 ]]; then
  echo "Usage: $0"
  exit 1
fi

VALIDATOR_DIR=${VALIDATOR_DIR:-./../tmp/cm_ext}
POINT_VERSION=${POINT_VERSION:-1}

SRC_DIR=${SRC_DIR:-csd-src}
BUILD_DIR=${BUILD_DIR:-build-csd}

#
# validate directory
#
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -s $SRC_DIR/descriptor/service.sdl

if [ -d $BUILD_DIR ];
then
  rm -rf $BUILD_DIR
fi
mkdir $BUILD_DIR

cd $SRC_DIR
jar -cvf $PARCELNAME-$PARCELVERSION.jar *

cd ..
mv $SRC_DIR/$PARCELNAME-$PARCELVERSION.jar $BUILD_DIR/.

