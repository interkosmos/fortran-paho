FC      = gfortran8
CFLAGS   = -std=f2008 -Wall -Wl,-rpath=/usr/local/lib/gcc8/ -Wl,-rpath=./lib/ -I./include/ -L./lib/
LDFLAGS  = ./lib/libjsonfortran.a ./lib/dislin-11.1.a -lm -lXm -lXt -lX11 -lGL -lpaho-mqtt3c
SRC      = plot.f90
TARGET   = plot
PAHO_OBJ = ../../paho.o

.PHONY: all clean

all: $(TARGET)

$(TARGET):
	$(FC) $(CFLAGS) -o $(TARGET) $(SRC) $(PAHO_OBJ) $(LDFLAGS)

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
