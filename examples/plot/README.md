# Plot
A demo application that uses
[json-fortran](https://github.com/jacobwilliams/json-fortran/) and
[DISLIN](http://www.mps.mpg.de/dislin/) to plot data in real-time.

Copy the `*.mod` files of DISLIN, json-fortran, and Eclipse Paho to
`./include/`, for example:
```
dislin.mod
json_file_module.mod
json_kinds.mod
json_module.mod
json_parameters.mod
json_string_utilities.mod
json_value_module.mod
paho_client.mod
paho_consts.mod
paho_types.mod
paho_utils.mod
```

Copy the DISLIN, json-fortran, and Eclipse Paho library files to
`./lib/`, for example:
```
dislin-11.1.a
libjsonfortran.a
libpaho-mqtt3a.so -> libpaho-mqtt3a.so.1
libpaho-mqtt3a.so.1 -> libpaho-mqtt3a.so.1.3.0
libpaho-mqtt3a.so.1.3.0
libpaho-mqtt3c.so -> libpaho-mqtt3c.so.1
libpaho-mqtt3c.so.1 -> libpaho-mqtt3c.so.1.3.0
libpaho-mqtt3c.so.1.3.0
```

Run the `Makefile` to build the demo application:
```
$ make
```