#!/bin/bash

## Bash script for initialization of the system environment based on a Docker image named "dorowu/ubuntu-desktop-lxde-vnc:bionic-lxqt"
##
## Runs:
## - modify the apt sources to improve install speed
## - use pip mirrors to improve install speed
## - install common tools, such as vim, gedit, python-pip, python3-pip, wget
## - wget the baidunetdisk .deb install package
##
## Precondition:
## - This bash script is aimed at users of work hosts in China, using mirror links to improve installation speed.
##   If your work host is elsewhere, don't use the script.
## - See my docs for detailed usage: https://hewittzgh.github.io/UAV-Simulation-Environment
##
## Written by @hewittzgh in Feb 2021

# Step1 : modify the apt sources to improve install speed
echo "Step1 : modify the apt sources to improve install speed ...."
apt_sources="/etc/apt"
sudo cp ${apt_sources}/sources.list ${apt_sources}/sources.list.backup
sudo sh -c 'echo "deb https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse" > ${apt_sources}/sources.list'
sudo sh -c 'echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-security main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo sh -c 'echo "deb-src https://mirrors.ustc.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse" >> ${apt_sources}/sources.list'
sudo apt update -y
sudo apt upgrade -y

# Step2 : use pip mirrors to improve install speed
echo "Step2 : use pip mirrors to improve install speed(sudo -H) ...."
sudo -H pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Step3 : install common tools, such as vim, gedit, python-pip, python3-pip, wget
echo "Step3 : install common tools, such as vim, gedit, python-pip, python3-pip, wget ...."
sudo apt-get install vim gedit python-pip python3-pip wget -y

# Step4: wget the baidunetdisk .deb install package
cd /home/$USER/Install_PX4
echo "Step4: wget the baidunetdisk .deb install package ...."
#wget https://issuecdn.baidupcs.com/issue/netdisk/LinuxGuanjia/3.5.0/baidunetdisk_3.5.0_amd64.deb
