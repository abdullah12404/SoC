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

import soc_module_pkg::*;


`include "defines.sv"
`include "soc_mcsequencer.sv"
`include "soc_mcseqs_lib.sv"
//`include "wb_x_uart_scoreboard.sv"
`include "soc_tb.sv"
`include "soc_test_lib.sv"

initial begin
  wb_vif_config::set(null, "*.m_soc_tb.m_wb_env.m_wb_agent.*", "vif", hw_top.wb_if);
  uart_vif_config::set(null, "*.m_soc_tb.m_uart_env.*", "vif", hw_top.UART_if);
  clock_and_reset_vif_config::set(null, "*.m_soc_tb.m_clock_and_reset_env.agent*", "vif", hw_top.clk_rst_if);
  run_test("Data_Transmitted_equals_data_in_transmit_FIFO_BD_4800");
end

initial begin
//`ifdef VCS_SIM
                $readmemh("/home/abid/C-Experiments/main.hex", hw_top.DUT.u_rv32i_soc.inst_mem_inst.tsmc_32k_inst.u0.mem_core_array);
  //  `endif     

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
