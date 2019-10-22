#!/bin/sh

docker-compose run toxiproxy curl -s -XPOST -d '{"type" : "latency", "attributes" : {"latency" : 10000}}' http://toxiproxy:8474/proxies/spark-master/toxics
