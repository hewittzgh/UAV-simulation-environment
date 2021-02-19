---
sort: 2
---

# Install PX4 Autopilot v1.11.0

```tip
This Guide only explains the installation in the **Ubuntu18.04LTS** docker basic image.
```

## Toolchain Installation
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
```tip
You may need to acknowledge some prompts as the script progresses
```

```note
- ROS Melodic is installed with Gazebo9 by default.  
- Your catkin (ROS build system) workspace is created at `~/catkin_ws/`.  
- The script uses instructions from the ROS Wiki "Melodic" [Ubuntu Page](https://wiki.ros.org/melodic/Installation/Ubuntu)  
```