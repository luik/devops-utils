#!/usr/bin/env bash

instances=3

for i in `seq 1 ${instances}`
do
    index=$(($i + 50))
    sed "s/10.0.0.101/10.0.0.${index}/" i3-large.json > i3-large-${index}.json
    aws ec2 request-spot-instances --spot-price "0.1" --launch-specification file://i3-large-${index}.json
    rm -f i3-large-${index}.json
done

sleep 30

rm -f hosts
echo "[servers]" >> hosts

for i in `seq 1 ${instances}`
do
    index=$(($i + 50))
    ssh -i ~/.ssh/avatar ubuntu@ci.om.dev.milkneko.com  \
    "ssh -i ~/.ssh/testing.pem ubuntu@10.0.0.${index}\
     'curl -s http://169.254.169.254/latest/meta-data/public-ipv4'" >> hosts
     echo ' ansible_ssh_private_key_file=~/.ssh/testing.pem' >> hosts
done

sudo rm -f /etc/ansible/hosts
sudo mv hosts /etc/ansible/

ansible servers -m raw -a "sudo apt install -y python"
