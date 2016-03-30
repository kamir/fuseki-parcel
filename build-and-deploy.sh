#!/bin/bash
#
# BUILD PARCEL
#
# BUILD CSD
#
# DEPLOY TO TEST VM
#

rm -r repo

set -e

POINT_VERSION=2 VALIDATOR_DIR=/GITHUB/FusekiCloud/fuseki-parcel/tmp/cm_ext ./build-parcel.sh tmp/jena/jena-fuseki2/jena-fuseki-server/target/jena-fuseki-server-2.4.0-SNAPSHOT.jar

POINT_VERSION=2 VALIDATOR_DIR=/GITHUB/FusekiCloud/fuseki-parcel/tmp/cm_ext ./build-csd.sh

PORT=9999
SERVER=127.0.0.1

#
# COPY CSD to CM-Server
#-----------------------

#
# Expose parcel on local server
#-------------------------------

mkdir repo
cp -r build-parcel/* repo
cd repo

echo 
echo ">>> Now you can point the CM server to this parcel repository:"
echo ">>> Server :  $SERVER"
echo ">>> PORT   :  $PORT"
echo 

python -m SimpleHTTPServer $PORT 



