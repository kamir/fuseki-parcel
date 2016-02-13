#!/bin/bash

export FUSEKI_HOME=/opt/fuseki/scripts/main/apache-jena-fuseki-2.3.0
export JAVA_HOME=$PRIVATE_JAVA_HOME

#
# Here we use a CLI parameter to define a location of the modelfile and the port.
#
CMD=$1
MODEL_FILE=$DEFAULT_GRAPH
PORT=$WEBSERVER_PORT

######################################
#
#  Etosha Triple Collector Service
#

case $CMD in
  (start)
    clear
    echo "      FUSEKI_HOME: $FUSEKI_HOME"
    echo "        JAVA_HOME: $JAVA_HOME"
    echo "             PORT: $WEBSERVER_PORT"
    echo "       MODEL_FILE: $MODEL_FILE"
    echo " PARTITION_FOLDER: $PART_FOLDER"

    echo ">>> Starting the Fuseki-Server on port [$WEBSERVER_PORT] (default: 3030)"

    exec $FUSEKI_HOME/fuseki-server --file=$MODEL_FILE --update --port=$WEBSERVER_PORT /ETCS &

    sleep 2

#    FILES=$PART_FOLDER/*
#    for f in $FILES
#    do
#      echo "> LOAD GRAPH-PARTITION $f ..."
#      # take action on each file. $f store current file name
#
#      $FUSEKI_HOME/bin/s-post http://localhost:$WEBSERVER_PORT/ETCS/data default $f
#    done

    ;;
  (list)
      $FUSEKI_HOME/bin/s-query --service http://localhost:$WEBSERVER_PORT/ETCS/query 'SELECT * {?s ?p ?o}'
    ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
