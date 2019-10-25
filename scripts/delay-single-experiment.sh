#!/bin/bash

workers=( 1 2 4 6)
delays=( 10 35 140 500)

for ((j=0;j<${#delays[@]};++j)); do
    for ((i=0;i<${#workers[@]};++i)); do
        # Start delay
        ./pumba netem --duration 300m delay --time ${delays[j]} containers performanceevaluation_spark-worker_1 &
        sleep 5

        # Start experiment
        name="delay-w${workers[i]}-d${delays[j]}"
        echo ${name}
        ./scripts/submit-experiment.sh ${name} ${workers[i]}

        # Kill delays
        pkill -f 'pumba'
        sleep 5
    done
done

