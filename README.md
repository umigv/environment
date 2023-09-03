# UMARV Environment

This repository will help you get the UMARV environment set up on your computer so you can work with ROS and our software stack.

## Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- ~50 GB of free disk space
- Windows Users:
    - [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
        - Be sure to install Ubuntu as your distribution (this is the default behavior when running `wsl --install`)
        - NOTE: Must be on **Windows 10 Build 19044+ or Windows 11** to use GUI apps
    - [Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/install)
        - Highly recommended but not required—can use any terminal emulator
- Mac Users:
    - [XQuartz](https://www.xquartz.org/)

## Setup
First, clone this repository with the following command:
```sh
git clone https://github.com/umigv/environment.git
```
Run Docker Desktop and proceed through the initial installation, then open a terminal, navigate to this repository, and run the following commands:
```sh
# if you want to use ROS 2 (recommended if you don't specifically need ROS 1):
cd ros2
# else if you want to use ROS 1 (only if your subteam requires it):
cd ros1

# if using windows (make sure you run these commands from a WSL shell):
cd windows
# else if using mac:
cd mac

docker compose up

# open a new terminal, then run one of the following:
# if using ROS 2:
docker exec -it umarv-ros2 bash
# else if using ROS 1:
docker exec -it umarv-ros1 bash
```
The initial container build may take a while. After running the second command, you should see a prompt that looks like this:

```sh
# ROS 2:
umarv@umarv-ros2:~$

# ROS 1:
umarv@umarv-ros1:~$
```
Congratulations! Your environment is now set up. You should be logged in as user `umarv` with password `umarv123`. Remember that if you ever need to run commands as root in the future. If you ever need to open a new terminal and connect back to this instance, just run this command again in a new terminal:

```sh
# if using ROS 2:
docker exec -it umarv-ros2 bash
# else if using ROS 1:
docker exec -it umarv-ros1 bash
```
If you need both ROS 1 and ROS 2, just follow the steps again but `cd` into the other directory.

## Getting GUI apps to work

### Windows
For most applications, should just work as long as you have all the prerequisites. Run your environment as normal and try opening a GUI app (e.g. `rqt_graph`).

#### Exceptions:
- To run `ign gazebo`, you must append `LIBGL_ALWAYS_SOFTWARE=1` to your commands (e.g. `LIBGL_ALWAYS_SOFTWARE=1 ign gazebo`)

### Mac
- Start XQuartz
- In the menu bar, click `XQuartz` > `Settings`
- In the window that opens, click `Security`, then check the box that says `Allow connections from network clients`
- Restart XQuartz
- Get your IP with `export IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`
    - It is recommended that you add this command to your `.zshrc` file with `echo "export IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')" >> ~/.zshrc`
- Allow incoming connections from your ip with `xhost + $IP`
- Run `docker compose down` to ensure that any preexisting containers are destroyed
- Run your environment as normal (starting from `docker compose up`) and try opening a GUI app (e.g. `rqt_graph`)

#### Troubleshooting
- If it says you cannot connect to the X server, make sure you went through all the steps properly and make sure you ran `xhost + $IP` with the proper value of `IP` (you can check this with `echo $IP`). If you still have an issue, you may need to change the display number in `docker-compose.yml`. Run `ps -ef | grep "Xquartz :\d" | grep -v xinit | awk '{ print $9; }'` and you should get an output like `:[number]`. Open `mac/docker-compose.yml` and change the line `DISPLAY: ${IP}:0` to `DISPLAY: ${IP}:[number]`. Then, run everything again and see if it works.
