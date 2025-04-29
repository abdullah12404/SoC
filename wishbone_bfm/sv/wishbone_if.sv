`include "defines.sv"
interface wishbone_if (input clock, reset);

  //Importing the UVM and Wishbone package
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wishbone_pkg::*;

  //Interface Signals
  logic cyc_i, stb_i, we_i, inta_o, ack_o;
  logic [31 : 0] adr_i;
  logic [31: 0] dat_o, dat_i;
  logic [3 : 0] sel_i;
  //For testing purpose
  // assign dat_o = dat_i;
  logic start;
  bit a, b;

  //Send to Dut task for driving the signals
  task send_to_dut(input wishbone_transaction m_wb_trans);
    
    //Reset check with highest priority
    if (a == 0)
      begin
        wait(reset);
        @(negedge reset);
      end

        @(negedge clock iff (reset == 0));
          //Driving signals for WRITE transactions
          if(m_wb_trans.trans == WRITE && reset == 0)
            begin
              cyc_i = 1;
              stb_i = 1;
              sel_i = 4'b0001;
              adr_i = m_wb_trans.adr_i;
              we_i = 1'b1;
              dat_i = m_wb_trans.data;
              
	      
//	      $display("Waiting for acknowledgement");
	      //Waiting for acknowledge
              @(posedge ack_o);
              #2;
              //After acknowledge disconnecting the signals
              stb_i = 1'bz;
              we_i = 1'bz;
            end
          //Driving Signals for READ transaction
          else if(m_wb_trans.trans == READ && reset == 0)
            begin
              cyc_i = 1;
              stb_i = 1;
              sel_i = 4'b0001;
              adr_i = m_wb_trans.adr_i;
              we_i = 1'b0;
              dat_i = 8'bzzzzzzzz;
              m_wb_trans.Data_o = dat_o;
              //Waiting for acknowledge
              @(posedge ack_o);
              #2;
              //After acknowledge disconnecting the signals
              stb_i = 1'bz;
              we_i = 1'bz;
            end
          //In case of IDLE
          else if(m_wb_trans.trans == IDLE && reset == 0)
            begin
              cyc_i = 1'bz;
              stb_i = 1'bz;;
              sel_i = 4'bzzzz;
              adr_i = 2'bzz;
              we_i = 1'bz;
              dat_i = 8'bzzzzzzzz;
            end
            
      a = 1;
  endtask : send_to_dut


    //Task for collecting the data
  task collect_data(output logic [31 : 0] addr_i, transaction_type trans, logic int_o, logic [31: 0] data, logic Reset);
    //Reset check with highest priority
    if (b == 0)
      begin
        wait(reset);
        Reset = reset;
        @(negedge reset);
      end
    else
      begin
        // @(posedge clock iff (reset == 0));
        @(posedge ack_o);
        #1;
        int_o = inta_o;
        addr_i = adr_i;
        if(we_i == 1 && (stb_i & cyc_i) == 1 && reset == 0)
          begin
            trans = WRITE;
            data = dat_i;

          end
        else if(we_i == 0 && (stb_i & cyc_i) == 1 && reset == 0)
          begin
            trans = READ;
            data = dat_o;
          end
        else if(we_i === 1'bz && stb_i == 0 && cyc_i == 0 && reset == 0)
          begin
            trans = IDLE;
            addr_i = `UART_BASE_ADDRESS;
	    data = 8'bzzzzzzzz;
          end
        Reset = reset;

      end
    b = 1;
  endtask : collect_data

  
  // //Task for slave agent's driver
  // task send_to_dut_slave(output logic [2 : 0] addr_i, logic [7 : 0] data, transaction_type trans, logic Ack_o);

  //   @(posedge clock iff (reset == 0 && start == 1));
  //   if(stb_i && cyc_i)
  //     begin
  //       if(we_i == 1)
  //         begin
  //           trans = WRITE;
  //           addr_i = adr_i;
  //           data = dat_i;
  //           #20;
  //           ack_o = 1;
  //           Ack_o = ack_o;
  //           #2;
  //           ack_o = 0;
  //         end
  //       else if(we_i == 0)
  //         begin
  //           trans = READ;
  //           addr_i = adr_i;
  //           dat_o = 35;
  //           data = dat_o;
  //           #25;
  //           ack_o = 1;
  //           Ack_o = ack_o;
  //           #2;
  //           ack_o = 0;
  //         end
  //     end
  //   else
  //     begin
  //       trans = IDLE;
  //       addr_i = 'bx;
  //       data = 'b0;
  //       ack_o = 1'b0;
  //     end
    

  // endtask : send_to_dut_slave


endinterface : wishbone_if
