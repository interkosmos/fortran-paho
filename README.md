# fortran-paho
A collection of Fortran 2008 interface bindings to the
[Eclipse Paho](https://www.eclipse.org/paho/) MQTT client library, to
connect Fortran to the Internet of Things. Currently, *fortran-paho* is just a
proof of concept.

## Requirements
A Fortran 2008 compiler and the Eclipse Paho C library are required for building
and linking the library. Compilation has been tested with GNU Fortran 10, but
should work with other modern compilers as well.

## Build Eclipse Paho
If Eclipse Paho is not installed already, clone the GitHub
[repository](https://github.com/eclipse/paho.mqtt.c) and build it from
source:

```
$ git clone https://github.com/eclipse/paho.mqtt.c
$ cd paho.mqtt.c/
$ mkdir build && cd build/
$ cmake ..
$ make
$ make install
```

If you do not want to install Eclipse Paho globally with `make install`, copy
`paho.mqtt.c` to you working directory (e.g., `fortran-paho/`). You then have to
alter the Makefile and change the `FFLAGS` parameter to:

```
FFLAGS = -Wall -Wl,-rpath=./paho.mqtt.c/build/src/ -std=2008
```

## Build the Library
Clone the repository with Git and use GNU make to build the Fortran interfaces:

```
$ git clone https://github.com/interkosmos/fortran-paho
$ cd fortran-paho/
$ make
```

You can override the default compiler (`gfortran`) by passing the `FC`
argument, for example:

```
$ make FC=gfortran10
```

Or, compile the source code manually:

```
$ gfortran -c src/paho.f90
```

Add `libfortran-paho.a -lpaho-mqtt3c` to your `LDLIBS` to link Eclipse Paho, for
instance:

```
$ gfortran -I/usr/local/include/ -L/usr/local/lib/ -o example example.f90 libfortran-paho.a -lpaho-mqtt3c
```

## Examples
The source code of some demo applications is located in directory `examples/`.
The examples require a running MQTT message broker. Either start a local broker
or connect to `iot.eclipse.org` on port `1883`.

* **subscribe** connects to an MQTT message broker, subscribes a topic, and prints the payload of received messages.
* **publish** connects to an MQTT message broker and publishes to a topic.
* **plot** uses [json-fortran](https://github.com/jacobwilliams/json-fortran/) and [DISLIN](http://www.mps.mpg.de/dislin/) to plot data in real-time.

Build the examples with:

```
$ make <name>
```

## Licence
ISC
