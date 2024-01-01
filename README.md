# fortran-paho

A collection of Fortran 2008 interface bindings to the
[Eclipse Paho](https://www.eclipse.org/paho/) MQTT client library, to
connect Fortran to the Internet of Things. Currently, *fortran-paho* is just a
proof of concept.

## Requirements

A Fortran 2008 compiler and the Eclipse Paho C library are required to build and
link the library. On FreeBSD, just install the package `libpaho-mqtt3`:

```
# pkg install net/libpaho-mqtt3

```

Alternatively, clone the [repository](https://github.com/eclipse/paho.mqtt.c)
and build Paho from source:

```
$ git clone https://github.com/eclipse/paho.mqtt.c
$ cd paho.mqtt.c/
$ mkdir build && cd build/
$ cmake ..
$ make
$ make install
```

## Build Instructions

Clone the repository with Git and execute the Makefile:

```
$ git clone https://github.com/interkosmos/fortran-paho
$ cd fortran-paho/
$ make
```

You can override the default compiler (`gfortran`) by passing the `FC`
argument, for example:

```
$ make FC=ifx
```

Link your Fortran programs against `libfortran-paho.a -lpaho-mqtt3c`, for
instance:

```
$ gfortran -o example example.f90 libfortran-paho.a -lpaho-mqtt3c
```

## Examples

The source code of some demo applications is located in directory `examples/`.
The examples require a running MQTT message broker. Either start a local broker
or connect to `iot.eclipse.org` on port `1883`.

* **subscribe** connects to an MQTT message broker, subscribes a topic, and
  prints the payload of received messages.
* **publish** connects to an MQTT message broker and publishes to a topic.

Build the examples with:

```
$ make examples
```

## Licence

ISC
