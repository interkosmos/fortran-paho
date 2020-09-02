.POSIX:

FC        = gfortran
AR        = ar
FFLAGS    = -Wall -Wl,-rpath=./paho.mqtt.c/build/src/ -std=f2008
LDFLAGS   = -I./paho.mqtt.c/src/ -L./paho.mqtt.c/build/src/
LDLIBS    = -lpaho-mqtt3c
ARFLAGS   = rcs

TARGET    = libfortran-paho.a

DIR       = examples
SUBSCRIBE = subscribe
PUBLISH   = publish
PLOT      = plot

.PHONY: all clean paho

all: $(TARGET)

paho: $(TARGET)

$(TARGET):
	$(FC) $(FFLAGS) -c src/paho.f90
	$(AR) $(ARFLAGS) $(TARGET) paho.o

$(SUBSCRIBE): $(DIR)/$(SUBSCRIBE)/$(SUBSCRIBE).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(PUBLISH): $(DIR)/$(PUBLISH)/$(PUBLISH).f90 $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(PLOT):
	cd $(DIR)/$(PLOT)/ && make

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e $(SUBSCRIBE) ]; then rm $(SUBSCRIBE); fi
	if [ -e $(PUBLISH) ]; then rm $(PUBLISH); fi
	cd $(DIR)/$(PLOT)/ && make clean
