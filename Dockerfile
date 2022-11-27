FROM archlinux:latest

# Let's get the basic stuff out of the way
RUN pacman -Syu base-devel --noconfirm

# Python2
RUN pacman -S git python python-pip python-setuptools --noconfirm

# For ardupilot communication using TCP
RUN pip install wheel
RUN pip install pymavlink mavproxy

# Not needed to compile, but required for the map and GUI to work
RUN sudo pacman -S gcc procps-ng xterm wget tk python-wxpython --noconfirm
RUN sudo pacman -S python-numpy --noconfirm
RUN sudo pip install opencv-python
# fonts-freefont-ttf libfreetype6-dev libpng16-16 libportmidi-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev libsdl1.2-dev
# Create a user
RUN useradd -m akl

# Give passwordless sudo access
RUN echo "akl ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# From this point, the container runs as the `akl` user is logged in
USER akl


WORKDIR /home/akl

# From now on, following the official guide: https://github.com/ArduPilot/ardupilot/blob/master/BUILD.md
RUN git clone --recursive https://github.com/ArduPilot/ardupilot.git --depth 1
WORKDIR /home/akl/ardupilot

RUN ./waf configure
RUN ./waf copter
RUN ./waf plane

FROM archlinux:latest

RUN pacman -Syu gcc procps-ng git python python-pip python-setuptools --noconfirm

# Not needed to compile, but required for the map and GUI to work python-wxtools
RUN pacman -S xterm wget tk python-wxpython --noconfirm
RUN pacman -S python-numpy --noconfirm
RUN pip install opencv-python

# For ardupilot communication using TCP
# wheel needs to be installed before pymavlink
RUN pip install wheel
RUN pip install pymavlink mavproxy

RUN useradd -m akl
RUN mkdir /home/akl/ardupilot

COPY --from=0 /home/akl/ardupilot /home/akl/ardupilot

USER akl
WORKDIR /home/akl/ardupilot/Tools/autotest

# Custom AKL locations
RUN echo "Legnica=51.18268,16.17713,113,80" >> locations.txt

# Disable pre-arm checks, I don't care
# https://ardupilot.org/copter/docs/common-prearm-safety-checks.html
RUN echo "ARMING_CHECK    0" >> default_params/plane.parm
RUN echo "ARMING_CHECK    0" >> default_params/copter.parm
