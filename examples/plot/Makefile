FC       = gfortran
FFLAGS   = -Wl,-rpath=./lib/ -I../../ -std=f2008 -Wno-unused-dummy-argument -Wno-maybe-uninitialize
LDFLAGS  = -I./include/ -L./lib/
LDLIBS   = ./lib/libjsonfortran.a ./lib/dislin-11.1.a -lm -lXm -lXt -lX11 -lGL -lpaho-mqtt3c
SRC      = plot.f90
TARGET   = plot
LIB      = ../../libfortran-paho.a

.PHONY: all clean

all: $(TARGET)

$(TARGET):
	$(FC) $(FFLAGS) $(LDFLAGS) -o $(TARGET) $(SRC) $(LIB) $(LDLIBS)

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
