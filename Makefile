PROJ_NAME = blinky

# Compile Options

PART=TM4C123GH6PM

TIVAWARE_ROOT = ../tools/tivaware
TIVA_DRIVERS = $(TIVAWARE_ROOT)/driverlib

SRCS = $(wildcard *.c)
SRCS += $(TIVAWARE_ROOT)/driverlib/gcc/libdriver.a

WARNING_LEVEL = -Wall
OPTIMIZATION_LEVEL = -O0

LIBS = '$(shell $(CC) $(CFLAGS) -print-file-name=libm.a)'
LIBS += '$(shell $(CC) $(CFLAGS) -print-file-name=libc.a)'
LIBS += '$(shell $(CC) $(CFLAGS) -print-libgcc-file-name)'

LINK_LIBS = $(addprefix -L, $(LIBS))

AFLAGS = -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -MD

CFLAGS = -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -ffunction-sections -fdata-sections -MD
CFLAGS +=  -std=c99 $(WARNING_LEVEL) -pedantic -DPART_TM4C123GH6PM -c -Wl,--gc-sections
CFLAGS += $(WARNING_LEVEL) $(OPTIMIZATION_LEVEL)
CFLAGS += -g -D DEBUG

DEFS = -DPART_TM4C123GH6PM -DTARGET_IS_TM4C123_RB1

INC_DIRS = $(addprefix -I, $(TIVAWARE_ROOT))
INC_DIRS += $(addprefix -I, $(TIVA_DRIVERS))

LDFLAGS = -T$(PROJ_NAME).ld --entry ResetISR

# Tool Definitions

CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy
GDB = arm-none-eabi-gdb

LM4FLASH = ../tools/lm4tools/lm4flash/lm4flash
OPENOCD = openocd

# Implicit Rule Definitions

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.o: %.c
	$(CC) $(INC_DIRS) $(DEFS) $(CFLAGS) -c -o $@ $<

%.o: %.s
	$(CC) $(INC_DIRS) $(DEFS) -c -o $@ $< $(AFLAGS)

# Build Rules

all: $(PROJ_NAME).bin

clean:
	rm *.o *.d *.bin *.elf

flash: $(PROJ_NAME).bin
	$(LM4FLASH) $<

debug: $(PROJ_NAME).elf
	$(OPENOCD) -f board/ek-tm4c123gxl.cfg &
	$(GDB) $<

OBJS = $(patsubst %.c, %.o, ${SRCS})

$(PROJ_NAME).elf: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^
