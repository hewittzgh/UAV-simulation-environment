#!/bin/bash

## Bash script for setting up Docker on Ubuntu LTS.
## - Install the Docker
## - Configure the Docker
## 
## My tutorial link: https://hewittzgh.github.io/My-Docker-Tutorial
## The official tutorial link: https://docs.docker.com
## 
## Warning:
## This script has only been tested on Ubuntu16.04LTS and latest versions,
## earlier versions may cause errors.
## 
## Written by @hewittzgh (gonghao Zhang) in Feb 2021

# Step1: Preparations Before Downloading
echo "=========================STEP1: PREPARATIONS BEFORE DOWNLOADING=========================="
## Check the system version
echo "Check your system version ...."
if [[ $(lsb_release -sc) = *"xenial"* ] -o [ $(lsb_release -sc) = *"bionic"* ] -o [ $(lsb_release -sc) = *"focal"* ]];then
  echo "Your system version meets the requirements."
else
  echo "Warning: Recommand to use Ubuntu16.04LTS and above."
  echo "If you insist on using the current version, this script may cause errors."
fi
## If you have ever downloaded an old version of Docker, you need to uninstall it first.
apt list --installed | grep docker
if [ $? -ne 0 ];then
  echo "You have never installed Docker."
else
  echo "You have ever installed an old version of Docker, now uninstall it ...."
  echo "Uninstall docker docker-engine docker.io containerd runc ...."
  sudo apt-get remove docker docker-engine docker.io containerd runc
  echo "Uninstall docker-ce docker-ce-cli containerd.io ...."
  sudo apt-get purge docker-ce docker-ce-cli containerd.io
  # If you don't want to delete the images, containers, and volumes you have used,
  # please comment the following shell code out and delete any edited configuration files manually.
  ######delete the images, containers, and volumes#####
  dockerfolder="/var/lib/docker"
  if [ -d $dockerfolder ];then
    echo "Delete ${dockerfolder} ...."
    sudo rm -rf $dockerfolder
  fi
  #####################################################
fi
echo "========================================================================================="

# Step2: Install Docker
echo "=========================STEP2: INSTALL DOCKER==========================================="
## Set up the repository Update the apt package index 
## and install packages to allow apt to use a repository over HTTPS. 
echo "Set up the repository Update the apt package index ...."
sudo apt-get update
echo "Install packages to allow apt to use a repository over HTTPS ...."
sudo apt-get install \
 apt-transport-https \
 ca-certificates \
 curl \
 gnupg-agent \
 software-properties-common
## Add Docker's official GPG key.
echo "Add Docker's official GPG key ...."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
## Verify that you now have the key with the fingerprint 
## 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88, 
## by searching for the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88 | grep 0EBFCD88
if [ $? -ne 0 ];then
  echo "ERROR: Verify failed!"
  echo "Please Add Docker's official GPG key manually."
  return 1;
else
  echo "Verify the GPG key successfully!"
fi
## Set up the stable repository
echo "Review system architecture ...."
if [[ $(arch) = *"x86_64"* ] -o [ $(arch) = *"amd64"* ]];then
  echo "Your system architecture is x86_64/amd64."
  echo "Set up the stable repository ...."
  sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
elif [[ $(arch) = *"armhf"* ]];then
  echo "Your system architecture is armhf."
  echo "Set up the stable repository ...."
  sudo add-apt-repository \
     "deb [arch=armhf] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
elif [[ $(arch) = *"arm64"* ]];then
  echo "Your system architecture is arm64."
  echo "Set up the stable repository ...."
  sudo add-apt-repository \
     "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
fi
## Install Docker Engine
### Update the apt package index, and install the latest version of Docker Engine and containerd by default.
### If you want to install a specific version of Docker Engine, please visit my tutorial.
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
## Verify that Docker Engine is installe correctly by running the hello-world image. 
echo "Verify that Docker Engine is installe correctly by running the hello-world image ...."
echo "If Docker is installed correctly, it will download a test image and run it in a container, print an informational message when the container runs and exit."
echo "If some error messages are output, please stop the script manually by [Ctrl+c]."
sudo docker run hello-world
echo "========================================================================================="

# Step3: Configure docker
echo "=========================STEP2: CONFIGURE DOCKER========================================="
## Manage Docker as a non-root user
echo "Manage Docker as a non-root user ...."
### Create the docker group
echo "Create the docker group ...."
sudo groupadd docker
### Add your user to the docker group
echo "Add your user to the docker group ...."
sudo usermod -aG docker $USER
### Activate the changes to groups
echo "Activate the changes to groups ...."
newgrp docker
### Verify that you can run docker commands without sudo
echo "Verify that you can run docker commands without sudo ...."
docker run hello-world
echo "If Docker is configured correctly, it will download a test image and run it in a container, print an informational message when the container runs and exit."
echo "If some error messages are output, please stop the script manually by [Ctrl+c]."

## Configure Docker to start on boot
### On Debian and Ubuntu, the Docker service is configured to start on boot by default.
echo "========================================================================================="