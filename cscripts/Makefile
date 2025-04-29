
CC=riscv32-unknown-elf-gcc 
CFLAGS=-O0 -march=rv32imac  -nostdlib -Wall
OBJCOPY=riscv32-unknown-elf-objcopy
OBJDUMP=riscv32-unknown-elf-objdump
SRC_FILE_NAME = main.c

SRC_FILE_NAME_WITHOUT_EXTENSION := $(basename $(SRC_FILE_NAME))

all : compile binary hex 
       
compile :        
	$(CC) $(CFLGAS) -T linker.ld -o $(SRC_FILE_NAME_WITHOUT_EXTENSION).elf start.S $(SRC_FILE_NAME) -nostartfiles 
dump :
	$(OBJDUMP) $(SRC_FILE_NAME_WITHOUT_EXTENSION).elf -d $(SRC_FILE_NAME_WITHOUT_EXTENSION).dump

binary: 
	$(OBJCOPY) -O binary $(SRC_FILE_NAME_WITHOUT_EXTENSION).elf $(SRC_FILE_NAME_WITHOUT_EXTENSION).bin
hex:
	xxd -p -c 4 $(SRC_FILE_NAME_WITHOUT_EXTENSION).bin | xxd -r -p | od -An -tx4 | sed 's/ //g' >$(SRC_FILE_NAME_WITHOUT_EXTENSION)1.hex
	fold -w8 $(SRC_FILE_NAME_WITHOUT_EXTENSION)1.hex > $(SRC_FILE_NAME_WITHOUT_EXTENSION).hex
clean:
	rm *.bin *.elf *.hex





