#!/usr/bin/env python3.6

"""Simple Python example program to publish X-/Y-data in JSON format
to an MQTT message broker."""

import json
import math
import time

import paho.mqtt.client as paho

topic = 'fortran'
client_id = 'python'
broker = '127.0.0.1'

def on_message(client, userdata, message):
    print('received message = ', str(message.payload.decode('utf-8')))

client = paho.Client(client_id)
client.on_message = on_message

print('connecting to broker "{}" ...'.format(broker))
client.connect(broker)
client.loop_start()

print('subscribing topic "{}" ...'.format(topic))
client.subscribe(topic)
time.sleep(1)

print('publishing ...')

n = 300
step = 3600 / (n - 1)
fpi = math.pi / 180

for i in range(n):
    r = i * step
    x = r * fpi
    y = math.sin(x)
    data = { 'x': x, 'y': y }
    print('sending message {} ...'.format(i))
    client.publish(topic, json.dumps(data))
    time.sleep(0.25)

client.disconnect()
client.loop_stop()
