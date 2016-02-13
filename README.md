# Fuseki-Parcel
Let's deploy Apache Fuseki services in a CDH cluster via Cloudera Manager.

The repository provides all you need to create a parcel for automatic installation of Apache Fuseki as a service manageble by Cloudera Manager (see: https://github.com/cloudera/cm_ext for more details about parcels).

---------------
Known Issues:

- The main folder is to big for shipping it in the CSV file => therefore we deploy it as parcel separately
- The Fuseki client needs Ruby (sudo yum install ruby)
- Fuseki Server need Java8 
 '''
 sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u72-b15/jdk-8u72-linux-x64.tar.gz"
 '''
- the path to Java8 is provided to the start script as a parameter "Private_JDK". 
---------------

# Installation 
## Prerequisites: 

Start in an empty directory, such as YOUR_WORK_DIR/tmp.

```sh
cd tmp
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
Note: You have to change the path $VALIDATOR_DIR. 

In case you use the Cloudera Quickstart VM these commands will work:
```sh
cd tmp
git clone http://github.com/kamir/fuseki-parcel
cd fuseki-parcel
POINT_VERSION=1 VALIDATOR_DIR=/home/cloudera/tmp/cm_ext ./build-parcel.sh ./../jena/jena-fuseki2/jena-fuseki-server/target/jena-fuseki-server-2.4.0-SNAPSHOT.jar
VALIDATOR_DIR=/home/cloudera/tmp/cm_ext ./build-csd.sh
```
Additionally, you have to install Java 8 to compile Jena. To skip this issue,
we rely on the prebuild version (Apache Fuseki 2.3) which is part of this project already.
No need to download or to compile for now, but we want to be prepared for later, especially
id new featutes arrive in Fuseki land. 

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
The Fuseki-Server should be installed on a Gateway node to enable internal and external access.

Primarily it is used for METADATA exposure as RDF graph. We use the Etosha tools to export Hive and HDFS metadata.
Other sources are Cloudera Manager and Cloudera Navigator. This way we can savely control which details of highly
sensitive internal metadata can be used by external tools in a standardized way.





