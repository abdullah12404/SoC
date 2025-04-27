// 64 bit option required for AWS labs
-64
-uvmhome /home/advancedresearch/cadence/installs/XCELIUM2309/tools/methodology/UVM/CDNS-1.2

// default timescale
-timescale 1ns/1ps

// include directories
-incdir ../sv //wishbone UVC
-incdir ../../uart_/sv //UART UVC
-incdir ../../clock_and_reset/sv //clock and reset UVC
//For RTL
-incdir "../../UART DUT/"


// compile files

// wishbone UVC package and interface
../sv/wishbone_pkg.sv
../sv/wishbone_if.sv 

// UART UVC package and interface
../../uart_/sv/uart_pkg.sv 
../../uart_/sv/uart_if.sv 

// clock and reset UVC package
../../clock_and_reset/sv/clock_and_reset_pkg.sv 
../../clock_and_reset/sv/clock_and_reset_if.sv 

// clock generator module
clkgen.sv
// top module for UVM test environment
tb_top.sv
// accelerated top module for interface instance
hw_top.sv 

//RTL of UART
"../../UART DUT/uart_wb.v" 
"../../UART DUT/uart_receiver.v" 
"../../UART DUT/uart_regs.v" 
"../../UART DUT/uart_rfifo.v" 
"../../UART DUT/uart_sync_flops.v" 
"../../UART DUT/uart_tfifo.v" 
"../../UART DUT/uart_transmitter.v"
"../../UART DUT/raminfr.v"
"../../UART DUT/uart_top.v"
// UART DUT/uart_defines.v 

