# Fuseki-Parcel
Let's deploy some Apache Fuseki servers in a CDH cluster via Cloudera Manager.

The repository provides all you need to build a parcel for automatic installation of 
Apache Fuseki as a service which is manageble by Cloudera Manager 
(see: https://github.com/cloudera/cm_ext for more details about parcels).

---------------
Known Issues:

- The main folder is too big for shipping it in a CSD file => therefore we deploy Apache Fuseki incl. Jetty as parcel separately
- The Fuseki client needs Ruby (sudo yum install ruby)
- the path to Java8 is provided to the start script as a parameter "Private_JDK". 
- The Apache Fuseki Server needs Java8 

```sh
 sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u72-b15/jdk-8u72-linux-x64.tar.gz"
```
---------------

# Installation 
## Prerequisites: 

Start in an empty directory, such as "YOUR_WORK_DIR/tmp".

###Prepare cm-tools in temp-folder

```sh
cd tmp
git clone https://github.com/cloudera/cm_ext
cd cm_ext
mvn clean compile install -Dmaven.test.skip=true
```

Note: You should add this section to the <repoisitories/> section in your POM file 
after cloning the Apache Jena project. This provides the latest snapshots for fresh builds.

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

###Build Apache-Jena-Fuseki2 Server
```sh
cd tmp
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
cd tmp
git clone http://github.com/kamir/fuseki-parcel
cd fuseki-parcel
POINT_VERSION=1 VALIDATOR_DIR=/Users/kamir/GITHUB/tmp/cm_ext ./build-parcel.sh ./../jena/jena-fuseki2/jena-fuseki-server/target/jena-fuseki-server-2.4.0-SNAPSHOT.jar
VALIDATOR_DIR=/Users/kamir/GITHUB/tmp/cm_ext ./build-csd.sh
```
Note: You have to change the variable: $VALIDATOR_DIR which is the path to the cm-tools created above. 

In case you use the Cloudera Quickstart VM the following example will work:
```sh
cd tmp
git clone http://github.com/kamir/fuseki-parcel
cd fuseki-parcel
POINT_VERSION=1 VALIDATOR_DIR=/home/cloudera/tmp/cm_ext ./build-parcel.sh ./../jena/jena-fuseki2/jena-fuseki-server/target/jena-fuseki-server-2.4.0-SNAPSHOT.jar
VALIDATOR_DIR=/home/cloudera/tmp/cm_ext ./build-csd.sh
```

Here, we rely on the prebuild version (Apache Fuseki 2.3) which is part of this project already.
This means, no need to download or to compile for Fuseki for now, but we want to be prepared for later, especially
if new featutes arrive in Fuseki land. 

Additionally, you would have to install Java 8 to compile Jena.

## Create the Parcel & CSD:
```sh
cd tmp
git clone http://github.com/kamir/fuseki-parcel
cd fuseki-parcel
POINT_VERSION=1 VALIDATOR_DIR=/Users/kamir/GITHUB/tmp/cm_ext ./build-parcel.sh ./../jena/jena-fuseki2/jena-fuseki-server/target/jena-fuseki-server-2.4.0-SNAPSHOT.jar
VALIDATOR_DIR=/Users/kamir/GITHUB/tmp/cm_ext ./build-csd.sh
```

## Serve Parcel using Python
```sh
cd build-parcel
python -m SimpleHTTPServer 14641
```

Now we can navigate to the Cloudera Manager -> Parcels -> Edit Settings page. Please add 
the location of the new parcel provider (FQDN:PORT) to the list of urls. The new Fuseki-Parcel can be installed now. 

```sh
# transfer build-csd/FUSEKI-2.3.jar to CM's host
#
scp FUSEKI-2.3.jar /opt/cloudera/csd
sudo service cloudera-scm-server restart
#
# Wait a min, go to Cloudera Manager -> Add a Service -> FUSEKI
#
```

# Pending items
- Currently `FUSEKI` runs under the `root` user
- Expose more config options under Cloudera Manager
- Expose metrics from FUSEKI
- Only one Fuseki Service is possible per cluster with this parcel.

# Use-Cases:
The Fuseki-Server should be installed on a Gateway node to enable internal and external access to metadata exposed as
a semantic network via SPARQL-queries.

Primarily this parcel is used for METADATA exposure as RDF graph. We use Etosha tools to expose Hive and HDFS metadata.
Other sources for such public METADATA exposure are: Cloudera Manager and Cloudera Navigator. This way we can savely 
control which details of highly sensitive internal metadata can be used by external tools in a standardized way for 
data exploration and data discovery in a de-centralized system.





