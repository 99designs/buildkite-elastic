#!/bin/bash -eu

sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

sudo yum update -yq
sudo yum install -yq docker-engine
sudo usermod -a -G docker ec2-user
sudo cp /tmp/conf/docker.conf /etc/sysconfig/docker
sudo cp /tmp/conf/subuid /etc/subuid
sudo cp /tmp/conf/subgid /etc/subgid

sudo service docker start
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
