ENTRY(_start)

MEMORY {
  RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 64K
}

SECTIONS {
  . = ORIGIN(RAM);
  .text : { *(.init) *(.text*) } > RAM
  .data : { *(.data*) } > RAM
  .bss  : { *(.bss*) } > RAM
}
