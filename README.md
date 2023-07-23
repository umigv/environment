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
# if using windows:
cd windows
# else if using mac:
cd mac

docker compose up
docker exec -it umarv-ros2 bash
```
The initial container build may take a while. After running the second command, you should see a prompt that looks like this:

```sh
umarv@umarv-ros2:~$
```
Congratulations! Your environment is now set up. You should be logged in as user `umarv` with password `umarv123`. Remember that if you ever need to run commands as root in the future. If you ever need to open a new terminal and connect back to this instance, just run this command again in a new terminal:

```sh
docker exec -it umarv-ros2 bash
```

## Getting GUI apps to work

### Windows
Should just work as long as you have all the prerequisites. Run your environment as normal and try opening a GUI app (e.g. `rqt_graph`).

### Mac
- Go to System Preferences > Security and check the option to allow connections from network clients
- Restart your computer
- Start XQuartz (either through Applications folder or with `open -a XQuartz`)
- Get your IP with `export IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`
- Allow incoming connections from your ip with `xhost + $IP`
- Run your environment as normal and try opening a GUI app (e.g. `rqt_graph`)