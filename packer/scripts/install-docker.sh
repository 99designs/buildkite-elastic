#!/bin/bash -eux

sudo yum update -yq
sudo yum install -yq docker
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker buildkite-agent

sudo cp /tmp/conf/docker.conf /etc/sysconfig/docker
sudo cp /tmp/conf/subuid /etc/subuid
sudo cp /tmp/conf/subgid /etc/subgid

# Overwrite the yum packaged docker with the latest
sudo wget https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 -O /usr/bin/docker
sudo chmod +x /usr/bin/docker

sudo service docker start || ( cat /var/log/docker && false )
sudo docker info

# installs docker-compose
sudo curl -o /usr/bin/docker-compose -L https://github.com/docker/compose/releases/download/1.5.0/docker-compose-Linux-x86_64
sudo chmod +x /usr/bin/docker-compose

# install docker-gc
curl -L https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc > docker-gc
sudo mv docker-gc /etc/cron.hourly/docker-gc
sudo chmod +x /etc/cron.hourly/docker-gc

# install jq
sudo curl -o /usr/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod +x /usr/bin/jq
