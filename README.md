# Fuseki-Parcel
Let's deploy Apache Fuseki services in a CDH cluster via Cloudera Manager.

The repository provides all you need to create a parcel for automatic installation of Apache Fuseki as a service manageble by Cloudera Manager (see: https://github.com/cloudera/cm_ext for more details about parcels).


---------------

# Installation 
## Prerequisites: 

`cloudera/cm_ext`
```sh
cd /tmp
git clone https://github.com/cloudera/cm_ext
cd cm_ext
mvn clean compile install -Dmaven.test.skip=true
```

Note: You should add this section to the <repoisitories/> in your POM file after cloning 
the Apache Jena project, to have the latest snaphsots involved.

```xml
  <repository>
    <id>apache-repo-snapshots</id>
    <url>https://repository.apache.org/content/repositories/snapshots/</url>
    <releases>
      <enabled>false</enabled>
    </releases>
    <snapshots>
      <enabled>true</enabled>
    </snapshots>
  </repository>
```

`apache/jena-fuseki2`
```sh
cd /tmp
git clone https://github.com/apache/jena
#
# See note above !
#
cd jena/jena-fuseki2
mvn clean install package -U
```

Now we are ready to build the Parcel and the CSD.

## Create the Parcel & CSD:
```sh
cd /tmp
git clone http://github.com/kamir/fuseki-parcel
cd fuseki-parcel
POINT_VERSION=1 VALIDATOR_DIR=/Users/kamir/GITHUB/tmp/cm_ext ./build-parcel.sh ./../jena/jena-fuseki2/jena-fuseki-server/target/jena-fuseki-server-2.4.0-SNAPSHOT.jar
VALIDATOR_DIR=/Users/kamir/GITHUB/tmp/cm_ext ./build-csd.sh
```

Note: You have to change the path $VALIDATOR_DIR.

## Serve Parcel using Python
```sh
cd build-parcel
python -m SimpleHTTPServer 14641
```

Now we can navigate to the Cloudera Manager -> Parcels -> Edit Settings page. Please add 
the location of the new parcel provider (FQDN:PORT) to list of urls. 

The Fuseki-Parcel can be installed now. 

## Deploy the CSD to Cloudera Manager's CSD Repository
```sh
# transfer build-csd/FUSEKI-1.0.jar to CM's host
cp FUSEKI-1.0.jar /opt/cloudera/csd
$ mkdir /opt/cloudera/csd/FUSEKI-1.0
cp FUSEKI-1.0.jar /opt/cloudera/csd/FUSEKI-1.0
cd /opt/cloudera/csd/FUSEKI-1.0
jar xvf FUSEKI-1.0.jar
rm -f FUSEKI-1.0.jar
sudo service cloudera-scm-server restart
# Wait a min, go to Cloudera Manager -> Add a Service -> FUSEKI
```

# Pending items
- Currently `FUSEKI` runs under the `root` user
- Expose more config options under Cloudera Manager
- Expose metrics from FUSEKI

