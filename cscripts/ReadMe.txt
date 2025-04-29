

riscv32-unknown-elf-gcc -o main.elf main.c -nostartfiles 
riscv32-unknown-elf-objdump main.elf -d main.dump

riscv32-unknown-elf-objcopy -O binary main.elf main.bin


xxd -p -c 4 main.bin | awk '{print substr($1,7,2) substr($1,5,2) substr($1,3,2) substr($1,1,2)}' > main.hex

