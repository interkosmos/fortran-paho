FC       = gfortran8
RPATH    = -Wl,-rpath=/usr/local/lib/gcc8/
FFLAGS   = -Wall $(RPATH) -Wl,-rpath=./lib/ -std=f2008
LDFLAGS  = -I./include/ -L./lib/
LDLIBS   = ./lib/libjsonfortran.a ./lib/dislin-11.1.a -lm -lXm -lXt -lX11 -lGL -lpaho-mqtt3c
SRC      = plot.f90
TARGET   = plot
PAHO     = ../../paho.o

.PHONY: all clean

all: $(TARGET)

$(TARGET):
	$(FC) $(FFLAGS) $(LDFLAGS) -o $(TARGET) $(SRC) $(PAHO) $(LDLIBS)

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
