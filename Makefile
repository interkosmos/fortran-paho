MAKE      = make
FC        = gfortran8
CFLAGS    = -Wall -std=f2008 \
            -Wl,-rpath=/usr/local/lib/gcc8/ \
            -Wl,-rpath=./paho.mqtt.c/build/src/ \
            -I./paho.mqtt.c/src/ -L./paho.mqtt.c/build/src/
LDFLAGS   = -lpaho-mqtt3c

PAHO_SRC  = paho.f90
PAHO_OBJ  = paho.o

DIR       = examples
SUBSCRIBE = subscribe
PUBLISH   = publish
PLOT      = plot

.PHONY: all clean

all: $(PAHO_OBJ)

paho: $(PAHO_OBJ)

$(PAHO_OBJ):
	$(FC) -Wall -std=f2008 -c $(PAHO_SRC)

$(SUBSCRIBE): $(DIR)/$(SUBSCRIBE)/$(SUBSCRIBE).f90 $(PAHO_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS)

$(PUBLISH): $(DIR)/$(PUBLISH)/$(PUBLISH).f90 $(PAHO_OBJ)
	$(FC) $(CFLAGS) -o $@ $? $(LDFLAGS)

$(PLOT):
	cd $(DIR)/$(PLOT)/ && $(MAKE)

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ -e $(PAHO_OBJ) ]; then rm $(PAHO_OBJ); fi
	if [ -e $(SUBSCRIBE) ]; then rm $(SUBSCRIBE); fi
	if [ -e $(PUBLISH) ]; then rm $(PUBLISH); fi
	cd $(DIR)/$(PLOT)/ && $(MAKE) clean
