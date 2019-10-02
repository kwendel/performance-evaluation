# CS4215 - Quantitative Performance Evaluation for Computing Systems

## Installing istio
- Download the latest release from istio from github, 1.3.1 as of writing
- Extract into the root of the project
- Install istio on the cluster you're connected to with `./scripts/deploy-cluster.yaml`

## How to run
- Build the docker container: `docker build -t spark-cluster/spark:latest .`
- Start the cluster with x workers: `docker-compose up --scale workers=x`
- Submit the BigDL program to the cluster according to the example in `example-submit.sh`

Spark Master is available at `localhost:8080/`
Spark Submit dashboard is available at `localhost:4040/`
