# CS4215 - Quantitative Performance Evaluation for Computing Systems

## How to run
- Build the docker container: `docker build -t spark-cluster/spark:latest .`
- Start the cluster with x workers: `docker-compose up --scale workers=x`
- Submit the BigDL program to the cluster according to the example in `example-submit.sh`

Spark Master is available at `localhost:8080/`
Spark Submit dashboard is available at `localhost:4040/`
