FROM ubuntu:latest AS step-compilation

RUN apt update
RUN apt install -y git python3 python3-pip g++

RUN git clone --recursive https://github.com/ArduPilot/ardupilot.git --depth 1
WORKDIR /ardupilot

RUN pip install empy pexpect future

RUN python3 ./waf configure
RUN python3 ./waf copter
RUN python3 ./waf plane



#FROM ubuntu:latest AS step-run
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y python3 python3-pip procps python3-wxgtk4.0

RUN pip3 install pexpect matplotlib opencv-python
RUN pip3 install mavproxy pymavlink

WORKDIR /ardupilot/Tools/autotest

# Custom AKL locations
RUN echo "Legnica=51.18268,16.17713,113,80" >> locations.txt

# Disable pre-arm checks, I don't care
# https://ardupilot.org/copter/docs/common-prearm-safety-checks.html
RUN echo "ARMING_CHECK    0" >> default_params/plane.parm
RUN echo "ARMING_CHECK    0" >> default_params/copter.parm

