#!/bin/bash

## Bash script for installation of some useful additional development tools that are not part of the core PX4 build toochain. 
##
## Installs:
## - axel
##     - Use axel for multithreaded downloads instead of wget.
## - QGround Control Software
## - Visual Studio Code
##     - It is recommended to download from the address of the baidunetdisk, the download speed from the official website in China is very slow.
##
## This bash script is aimed at users of work hosts in China, using mirror links to improve installation speed.
## If your work host is elsewhere, just use the official script.
## 
## Written by @hewittzgh in Feb 2021

# Step1 : Intall the current stable release of QGround Control Software 
## Before installing QGC for the first time
### Verify that $USER has been added to group dialout
verify_usermod=$(cat /etc/group | grep dialout | grep $USER)
check_usermod=$?
if [[ $check_usermod -eq 1 ]];then
  echo "Add $USER to the group dialout ...."
  sudo usermod -a -G dialout $USER
elif [[ $check_usermod -eq 0 ]];then
  echo "The $USER has been added to the dialout group."
fi
sudo apt-get remove modemmanager -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
### Activte the changes to group
#newgrp dialout
### Download the current stable release of QGC
#### To improve the download speed, use axel for multithreaded downloads
sudo apt install axel
echo "Downloaing the QGC to ~/Install_PX4/QGC by axel ...."
QGC_path="/home/$USER/Install_PX4/QGC"
if [ -d $QGC_path ];then
  sudo rm -rf $QGC_path
  echo "Delete ${QGC_path} old folder."
else
  mkdir ${QGC_path}
  echo "Create ${QGC_path} new folder."
fi
axel -a -n 30 -o ${QGC_path} https://s3-us-west-2.amazonaws.com/qgroundcontrol/latest/QGroundControl.AppImage
if [ $? -ne 0 ];then echo "Error downloading 'QGC'. Sorry but I cannot proceed further :("; exit 1; fi
cd $QGC_path
chmod +x ./QGroundControl.AppImage
echo "Extract the AppImage to ./squashfs-root ...."
./QGroundControl.AppImage --appimage-extract
echo "Start the AppImage by run ./squashfs-root/AppRun"
## The configuration file of QGC is in QGroundControl under /home/$USER/Documents/
## If you want to delete them, please delete the /home/$USER/Documents/QGroundControl/
./squashfs-root/AppRun
