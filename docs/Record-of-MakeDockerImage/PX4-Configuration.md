---
sort: 2
---

# Install PX4 Autopilot v1.11.0

```tip
This Guide only explains teh installation in the **Ubuntu18.04LTS** docker basic image.
```

## Toolchain Installation
Firstly, let's install the core PX4 build toolchain.
```note
Bash script are provided to help make it easy to install development environment:  
[ubuntu_sim_ros_melodic.sh](https://raw.githubusercontent.com/PX4/PX4-Devguide/v1.11/build_scripts/ubuntu_sim_ros_melodic.sh): Intalls ROS/Gazebo (Melodic) and PX4 on Ubuntu18.04 LTS.
```

To install the development toolchain:

- Download the script in a bash shell:
```shell
wget https://raw.githubusercontent.com/PX4/PX4-Devguide/v1.11/build_scripts/ubuntu_sim_ros_melodic.sh
```
- Run the script:
```shell
bash ubuntu_sim_ros_melodic.sh
```
You may need to acknowledge some prompts as the script progresses

    ```tip
    If your work host is in China, it is recommended that you download my modified script to install.
    - Install the script:
    `wget `
    - Run the script:
    `bash my_ubuntu_sim_ros_melodic.sh`
    ```

    ```note
    - ROS Melodic is installed with Gazebo9 by default.  
    - Your catkin (ROS build system) workspace is created at `~/catkin_ws/`.  
    - The script uses instructions from the ROS Wiki "Melodic" [Ubuntu Page](https://wiki.ros.org/melodic/Installation/Ubuntu)  
    ```
    
- Upgrade Gazebo to the latest version(9 series)
```note
The version of the Gazebo9 comes with ROS Melodic is too low, it is recommended to upgrade it to the latest version(9 series). The upgrade official tutorial link is [here](http://gazebosim.org/tutorials?cat=install&tut=install_ubuntu&ver=9.0).
```
    - Setup your computer to accept software from packages.osrfoundation.org.
    ```shell
    $ sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
    ```
    ```note
    You can check to see if the file was written correctly. For example, in Ubuntu18.04LTS, you can type: `$ cat /etc/apt/sources.list.d/gazebo-stable.list` and you will see `deb http://packages.osrfoundation.org/gazebo/ubuntu-stable bionic main`.
    ```
    - Setup keys
    ```shell
    $ wget https://packages.osrfoundation.org/gazebo.key -0 - | sudo apt-key add -
    ```
    - Install Gazebo
    ```shell
    # First update the debian database
    $ sudo apt-get update
    # Hint: make sure the apt-get update process ends without any errors, the console output ends in `Done`.
    # Next install gazebo-9 by:
    $ sudo apt-get install gazebo9
    # For developers that work on top of Gazebo, one extra package
    $ sudo apt-get install libgazebo9-dev
    $ sudo apt-get upgrade
    ```
    - Check your installation
    ```note
    The first time gazebo is executed requires the download of some models and it could take some time, please be patient.
    ```
    ```shell
    # Run the gazebo
    $ gazebo
    ```