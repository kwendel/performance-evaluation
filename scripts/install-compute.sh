#!/bin/bash

echo "Not working yet -- see commands"
exit

sudo apt update && sudo apt install -y docker docker-compose

git clone https://github.com/kwendel/performance-evaluation.git && cd performance-evaluation

# gcloud compute scp --project "qpe-project-254709" --zone "europe-west4-b" performance-evaluation/ instance-1:~/performance-evalution/ --recurse

wget https://github.com/alexei-led/pumba/releases/download/0.6.5/pumba_linux_amd64 && mv pumba_linux_amd64 pumba && chmod +x pumba

sudo usermod -aG docker $USER && sudo reboot
