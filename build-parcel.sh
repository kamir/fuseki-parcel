#!/bin/bash
set -e

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

echo $PARCELNAME
echo $PARCELVERSION
echo $VALIDATOR_DIR
echo $POINT_VERSION

echo $SRC_DIR
echo $BUILD_DIR
echo $PARCEL_NAME
echo $SHORT_VERSION
echo $FULL_VERSION

# Make Build Directory
if [ -d $BUILD_DIR ];
then
  rm -rf $BUILD_DIR
fi

# Make directory
mkdir $BUILD_DIR

# FUSEKI Meta
cp -r $SRC_DIR $BUILD_DIR/$PARCEL_NAME

# Create Copy
cp $FUSEKI_TAR_PATH $BUILD_DIR/$PARCEL_NAME
cd $BUILD_DIR/$PARCEL_NAME
tar xvfz $FUSEKI_TAR_NAME
rm -f $FUSEKI_TAR_NAME
mv fuseki-*/* .
rmdir fuseki-*
chmod -R 755 ./lib ./conf





# move into BUILD_DIR
cd ..

for file in `ls $PARCEL_NAME/meta/**`
do
  sed -i "" "s/<VERSION-FULL>/$FULL_VERSION/g"     $file
  sed -i "" "s/<VERSION-SHORT>/${SHORT_VERSION}/g" $file
done

# validate directory
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -d $PARCEL_NAME

# http://superuser.com/questions/61185/why-do-i-get-files-like-foo-in-my-tarball-on-os-x
export COPYFILE_DISABLE=true

# create parcel
tar zcvf ${PARCEL_NAME}-el6.parcel ${PARCEL_NAME}

# validate parcel
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -f ${PARCEL_NAME}-el6.parcel

# create manifest
$VALIDATOR_DIR/make_manifest/make_manifest.py
