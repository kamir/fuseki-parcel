# Fuseki-Parcel
===============

Let's deploy Apache Fuseki servers in a CDH cluster via Cloudera Manager.
This project was inspired also by: NiFi Parcel.

The repository provides all you need to create a parcel (see: https://github.com/cloudera/cm_ext) for
installation Apache Fuseki as a service manageble by Cloudera Manager.

# Installation 
0. Prerequisites: `cloudera/cm_ext`
```sh
cd /tmp
git clone https://github.com/cloudera/cm_ext
cd cm_ext/validator
mvn install
```

1. Create the Parcel & CSD:
```sh
$ cd /tmp
# Load the Fuseki Release package
$ git clone https://github.com/apache/jena
$ cd jena
$ mvn clean install
$ cd /tmp
$ git clone http://github.com/kamir/fuseki-parcel
$ cd fuseki-parcel
$ POINT_VERSION=5 VALIDATOR_DIR=/tmp/cm_ext ./build-parcel.sh /tmp/fuseki-parcel/fuseki-assembly/target/fuseki-*-SNAPSHOT-bin.tar.gz
$ VALIDATOR_DIR=/tmp/cm_ext ./build-csd.sh
```

2. Serve Parcel using Python
```sh
$ cd build-parcel
$ python -m SimpleHTTPServer 14641
# navigate to Cloudera Manager -> Parcels -> Edit Settings
# Add fqdn:14641 to list of urls
# install the Fuseki parcel
```

4. Move CSD to Cloudera Manager's CSD Repo
```sh
# transfer build-csd/FUSEKI-1.0.jar to CM's host
$ cp FUSEKI-1.0.jar /opt/cloudera/csd
$ mkdir /opt/cloudera/csd/FUSEKI-1.0
$ cp FUSEKI-1.0.jar /opt/cloudera/csd/FUSEKI-1.0
$ cd /opt/cloudera/csd/FUSEKI-1.0
$ jar xvf FUSEKI-1.0.jar
$ rm -f FUSEKI-1.0.jar
$ sudo service cloudera-scm-server restart
# Wait a min, go to Cloudera Manager -> Add a Service -> FUSEKI
```

## Pending items
- Currently `FUSEKI` runs under the `root` user
- Expose config options under Cloudera Manager
  - Conf folder from parcels is used, this needs to be migrated to ConfigWriter
- Expose metrics from FUSEKI

