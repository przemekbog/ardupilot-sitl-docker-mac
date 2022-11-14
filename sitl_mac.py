#!/usr/bin/python3

import argparse
import os
from subprocess import check_output

DEFAULT_LOCATION = 'Legnica'
DOCKER_HOST_NAME = 'host.docker.internal'

class SitlDockerHelper:
    def __init__(self, vehicle, location=DEFAULT_LOCATION, map_on=False, console_on=False, run_in_background=False, pre_arm_checks=True, out_ip=None):
        self.vehicle = vehicle
        self.location = location
        self.map_on = map_on
        self.console_on = console_on
        self.run_in_background = run_in_background
        self.pre_arm_checks = pre_arm_checks
        self.out_ip = out_ip

    def run(self):
        os.system('open -a xquartz')
        os.system('DISPLAY=:0 xhost + localhost')

        # Default arguments, always used
        docker_args = [
            'docker',
            'run',
            '-it',
            '--net=host',
            '--env', f'DISPLAY={DOCKER_HOST_NAME}:0',
            '--volume', f'{os.environ["HOME"]}/.Xauthority:/home/akl/.Xauthority:rw',
        ]

        if self.run_in_background:
            docker_args.append('-d')  # -d: detach

        # Default arguments for the container, always used
        docker_args.extend([
            'wnt3rmute/ardupilot-sitl',
            './sim_vehicle.py',
            '-N',
        ])

        docker_args.extend([
            '-v',
            self.vehicle,
            '-L',
            self.location
        ])

        if self.map_on:
            docker_args.append('--map')

        if self.console_on:
            docker_args.append('--console')

        if not self.pre_arm_checks:
            docker_args.append('--add-param-file=no_pre_arm_checks.parm')
        
        if self.out_ip:
            docker_args.append(f'--out={self.out_ip}')

        if not self.run_in_background:
            print("=== Replacing the current process with Ardupilot Terminal ===")
            print(' '.join(docker_args))
            os.execvp('docker', docker_args)

        else:
            self.container_id = check_output(docker_args).decode().replace('\n', '')

    def stop(self):
        os.system(f'docker stop {self.container_id}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='SITL Runner for MacOS')

    parser.add_argument(
        '-m',
        '--map',
        help='Show the map window',
        action='store_true'
    )
    parser.add_argument(
        '-c',
        '--console',
        help='Show the console window',
        action='store_true'
    )
    parser.add_argument(
        '-v',
        '--vehicle',
        help='Choose vehicle (ArduPlane or ArduCopter)',
        required=True
    )
    parser.add_argument(
        '-l',
        '--location',
        help=f"Select location ({DEFAULT_LOCATION} by default)",
        default=DEFAULT_LOCATION
    )
    parser.add_argument(
        '-np',
        '--no-pre-arm-checks',
        help='Enable/Disable pre-arm checks',
        action='store_false'
    )
    parser.add_argument(
        '-o',
        '--out',
        default=None,
        help="Create an additional MavLink output [ip:port]"
    )

    cli_args = parser.parse_args()

    runner = SitlDockerHelper(cli_args.vehicle, cli_args.location, cli_args.map, cli_args.console, False, cli_args.no_pre_arm_checks, cli_args.out)
    runner.run()