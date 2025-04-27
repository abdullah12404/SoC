module top;

import uvm_pkg::*;
`include "uvm_macros.svh"

//Wishbone package
//import wishbone_pkg::*;

`include "wishbone_tb.sv"
`include "wishbone_test_lib.sv"

//wishbone_transaction wb_t;
int ok;

initial begin
  run_test("base_test");
end

endmodule : top