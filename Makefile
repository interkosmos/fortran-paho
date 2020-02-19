.POSIX:

FC        = gfortran
FFLAGS    = -Wall -Wl,-rpath=./paho.mqtt.c/build/src/ -std=f2008
LDFLAGS   = -I./paho.mqtt.c/src/ -L./paho.mqtt.c/build/src/
LDLIBS    = -lpaho-mqtt3c

PAHO_SRC  = src/paho.f90
PAHO_OBJ  = paho.o

DIR       = examples
SUBSCRIBE = subscribe
PUBLISH   = publish
PLOT      = plot

.PHONY: all clean

all: $(PAHO_OBJ)

paho: $(PAHO_OBJ)

$(PAHO_OBJ):
	$(FC) $(FFLAGS) -c $(PAHO_SRC)

$(SUBSCRIBE): $(DIR)/$(SUBSCRIBE)/$(SUBSCRIBE).f90 $(PAHO_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(PUBLISH): $(DIR)/$(PUBLISH)/$(PUBLISH).f90 $(PAHO_OBJ)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $? $(LDLIBS)

$(PLOT):
	cd $(DIR)/$(PLOT)/ && make

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ -e $(PAHO_OBJ) ]; then rm $(PAHO_OBJ); fi
	if [ -e $(SUBSCRIBE) ]; then rm $(SUBSCRIBE); fi
	if [ -e $(PUBLISH) ]; then rm $(PUBLISH); fi
	cd $(DIR)/$(PLOT)/ && make clean
