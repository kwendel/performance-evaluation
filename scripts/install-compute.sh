#!/usr/bin/env bash

sudo apt update
apt install -y docker docker-compose

gcloud compute scp --project "qpe-project-254709" --zone "europe-west4-b" performance-evaluation/ instance-1:~/performance-evalution/ --recurse

wget https://github.com/alexei-led/pumba/releases/download/0.6.5/pumba_linux_amd64
mv pumba_linux_amd64 pumba

sudo usermod -aG docker $USER
sudo reboot
