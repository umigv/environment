# UMARV Environment

This repository will help you get the UMARV environment set up on your computer so you can work with ROS and our software stack.

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Git](https://git-scm.com/) (preinstalled on most Linux distros)
- ~50 GB of free disk space
- Windows Users:
  - [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
    - Be sure to install Ubuntu as your distribution (this is the default behavior when running `wsl --install`)
    - NOTE: Must be on **Windows 10 Build 19044+ or Windows 11** to use GUI apps
    - Even if you have WSL already, you should run `wsl --update` just to make sure you have the latest GUI features
  - [Windows Terminal](https://learn.microsoft.com/en-us/windows/terminal/install)
    - Highly recommended but not required—can use any terminal emulator
- Mac Users:
  - [XQuartz](https://www.xquartz.org/)

## Setup

First, clone this repository into your Linux/Mac environment with the following command:

```sh
git clone https://github.com/umigv/environment.git
```

Run Docker Desktop and proceed through the initial installation, then open a terminal, navigate to this repository (e.g. `cd ~/environment`, change depending on where you clone it), and run the following commands:

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

You can add a function to your `.bashrc` or `.zshrc` file as follows to simplify running the environment (make sure to fill in the placeholders and remove the brackets!):

```sh
# ROS 2:
function ros2 {
  CYAN='\033[0;36m'
  NC='\033[0m'
  if [ -n "$(docker ps -f "name=umarv-ros2" -f "status=running" -q)" ]; then
    docker exec -it umarv-ros2 bash
  else
    echo -e "${CYAN}Open a new tab and run ros2 again${NC}"
    cd [path to environment]/ros2/[windows/mac] # replace first [] with correct path to your environment, e.g. ~/arv/environment and second with your OS
    docker compose up
  fi
}

# ROS 1:
function ros1 {
  CYAN='\033[0;36m'
  NC='\033[0m'
  if [ -n "$(docker ps -f "name=umarv-ros1" -f "status=running" -q)" ]; then
    docker exec -it umarv-ros1 bash
  else
    echo -e "${CYAN}Open a new tab and run ros1 again${NC}"
    cd [path to environment]/ros1/[windows/mac] # replace first [] with correct path to your environment, e.g. ~/arv/environment and second with your OS
    docker compose up
  fi
}
```

Then just run `ros2` or `ros1` to launch the environment.

If you need both ROS 1 and ROS 2, just follow the steps again but `cd` into the other directory.

## Preconfigured Scripts

Run `rosup` inside your container to automatically install the dependencies for your workspace using `rosdep`.

Run `rossrc` inside your container to automatically source your workspace's setup script.

## VSCode Setup

To use VSCode nicely with the ROS container:

- Start your ROS container
- Open VSCode and install the Dev Containers extension if you don't have it already
- Open the command pallete (ctrl-shift-p on Windows, cmd-shift-p on Mac), choose `Dev Containers: Attach to Running Container`, and choose your ROS container
  - VSCode should open and in the bottom left corner it should say `Container: ros-humble-desktop-full (umarv-ros-2)` or an equivalent for ROS 1
- Install the ROS VSCode extension in the container
- Open your `ws` folder, then open the VSCode settings (UI) and switch to the Workspace tab in settings
  - Search for `ROS`
  - For `Ros: Distro`, enter `humble` for ROS 2 or `noetic` for ROS 1
  - For `Ros: Ros Setup Script`, enter `install/setup.bash`
  - Search for `Terminal › Integrated › Default Profile: Linux` and change the setting to `bash`
- After adding packages to `ws/src`, run `colcon build`

Your VSCode setup should now work completely with correct syntax highlighting! You should do all of your ROS work in this VSCode instance. You can reopen the instance at any time by opening VSCode and clicking `File > Open Recent > ~/ws [Container: ros-humble-desktop-full (umarv-ros-2)]`. Make sure your container is running first!

## Getting GUI apps to work

### Windows

For most applications, should just work as long as you have all the prerequisites. Run your environment as normal and try opening a GUI app (e.g. `rqt_graph`).

#### Windows Troubleshooting

- If you're having trouble running `gazebo` or `ign gazebo` with ROS 2, you can uncomment line 16 in `ros2/windows/docker-compose.yml` which sets the environment variable `LIBGL_ALWAYS_SOFTWARE` to 1, disabling hardware acceleration

### Mac

- Start XQuartz
- In the menu bar, click `XQuartz` > `Settings`
- In the window that opens, click `Security`, then check the box that says `Allow connections from network clients`
- Restart your computer
- Run all the following in the **same terminal window**:
  - Get your IP with `export IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`
    - It is recommended that you add this command to your `.zshrc` file with `echo -e "export IP=\$(ifconfig en0 | grep inet | awk '\$1==\"inet\" {print \$2}')" >> ~/.zshrc` since your IP will change anytime your network changes
  - Allow incoming connections from your ip with `xhost + $IP`
  - Run `docker compose down` to ensure that any preexisting containers are destroyed
  - Run your environment as normal (starting from `docker compose up`) and try opening a GUI app (e.g. `rqt_graph`)
  - Anytime your network changes, make sure to stop your container, update the IP environment variable (preferrably by just opening a new shell with the above command in your `.zshrc`) and restart the container with the `ros1`/`ros2` shortcut functions or by running `docker conpose up` from the correct environment folder

#### Mac Troubleshooting

- If it says you cannot connect to the X server, make sure you went through all the steps properly **in the same terminal window** and make sure you ran `xhost + $IP` with the proper value of `IP` (you can check this with `echo $IP`). If you still have an issue, you may need to change the display number in `docker-compose.yml`. Run `ps -ef | grep "Xquartz :\d" | grep -v xinit | awk '{ print $9; }'` and you should get an output like `:[number]`. Open `mac/docker-compose.yml` and change the line `DISPLAY: ${IP}:0` to `DISPLAY: ${IP}:[number]`. Then, run everything again and see if it works.

## USB Devices

To connect a USB device to a Windows device:

- Follow [these instructions](https://learn.microsoft.com/en-us/windows/wsl/connect-usb) to connect your device to WSL
- Run `dmesg | grep usb` and look for a line similar to `[ 1491.421543] usb 1-1: [device] now attached to [location]` (location may look something like `ttyUSB0`)
- Make sure there is a device entry for your device (e.g. `- /dev/ttyUSB0:/dev/ttyUSB0` under `devices:`) in `ros[1 or 2]/windows/docker-compose.yml` in your environment repo, then restart ROS
- In your ROS container, run `sudo chmod ugo+rw /dev/[location]` to allow access to the device

If you are on Mac, you probably won't be able to easily add a USB device to your Docker container. Instead, try to use one of the team devices like the laptop in order to test your code once you're ready for it
