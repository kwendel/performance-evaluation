#!/bin/bash

# Spark options
SPARK_MASTER="spark://spark-master:7077"
# The total cores of the Spark Cluster that are going to be used for this task
# Note: if you claim to many CPUS, the task will be started but with 0 allocated CPUS
TOTAL_CORES=4
# The CPUS and Memory per node in the Spark Cluster, that is going to be used for this task
EXECUTOR_CORES=1
EXECUTOR_MEMORY=2g

# Python run options
PYTHON_MAIN="/opt/src/lenet5.py"
PYTHON_ARGS="--action train --dataPath /tmp/mnist_test"

# Note: docker volumes on Windows require full absolute path..
docker run --rm --network spark-cluster-network \
           --name spark-submit \
           -e SPARK_MASTER=$SPARK_MASTER \
           -e TOTAL_CORES=$TOTAL_CORES \
           -e EXECUTOR_CORES=$EXECUTOR_CORES \
           -e EXECUTOR_MEMORY=$EXECUTOR_MEMORY \
           -v <path/to/src>:/opt/src \
           -v <path/to/data>:/opt/data \
           -p 4040:4040 \
           spark-cluster/spark:latest \
           /opt/submit.sh ${PYTHON_MAIN} ${PYTHON_ARGS}
