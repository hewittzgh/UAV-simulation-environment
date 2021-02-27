#!/bin/bash

## Bash script for One-Click Installaton of PX4 development environment and Recording the installation process
##
## Runs:
## - system_environment_initialization.sh
##     - modify the apt sources to improve install speed
##     - use pip mirrors to improve install speed
##     - install common tools, such as vim, gedit, python-pip, python3-pip, wget
##     - wget the baidunetdisk .deb install packages
## - my_ubuntu_sim_ros_melodic.sh
##     - Common dependencies libraries and tools as defined in `ubuntu_sim_common_deps.sh`
##     - ROS Melodic (including Gazebo9)
##     - MAVROS
##     - Upgrade Gazebo9(9 series)
## - not finish
##
## Precondition:
## - This bash script is aimed at users of work hosts in China, using mirror links to improve installation speed.
##   If your work host is elsewhere, just use the official script.
## - See my docs for detailed usage: https://hewittzgh.github.io/UAV-Simulation-Environment
##
## Written by @hewittzgh in Feb 2021

# Step1 : run system_environment_initialization.sh to setup the base system environment
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "run system_environment_initialization.sh to setup the base system environment ...."
bash ./system_environment_initialization.sh

# Step2 : run my_ubuntu_sim_ros_melodic.sh to setup the PX4 SITL development 
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "run my_ubuntu_sim_ros_melodic.sh to setup the PX4 SITL development ...."
bash ./my_ubuntu_sim_ros_melodic.sh
