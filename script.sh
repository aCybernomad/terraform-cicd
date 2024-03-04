#!/bin/bash

# Update the package lists
sudo apt-get update

# Install pip and Ansible
sudo apt-get install -y python3-pip
sudo pip3 install ansible

# Install Apache
sudo apt-get install -y apache2

# Start and enable Apache
sudo systemctl restart apache2

#ansible pull
sudo /usr/local/bin/ansible-pull -U https://github.com/aCybernomad/ansible_cicd -d /home/ansible-pull playbook.yml


# Add index.html with text "hello dennis"
echo "hello dennis" | sudo tee /var/www/html/index.html