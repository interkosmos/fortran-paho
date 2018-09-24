# f08paho
A Fortran 2008 interface to the [Eclipse Paho](https://www.eclipse.org/paho/)
MQTT client library. Currently, `f08paho` is just a proof of concept.

## Requirements
In order to use the interface, you will need a Fortran 2008 compiler for
building and the Eclipse Paho C library for linking. Compilation has been tested
with GNU Fortran 8, but should work with other modern compilers as well.

## Build Eclipse Paho
If Eclipse Paho is not already installed, clone the GitHub
[repository](https://github.com/eclipse/paho.mqtt.c) and build it from
source:
```
$ git clone https://github.com/eclipse/paho.mqtt.c.git
$ cd paho.mqtt.c/
$ mkdir build
$ cd build
$ cmake ..
$ make
$ make install
```
If you do not want to install Eclipse Paho globally with `make install`, copy
`paho.mqtt.c` to you working directory. You then have to alter the `f08paho`
Makefile and change the `CFLAGS` parameterto:
```
CFLAGS = -Wall -std=2008 \
         -Wl,-rpath=/usr/local/lib/gcc8/ \
         -Wl,-rpath=./paho.mqtt.c/build/src/ \
         -I./paho.mqtt.c/src/ -L./paho.mqtt.c/build/src/
```

## Build the Fortran interface
Clone the repository with Git and use GNU make to build the Fortran interface:
```
$ git clone https://github.com/interkosmos/f08paho.git
$ cd f08paho/
$ make paho
```
You can override the default compiler (`gfortran8`) by passing the `FC`
argument, for example:
```
$ make paho FC=gfortran
```
Or compile the interface manually:
```
$ gfortran8 -c paho.f90
```
Add `-lpaho-mqtt3c` to your `LDFLAGS` to link Eclipse Paho.

## Examples
The source code of some demo applications is located in directory `examples/`.
The examples require a running MQTT message broker. Either start a local broker
or connect to `iot.eclipse.org` on port `1883`.

* **subscribe** connects to an MQTT message broker, subscribes a topic, and prints the payload of received messages.
* **publish** connects to an MQTT message broker and publishes to a topic.
* **plot** uses [json-fortran](https://github.com/jacobwilliams/json-fortran/) and [DISLIN](http://www.mps.mpg.de/dislin/) to plot data in real-time.

Build the examples with:
```
$ build <name>
```

## Licence
ISC
