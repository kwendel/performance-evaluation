#!/bin/bash

# Submit a Python program to the spark cluster
# This is done in the machine as we then have acces to all environment variables of Big DL

$BIGDL_HOME/bin/spark-submit-with-bigdl.sh \
    --master $SPARK_MASTER \
    --driver-cores 1  \
    --driver-memory 1g \
    --total-executor-cores $TOTAL_CORES  \
    --executor-cores $EXECUTOR_CORES  \
    --executor-memory $EXECUTOR_MEMORY \
    --py-files ${PYTHON_API_ZIP_PATH},${PYTHON_MAIN}  \
    --properties-file ${BIGDL_HOME}/conf/spark-bigdl.conf \
    --jars ${BIGDL_JAR_PATH} \
    "$1" "$2" \
