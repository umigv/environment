FROM osrf/ros:noetic-desktop-full

ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib

RUN apt-get update && apt-get install -y software-properties-common curl
RUN add-apt-repository ppa:kisak/kisak-mesa -y

RUN apt-get upgrade -y && apt-get install -y \
    ros-noetic-ros-ign \ 
    vainfo \ 
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m umarv && echo "umarv:umarv123" | chpasswd && adduser umarv sudo
USER umarv
WORKDIR /home/umarv

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc