#!/bin/bash

# Spark options
SPARK_MASTER="spark://spark-master:7077"
# The total cores of the Spark Cluster that are going to be used for this task
# Note: if you claim to many CPUS, the task will be started but with 0 allocated CPUS
TOTAL_CORES=1
# The CPUS and Memory per node in the Spark Cluster, that is going to be used for this task
EXECUTOR_CORES=1
EXECUTOR_MEMORY=1g

# Python run options
# https://github.com/intel-analytics/BigDL/tree/master/pyspark/bigdl/models/lenet
PYTHON_MAIN="/opt/src/lenet5.py"
# Batch size must be divisible by total_cores into integer
PYTHON_ARGS="--action train --dataPath /opt/data --batchSize 128 --endTriggerType epoch --endTriggerNum 20"

# Note: docker volumes on Windows require full absolute path..
EXPERIMENT_NAME="name_me"
REPEATS=10

echo "Starting with options:"
echo "Py Main: ${PYTHON_MAIN}"
echo "Args: ${PYTHON_ARGS}"
echo "Log Name: "${EXPERIMENT_NAME}

for i in $(eval echo "{1..${REPEATS}}"); do
    fname="logs/"${EXPERIMENT_NAME}_${i}".log"

    docker run --rm --network spark-cluster-network \
           --name spark-submit \
           -e SPARK_MASTER=${SPARK_MASTER} \
           -e TOTAL_CORES=${TOTAL_CORES} \
           -e EXECUTOR_CORES=${EXECUTOR_CORES} \
           -e EXECUTOR_MEMORY=${EXECUTOR_MEMORY} \
           -p 4040:4040 \
           spark-cluster/spark:latest \
           /opt/submit.sh ${PYTHON_MAIN} ${PYTHON_ARGS} > ${fname}

    echo "Finished [${i}/${REPEATS}]"
done
