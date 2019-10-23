#!/bin/bash

workers=( 4 6)
delays=( 10 35 140 500)

for ((j=0;j<${#delays[@]};++j)); do
    for ((i=0;i<${#workers[@]};++i)); do
        # Start delay
        for ((w=1;w<=${workers[i]};w++)); do
            ./pumba netem --duration 300m delay --time ${delays[j]} containers performance_evaluation_spark-worker_${w} &
        done

        # Start experiment
        name="delay-w${workers[i]}-d${delays[j]}"
        echo ${name}
        ./scripts/submit-experiment.sh ${name} ${workers[i]}

        # Kill delays
        pkill -f 'pumba'
    done
done

