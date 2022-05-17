#!/usr/bin/env bash
sudo apt-get update

sudo apt-get -y install git software-properties-common;
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Run Ansible playbook

cat <<"EOF" > /home/ubuntu/ghost.yml
${ansible_ghost}
EOF

sudo ansible-playbook /tmp/terraform-ansible-nginx/ghost.yml