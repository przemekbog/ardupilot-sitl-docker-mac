# What's this?
This repo contains basic scripts for running sitl with GUI on mac (MacOS Ventura 13.0).

[Ardupilot](http://ardupilot.org/) - open-source autopilot for unmanned vehicles (drones, planes, boats, you tell me)

[SITL](http://ardupilot.org/dev/docs/sitl-simulator-software-in-the-loop.html) - software in the loop - a simulator for ardupilot

SITL was a PITA to work with, when you have 0 experience with ardupilot, so I've made a docker image and a python helper
script to make the whole procedure a bit easier for newcomers.

## WARNING
This repo is for MacOS exclusively. I have no idea whether it will work on other OS'es.

## Prerequisites

### Programs
Before you try to run these scripts you'll need the following software:

| Software | What for        | Link                     |
|----------|-----------------|--------------------------|
| Docker   | Running SITL    | https://docs.docker.com/ |
| xQuartz  | Showing the GUI | https://www.xquartz.org/ |

You can install them from the official websites or (recomended) using [homebrew](https://brew.sh/).

### Steps
1. Install all required [programs](###programs)
2. Launch xQuartz
3. Go to the security tab and ensure "Allow connections from network clients" is checked.
4. Launch Docker

## Usage

### `sitl_mac.py` script

The script is documented, so I'll just post the output of `./sitl.py --help` here:

```
usage: sitl.py [-h] [-m] [-c] -v VEHICLE [-l LOCATION]

SITL Runner

optional arguments:
  -h, --help            show this help message and exit
  -m, --map             Show the map window
  -c, --console         Show the console window
  -v VEHICLE, --vehicle VEHICLE
                        Choose vehicle (ArduPlane or ArduCopter)
  -l LOCATION, --location LOCATION
                        Select location (Legnica by default)
```

### Manually, through `docker`

Just use docker-compose from [here](https://github.com/Wint3rmute/ardupilot-sitl-docker/blob/master/docker-compose.yml)


Or if you HAVE to use just docker, here's your long boi:

`docker run -it --net=host --env="DISPLAY=host.docker.internal:0" --volume="$HOME/.Xauthority:/home/akl/.Xauthority:rw" wnt3rmute/ardupilot-sitl ./sim_vehicle.py -L Ballarat --console --map -v ArduCopter -N`

# How this works

GUI works through sharing the `.Xauthority` file (see tutorials on how to use host's X from inside Docker. 
Wayland works through XWayland (last time that I checked).
