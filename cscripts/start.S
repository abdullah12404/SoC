.section .init
.globl _start
_start:
    li sp, 0x00004000     # Set the stack pointer
    call main             # Call the main function
