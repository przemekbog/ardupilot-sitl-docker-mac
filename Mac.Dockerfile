FROM ubuntu:latest AS step-compilation

RUN apt update
RUN apt install -y git g++ gcc rsync python3 python3-pip xterm

# Create a user
RUN useradd -m akl
# Give passwordless sudo access
RUN echo "akl ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# From this point, the container runs as the `akl` user is logged in

WORKDIR /home/akl

RUN git clone --recursive https://github.com/ArduPilot/ardupilot.git --depth 1
WORKDIR /home/akl/ardupilot

RUN pip install empy pexpect future

RUN python3 ./waf configure
RUN python3 ./waf copter
RUN python3 ./waf plane

#
#   RUNNING
#

#FROM ubuntu:latest AS step-run

RUN apt update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -y xterm wget tk python3 python3-pip procps python3-wxgtk4.0
#RUN apt-get install -y python3 python3-pip python-is-python3

RUN pip3 install attrdict3
RUN pip3 install pexpect setuptools matplotlib numpy opencv-python
RUN pip3 install wheel
RUN pip3 install mavproxy pymavlink

# RUN apt-get install -y python-is-python3

#COPY --from=step-compilation /ardupilot /ardupilot

#RUN useradd -m akl
#RUN chown akl /ardupilot/Tools/environment_install/install-prereqs-ubuntu.sh
#USER akl

#ARG USER_NAME=akl
#ARG USER_UID=1000
#ARG USER_GID=1000
#RUN groupadd ${USER_NAME} --gid ${USER_GID}\
#    && useradd -l -m ${USER_NAME} -u ${USER_UID} -g ${USER_GID} -s /bin/bash

#USER akl
#ENV SKIP_AP_EXT_ENV=1 SKIP_AP_GRAPHIC_ENV=1 SKIP_AP_COV_ENV=1 SKIP_AP_GIT_CHECK=1
#RUN /ardupilot/Tools/environment_install/install-prereqs-ubuntu.sh -y

RUN passwd -d root

#RUN chown akl /home/akl/ardupilot


WORKDIR /home/akl/ardupilot/Tools/autotest

# GUI
#RUN pip install attrdict
#RUN pip install wxpython
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tk

#ENTRYPOINT ['python3', './sim_vehicle.py']

# apt-get install -y git g++ rsync python3 python3-pip


# Custom AKL locations
#RUN echo "Legnica=51.18268,16.17713,113,80" >> locations.txt
#
## Disable pre-arm checks, I don't care
## https://ardupilot.org/copter/docs/common-prearm-safety-checks.html
#RUN echo "ARMING_CHECK    0" >> default_params/plane.parm
#RUN echo "ARMING_CHECK    0" >> default_params/copter.parm

# Custom AKL locations
RUN echo "Legnica=51.18268,16.17713,113,80" >> locations.txt

# Disable pre-arm checks, I don't care
# https://ardupilot.org/copter/docs/common-prearm-safety-checks.html
RUN echo "ARMING_CHECK    0" >> default_params/plane.parm
RUN echo "ARMING_CHECK    0" >> default_params/copter.parm
USER akl

