FROM alpine:latest AS stage-build

RUN apk update
RUN apk add git g++ rsync python3 py3-pip xterm

RUN git clone --recursive https://github.com/ArduPilot/ardupilot.git --depth 1
WORKDIR /ardupilot

RUN pip install empy pexpect future

RUN python3 ./waf configure
RUN python3 ./waf copter
RUN python3 ./waf plane
