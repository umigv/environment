FROM osrf/ros:humble-desktop-full

ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/wsl/lib

RUN useradd -m umarv && echo "umarv:umarv123" | chpasswd && adduser umarv sudo
USER umarv
WORKDIR /home/umarv
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc