from pymavlink import mavutil
import time

master = mavutil.mavlink_connection('udp:0.0.0.0:14551', autoreconnect=True, retries=10)
print("Connection created")

master.wait_heartbeat()
print("Heartbeat received")

master.wait_gps_fix()
print('Gps fix received')

while True:
    msg = master.recv_match(blocking=True)

    if msg.get_type() == "GLOBAL_POSITION_INT":
        lat = msg.lat / 1e7
        lon = msg.lon / 1e7
        alt = msg.relative_alt / 1e3

        print(f'GPS position: lat {lat}, lon {lon}, alt {alt}')