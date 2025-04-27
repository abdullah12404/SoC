//Testbench top
module tb_top;

//Importing UVM and wishbone package
import uvm_pkg::*;
`include "uvm_macros.svh"
//Wishbone package
import wishbone_pkg::*;
//UART package
import uart_pkg::*;

import uart_module_pkg::*;
//clock and reset package
import clock_and_reset_pkg::*;
`include "defines.sv"
`include "wishbone_mcsequencer.sv"
`include "wishbone_mcseqs_lib.sv"
//`include "wb_x_uart_scoreboard.sv"
`include "wishbone_tb.sv"
`include "wishbone_test_lib.sv"

initial begin
  wb_vif_config::set(null, "*.m_wb_tb.m_wb_env.m_wb_agent.*", "vif", hw_top.wb_if);
  uart_vif_config::set(null, "*.m_wb_tb.m_uart_env.*", "vif", hw_top.UART_if);
  clock_and_reset_vif_config::set(null, "*.m_wb_tb.m_clock_and_reset_env.agent*", "vif", hw_top.clk_rst_if);
  run_test("Data_Transmitted_equals_data_in_transmit_FIFO_BD_4800");
end

/* initial begin
   #100;
   $finish;
 end
*/
initial begin
  $dumpfile("Dump.vcd");
  $dumpvars;
end
endmodule : tb_top
