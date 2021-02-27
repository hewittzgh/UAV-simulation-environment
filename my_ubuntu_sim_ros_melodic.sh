#!/bin/bash

## Bash script for setting up ROS Melodic (with Gazebo 9) development environment for PX4 on Ubuntu LTS (18.04). 
## It installs the common dependencies for all targets (including Qt Creator)
##
## Installs:
## - Common dependencies libraries and tools as defined in `ubuntu_sim_common_deps.sh`
## - ROS Melodic (including Gazebo9)
## - MAVLink/MAVROS
## - Upgrade Gazebo9(9 series)
##
## This bash script is aimed at users of work hosts in China, using mirror links to improve installation speed.
## If your work host is elsewhere, just use the official script.
## 
## Written by @hewittzgh in Feb 2021

# Step1: check whether the system version meets the requirements:Ubuntu 18.04 and latest and init some settings
echo "Step1: check whether the system version meets the requirements:Ubuntu 18.04 and latest and init some settings ...."
if [[ $(lsb_release -sc) == *"xenial"* ]];then
  echo "OS version detected as $(lsb_release -sc) (16.04)."
  echo "ROS Melodic requires at least Ubuntu 18.04."
  echo "Exiting ...."
  return 1;
else
  echo "Your system version meets the requirements."
  echo "Now init the environment ...."
  ## If you have run the command: rosdep init before, you need to delete the last file.
  rosdep_init_oldfile="/etc/ros/rosdep/sources.list.d/20-default.list"
  if [ -f $rosdep_init_oldfile ];then
    sudo rm $rosdep_init_oldfile
    echo "Delete ${rosdep_init_oldfile} old file."
  fi
  ## If you already have a catkin_ws folder, delete it first.
  catkin_ws_oldfolder="/home/$USER/catkin_ws"
  if [ -d $catkin_ws_oldfolder ];then
    sudo rm -rf $catkin_ws_oldfolder
    echo "Delete ${catkin_ws_oldfolder} old folder."
  fi
  ## Use pip mirrors(see in system_environment_initialization.sh) and specify the timeout to avoid installation failure due to network problems
  sudo -H pip config set global.timeout 60000
  echo "Specify the timeout to pip to avoid installation failure(sudo -H)."
fi

# Step2 : Downloading dependent script 'ubuntu_sim_common_deps.sh' and automatically download the associated 
echo "Step2 : Downloading dependent script 'ubuntu_sim_common_deps.sh' and automatically download the associated ...."
echo "Downloading dependent script 'ubuntu_sim_common_deps.sh'"
# Source the ubuntu_sim_common_deps.sh script directly from github
common_deps=$(wget https://raw.githubusercontent.com/PX4/Devguide/master/build_scripts/ubuntu_sim_common_deps.sh -O -)
wget_return_code=$?
# If there was an error downloading the dependent script, we must warn the user and exit at this point.
if [[ $wget_return_code -ne 0 ]]; then echo "Error downloading 'ubuntu_sim_common_deps.sh'. Sorry but I cannot proceed further :("; exit 1; fi
# Otherwise source the downloaded script.
. <(echo "${common_deps}")


# Step3 : Download ROS Melodic/Gazebo9/MAVLink/MAVROS
echo "Step3 : Download ROS Melodic/Gazebo9/MAVLink/MAVROS ...."
## Download Gazebo simulator dependencies
sudo apt-get install protobuf-compiler libeigen3-dev libopencv-dev -y
## Setup your sources.list: Use the USTC mirrors
sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
## Setup your keys
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
## For keyserver connection problems substitute hkp://pgp.mit.edu:80 or hkp://keyserver.ubuntu.com:80 above.
sudo apt-get update
## Get ROS Melodic/Gazebo
sudo apt install ros-melodic-desktop-full -y
## Setup environment variables
rossource="source /opt/ros/melodic/setup.bash"
if grep -Fxq "$rossource" ~/.bashrc; then echo ROS setup.bash already in .bashrc;
else echo "$rossource" >> ~/.bashrc; fi
eval $rossource
## Download dependencies for building packages
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential -y

## Initialize rosdep
### If you have run the init code before, you need to delete the last file.(Moved to the step 1)
# oldfile="/etc/ros/rosdep/sources.list.d/20-default.list"
# if [ -f $oldfile ];
# then
#   sudo rm $oldfile
#   echo "Delete ${oldfile} old file."
# fi

### Automatically modify "DOWNLOAD_TIMEOUT = 15.0" to "DOWNLOAD_TIMEOUT = 150.0" 
### in "/usr/lib/python2.7/dist-packages/rosdep2/" "sources_list.py", "gbpdistro_support.py" and "rep3.py".
rosdep_root="/usr/lib/python2.7/dist-packages/rosdep2/"
sudo sed -i "s/DOWNLOAD_TIMEOUT = 15.0/DOWNLOAD_TIMEOUT = 150.0/g" ${rosdep_root}sources_list.py
sudo sed -i "s/DOWNLOAD_TIMEOUT = 15.0/DOWNLOAD_TIMEOUT = 150.0/g" ${rosdep_root}gbpdistro_support.py
sudo sed -i "s/DOWNLOAD_TIMEOUT = 15.0/DOWNLOAD_TIMEOUT = 150.0/g" ${rosdep_root}rep3.py
echo "Modify the DOWNLOAD_TIMEOUT value of rosdep."

### rosdep init and rosdep update
sudo rosdep init
#### If the update operate timed out, you need to change "DOWNLOAD_TIMEOUT = 15.0" to "DOWNLOAD_TIMEOUT = 150.0" 
#### in "/usr/lib/python2.7/dist-packages/rosdep2/" "sources_list.py", "gbpdistro_support.py" and "rep3.py".The 
#### script has realized the function of automatic modification.
rosdep update

# MAVROS: https://dev.px4.io/en/ros/mavros_installation.html
## Install dependencies
sudo apt-get install python-catkin-tools python-rosinstall-generator -y

## Create catkin workspace

### If you already have a catkin_ws folder, delete it first.(Moved to the step 1)
# old_catkin_ws="/home/$USER/catkin_ws"
# if [ -d $old_catkin_ws ];
# then
#   sudo rm -rf $old_catkin_ws
#   echo "Delete ${old_catkin_ws} old folder."
# fi

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin init
wstool init src

## If there is a socket timeout error, you can uncomment the following code block to perfect the error cauesd by network problems.
## But it may not work on your computer, the key is to ensure the smooth flow of the network.
# +++++
rosinstall_root="/usr/lib/python2.7/dist-packages/rosdistro/"
sudo sed -i "s/timeout=10/timeout=100/g" ${rosinstall_root}loader.py
echo "Extend rosinstall socket timout 10 to 100."
# +++++

## Install MAVLink
###we use the Kinetic reference for all ROS distros as it's not distro-specific and up to date
rosinstall_generator --rosdistro kinetic mavlink | tee /tmp/mavros.rosinstall

## Build MAVROS
### Get source (upstream - released)
rosinstall_generator --upstream mavros | tee -a /tmp/mavros.rosinstall

### Setup workspace & install deps
echo "Setup workspace and install deps"
wstool merge -t src /tmp/mavros.rosinstall
wstool update -t src
if ! rosdep install --from-paths src --ignore-src -y; then
    # (Use echo to trim leading/trailing whitespaces from the unsupported OS name
    unsupported_os=$(echo $(rosdep db 2>&1| grep Unsupported | awk -F: '{print $2}'))
    rosdep install --from-paths src --ignore-src --rosdistro melodic -y --os ubuntu:bionic
fi

if [[ ! -z $unsupported_os ]]; then
    >&2 echo -e "\033[31mYour OS ($unsupported_os) is unsupported. Assumed an Ubuntu 18.04 installation,"
    >&2 echo -e "and continued with the installation, but if things are not working as"
    >&2 echo -e "expected you have been warned."
fi

#Install geographiclib
## sudo apt install geographiclib -y
sudo apt-get install libgeographic-dev
sudo apt-get install geographiclib-tools -y
echo "Downloading dependent script 'install_geographiclib_datasets.sh'"
## Source the install_geographiclib_datasets.sh script directly from github
## Due to special reasons in China, the download speed of foreign data is very slow, you can download it manually and place the corresponding file under "/usr/share/GeographicLib/"
install_geo=$(wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh -O -)
wget_return_code=$?
## If there was an error downloading the dependent script, we must warn the user and exit at this point.
if [[ $wget_return_code -ne 0 ]]; then echo "Error downloading 'install_geographiclib_datasets.sh'. Sorry but I cannot proceed further :("; exit 1; fi
## Otherwise source the downloaded script.
sudo bash -c "$install_geo"

## Build!
catkin build
## Re-source environment to reflect new packages/build environment
catkin_ws_source="source ~/catkin_ws/devel/setup.bash"
if grep -Fxq "$catkin_ws_source" ~/.bashrc; then echo ROS catkin_ws setup.bash already in .bashrc; 
else echo "$catkin_ws_source" >> ~/.bashrc; fi
eval $catkin_ws_source

# Step4 : Upgrade Gazebo9 to the latest version(9 series)
echo "Upgrade Gazebo9 to the latest version(9 series) ...."
## Setup your computer to accept software from packages.osrfoundation.org.
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
cat /etc/apt/sources.list.d/gazebo-stable.list | grep osrfoundation.org
if [ $? -ne 0 ];then
  echo "The packages sources has not been added to the apt sources, please exit the script and operate it manually."
  return 1;
else
  echo "The packages sources has been added to the apt sources."
fi
## Setup keys 
gazebo_key=$(wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -)
setup_gazebo_key=$?
# If there was an error downloading the key, we must warn the user and exit at this point.
if [[ $setup_gazebo_key -ne 0 ]]; then echo "Error downloading 'gazebo.key'. Sorry but I cannot proceed further :("; exit 1; fi

## Install Gazebo latest version
### First update the debian database
sudo apt-get update
echo "Hint: make sure the apt-get update process ends without any errors, the console output ends in Done."
echo "Otherwise, it is recommended to exit the process and recheck the apt sources manually."
read -r -p "Continue?[Y/n]" input
case $input in 
    [yY][eE][sS]|[yY])
        echo "continue ...."
        ;;
    [nN][oO]|[nN])
        echo "exit the script process ...."
        exit 1
        ;;
    *)
        echo "Invalid input, exit the script process ...."
        exit 1
        ;;
esac
### Hint: make sure the apt-get update process ends without any errors, the console output ends in `Done`.
### Next install gazebo-9 by:
sudo apt-get install gazebo9
### For developers that work on top of Gazebo, one extra package
sudo apt-get install libgazebo9-dev
sudo apt-get upgrade
### Test the gazebo
gazebo
