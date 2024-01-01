.POSIX:

FC      = gfortran
AR      = ar
FFLAGS  = -Wall -std=f2008 -Wno-unused-dummy-argument
LDFLAGS =
LDLIBS  = -lpaho-mqtt3c
ARFLAGS = rcs
TARGET  = libfortran-paho.a

.PHONY: all clean examples

all: $(TARGET)

examples: publish subscribe

$(TARGET): src/paho.f90 src/paho_util.f90
	$(FC) $(FFLAGS) -c src/paho_util.f90
	$(FC) $(FFLAGS) -c src/paho.f90
	$(AR) $(ARFLAGS) $(TARGET) paho.o paho_util.o

publish: examples/publish.f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o publish examples/publish.f90 $(TARGET) $(LDLIBS)

subscribe: examples/subscribe.f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o subscribe examples/subscribe.f90 $(TARGET) $(LDLIBS)

clean:
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e publish ]; then rm publish; fi
	if [ -e subscribe ]; then rm subscribe; fi
