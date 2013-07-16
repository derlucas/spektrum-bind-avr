# $Id: Makefile,v 1.1 2007/01/02 21:30:40 rschaten Exp $

# microcontroller settings
F_CPU = 8000000
MCU = attiny2313

AVRDUDE = avrdude -p $(MCU) -c usbasp
#AVRDUDE = avrdude -p $(MCU) -P /dev/tts/USB0 -b 19200 -c avr109


COMPILE = avr-gcc -Wall -Os -I../common -I. -mmcu=$(MCU) -DF_CPU=$(F_CPU) #-DDEBUG_LEVEL=2

OBJECTS = main.o


# symbolic targets:
all:	main.hex

.c.o:
	$(COMPILE) -c $< -o $@

.S.o:
	$(COMPILE) -x assembler-with-cpp -c $< -o $@
# "-x assembler-with-cpp" should not be necessary since this is the default
# file type for the .S (with capital S) extension. However, upper case
# characters are not always preserved on Windows. To ensure WinAVR
# compatibility define the file type manually.

.c.s:
	$(COMPILE) -S $< -o $@

program:	all
	$(AVRDUDE) -U flash:w:main.hex

fuse:
	$(AVRDUDE) -U lfuse:w:0xfd:m -U hfuse:w:0xdf:m

clean:
	rm -f main.hex main.lst main.obj main.cof main.list main.map main.eep.hex main.bin *.o main.s

# file targets:
main.bin:	$(OBJECTS)
	$(COMPILE) -o main.bin $(OBJECTS)

main.hex:	main.bin
	rm -f main.hex main.eep.hex
	avr-objcopy -j .text -j .data -O ihex main.bin main.hex

disasm:	main.bin
	avr-objdump -d main.bin

cpp:
	$(COMPILE) -E main.c
