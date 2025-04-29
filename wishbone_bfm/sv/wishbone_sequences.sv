class wishbone_base_sequence  extends uvm_sequence #(wishbone_transaction);

//    int UART_BASE_ADDRESS=32'h20000000; 	
    int ok;
    wishbone_transaction rsp;

    `uvm_object_utils(wishbone_base_sequence)

    //Class constructor
    function new(string name = "wishbone_base_sequence");
      super.new(name);
        // set_automatic_phase_objection(1);
    endfunction

    //Raising the objection in Pre body
    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
          phase = get_starting_phase();
        `else
          phase = starting_phase;
        `endif
        if(phase != null)
          begin
            phase.raise_objection(this);
            `uvm_info(get_type_name(), "Objection has been raised.", UVM_LOW)
          end
      endtask : pre_body

    //Dropping the objection in post body
    task post_body();
      uvm_phase phase;
      `ifdef UVM_VERSION_1_2
        phase = get_starting_phase();
      `else
        phase = starting_phase;
      `endif
      if(phase != null)
        begin
          phase.drop_objection(this);
        end
    endtask : post_body

  endclass : wishbone_base_sequence

  //Configuring the UART for baud rate = 9600, char_len = 8, parity_enable = 0
  class UART_config_BD_9600_CL_8_PE_0 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_9600_CL_8_PE_0)

    //Class Constructor
    function new(string name = "UART_config_BD_9600_CL_8_PE_0");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      //Configuring the UART to communicate at baud rate = 9600, char_len = 8
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10000011;})      //Writing to the LCR(To access the divisor latch, setting the bit [7] of LCR to 1.)
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000010;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 8'b10001011;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00000011;})     //Writing 0 to the bit[7] of LCR to enable the normal access of registers.  endtask : body
    endtask : body

  endclass : UART_config_BD_9600_CL_8_PE_0

  //Configuring the UART for baud rate = 9600, char_len = 8, parity_enable = 1, Even parity = 1, Stop bit = 0
  class UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0)

    //Class Constructor
    function new(string name = "UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      //Configuring the UART to communicate at baud rate = 9600, char_len = 8, Even parity = 1, stop bit = 0
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10011011;})      //Writing to the LCR(To access the divisor latch, setting the bit [7] of LCR to 1.)
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000010;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 8'b10001011;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00011011;})     //Writing 0 to the bit[7] of LCR to enable the normal access of registers.  endtask : body
    endtask : body

  endclass : UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0

  //Write to the interrupt enable register to enable the Receive data available interrupt
  class Receive_Data_Available_Interrupt_Seq extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Receive_Data_Available_Interrupt_Seq)

    //Class Constructor
    function new(string name = "Receive_Data_Available_Interrupt_Seq");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000001;})     //Write the bit 0 = 1 to enable the interrupt
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == WRITE; req.data == 8'b01000000;})     //Write to the FCR to set the trigger level = 4 bytes
    endtask : body

  endclass : Receive_Data_Available_Interrupt_Seq

  //Reading the interrupt identification register
  class READ_IIR_For_Receive_Interrupt extends wishbone_base_sequence;

    bit IIR2 = 0;

    //Object macro
    `uvm_object_utils(READ_IIR_For_Receive_Interrupt)

    //Class Constructor
    function new(string name = "READ_IIR_For_Receive_Interrupt");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      while(!IIR2)
        begin
          rsp = wishbone_transaction::type_id::create("rsp");
          `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == READ;})       //Reading the IIR register
          get_response(rsp); // get the response after item_done in driver
          IIR2 = rsp.data[2];
        end
      IIR2 = 0;
    endtask : body

  endclass : READ_IIR_For_Receive_Interrupt

  //Seq to enable the Transmit holding register empty interrupt
  class THR_Empty_Enable_Interrupt_Seq extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(THR_Empty_Enable_Interrupt_Seq)

    //Class Constructor
    function new(string name = "THR_Empty_Enable_Interrupt_Seq");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000010;})     //Writing to the IER to enable the THR empty interrupt
    endtask : body

  endclass : THR_Empty_Enable_Interrupt_Seq

  //Polling the bit[1] of IIR which should be asserted when THR is empty
  class Read_IIR1 extends wishbone_base_sequence;

    bit IIR1 = 0;
    //Object macro
    `uvm_object_utils(Read_IIR1)

    //Class constructor
    function new(string name = "Read_IIR1");
      super.new(name);
    endfunction : new


    //Body task
    virtual task body();
      while(!IIR1)
        begin
          rsp = wishbone_transaction::type_id::create("rsp");
          `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == READ;})
          get_response(rsp); // get the response after item_done in driver
          IIR1 = rsp.data[1]; 
        end
      IIR1 = 0;
    endtask : body

  endclass : Read_IIR1


  //Receiver line status interrupt test by enabling the bit 2 of IER
  class Receiver_Line_Status_Interrupt_Seq extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Receiver_Line_Status_Interrupt_Seq)

    //Class Constructor
    function new(string name = "Receiver_Line_Status_Interrupt_Seq");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000100;})       //Writing to the bit 2 of IER to enable the Receiver Line Status interrupt 
    endtask : body

  endclass : Receiver_Line_Status_Interrupt_Seq

  //Sequence to poll on the bits[2 : 1] of IIR
  class Read_IIR_1_2 extends wishbone_base_sequence;

    logic [1 : 0] IIR_1_2 = 0;
    
    //Object macro
    `uvm_object_utils(Read_IIR_1_2)

    //Class Constructor
    function new(string name = "Read_IIR_1_2");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      while(!(IIR_1_2[1] && IIR_1_2[0]))
          begin
            rsp = wishbone_transaction::type_id::create("rsp");
            `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == READ;})
            get_response(rsp); // get the response after item_done in driver
            IIR_1_2[0] = rsp.data[0]; 
            IIR_1_2[1] = rsp.data[1]; 
          end
        IIR_1_2 = 0;

    endtask : body

  endclass : Read_IIR_1_2

  //Empty the IER register
  class Empty_IER extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Empty_IER)

    //Class Constructor
    function new(string name = "Empty_IER");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000000;})     //Writing the reset value in IER
    endtask : body

  endclass : Empty_IER

  //Writing the data to the transmitter holding register to be used for transmission
  class THR_Data extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(THR_Data)

    //Class Constructor
    function new(string name = "THR_Data");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 5;})
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 2;})
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 3;})
       // `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 4;})
       // `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 5;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 6;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 7;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 8;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 9;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 10;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 11;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 12;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 13;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 14;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 15;})
        // `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 16;})
    endtask : body

  endclass : THR_Data

  //Writing the data to the transmitter holding register to be used for transmission
  class THR_Data_Greater_10 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(THR_Data_Greater_10)

    //Class Constructor
    function new(string name = "THR_Data_Greater_10");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 11;})
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 22;})
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 33;})
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 44;})
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 55;})

    endtask : body

  endclass : THR_Data_Greater_10

  //Reset Transmitt and Receive FIFO
  class Reset_Transmit_Receive_FIFO extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Reset_Transmit_Receive_FIFO)

    //Class Constructor
    function new(string name = "Reset_Transmit_Receive_FIFO");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == WRITE; req.data == 8'b11000110;})     //Writing to the FCR to clear the transmit and receive FIFO
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*5; req.trans == READ;})                               //Reading from the LSR register to see the status of its bit 0(indicating whether Receive FIFO is empty or not) and bit 6(indicating whether Transmitter FIFO is emptyor not)
    endtask : body

  endclass : Reset_Transmit_Receive_FIFO

  //Clearing the FCR
  class Clear_FCR extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Clear_FCR)

    //Class Constructor
    function new(string name = "Clear_FCR");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == WRITE; req.data == 8'b11000000;})   //Setting the FCR to its initial value
    endtask : body

  endclass : Clear_FCR

  //Sequence to set the baudrate = 9600, even parity = 1, char_len = 8, stick parity = 1
  class UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0_SP_1 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0_SP_1)

    //Class Constructor
    function new(string name = "UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0_SP_1");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10101011;})     //Writing to the LCR to configure the UART
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000010;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 8'b10001011;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00101011;})     //Writing to the LCR to disable the divisor latch
    endtask : body

  endclass : UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0_SP_1

  //Read after reset
  class Read_after_Reset extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Read_after_Reset)

    //Class constructor
    function new(string name = "Read_after_Reset");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == READ;})
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == READ;})
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == READ;})
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*5; req.trans == READ;})
    endtask : body

  endclass : Read_after_Reset

  //Sequence to poll until  the transmit FIFO becomes empty
  class Read_LSR6 extends wishbone_base_sequence;
    bit LSR6 = 0;
    //Object macro
    `uvm_object_utils(Read_LSR6)

    //Class constructor
    function new(string name = "Read_LSR6");
      super.new(name);
    endfunction : new


    //Body task
    virtual task body();
      while(!LSR6)
        begin
          rsp = wishbone_transaction::type_id::create("rsp");
          `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*5; req.trans == READ;})
          get_response(rsp); // get the response after item_done in driver
          LSR6 = rsp.data[6]; // LSR bit 5 indicates receiver data ready
        end
      LSR6 = 0;
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*5; req.trans == READ;})
    endtask : body


  endclass : Read_LSR6

  //Sequence to enable loopback mode
  class Enable_Loopback extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Enable_Loopback)

    //Class Constructor
    function new(string name = "Enable_Loopback");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*4; req.trans == WRITE; req.data == 8'b00010000;})
    endtask : body


  endclass : Enable_Loopback

  //Sequence to read from receive FIFO until it becomes empty
  class Read_Receive_FIFO extends wishbone_base_sequence;


    //Object macro
    `uvm_object_utils(Read_Receive_FIFO)

    //Class Constructor
    function new(name = "Read_Receive_FIFO");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      repeat(2)
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == READ;})
    endtask : body

  endclass : Read_Receive_FIFO

  //Set the baudrate to the 4800
  //Configuring the UART for baud rate = 4800, char_len = 8, parity_enable = 0
  class UART_config_BD_4800_CL_8_PE_0 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_4800_CL_8_PE_0)

    //Class Constructor
    function new(string name = "UART_config_BD_4800_CL_8_PE_0");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      //Configuring the UART to communicate at baud rate = 9600, char_len = 8
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10000011;})      //Writing to the LCR(To access the divisor latch, setting the bit [7] of LCR to 1.)
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000101;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 8'b00010110;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00000011;})     //Writing 0 to the bit[7] of LCR to enable the normal access of registers.  endtask : body
    endtask : body

  endclass : UART_config_BD_4800_CL_8_PE_0

  //Set the baudrate to the 115200
  //Configuring the UART for baud rate = 115200, char_len = 8, parity_enable = 0
  class UART_config_BD_115200_CL_8_PE_0 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_115200_CL_8_PE_0)

    //Class Constructor
    function new(string name = "UART_config_BD_115200_CL_8_PE_0");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      //Configuring the UART to communicate at baud rate = 9600, char_len = 8
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10000011;})      //Writing to the LCR(To access the divisor latch, setting the bit [7] of LCR to 1.)
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000000;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == 0; req.trans == WRITE; req.data == 8'b00110110;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == 3; req.trans == WRITE; req.data == 8'b00000011;})     //Writing 0 to the bit[7] of LCR to enable the normal access of registers.  endtask : body
    endtask : body

  endclass : UART_config_BD_115200_CL_8_PE_0

  //sequence to enable the parity and even parity = 1, char len = 8
  class Enable_Parity_Even_1 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Enable_Parity_Even_1)

    //Class Constructor
    function new(string name = "Enable_Parity_Even_1");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      //Configuring the UART to communicate at baud rate = 9600, char_len = 8
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00011011;})      //Writing to the LCR(To access the divisor latch, setting the bit [7] of LCR to 1.)
    endtask : body

  endclass : Enable_Parity_Even_1

//Sequence for reading the IIR register at address 2
class Read_IIR extends wishbone_base_sequence;
    
    //Object macro
    `uvm_object_utils(Read_IIR)

    //Class Constructor
    function new(string name = "Read_IIR");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == READ;})      //Reading IIR
    endtask : body  

endclass : Read_IIR

//Sequence for reading the LSR register at address 5
class Read_LSR extends wishbone_base_sequence;
    
    //Object macro
    `uvm_object_utils(Read_LSR)

    //Class Constructor
    function new(string name = "Read_LSR");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*5; req.trans == READ;})      //Reading IIR
    endtask : body  

endclass : Read_LSR

//Sequence to write reset bit in FCR for Rx FIFO
class Write_Reset_For_Rx_FIFO_in_FCR extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Write_Reset_For_Rx_FIFO_in_FCR)

    //Class Constructor
    function new(string name = "Write_Reset_For_Rx_FIFO_in_FCR");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == WRITE; req.data == 8'b01000010;})      //Writing FCR to clear Rx FIFO
    endtask : body  

endclass  : Write_Reset_For_Rx_FIFO_in_FCR

//Sequence to clear reset bit in FCR for Rx FIFO
class Clear_Reset_For_Rx_FIFO_in_FCR extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Clear_Reset_For_Rx_FIFO_in_FCR)

    //Class Constructor
    function new(string name = "Clear_Reset_For_Rx_FIFO_in_FCR");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == WRITE; req.data == 8'b01000000;})      //Writing FCR to clear Rx bit
    endtask : body  

endclass  : Clear_Reset_For_Rx_FIFO_in_FCR

//Sequence to write reset bit in FCR for THR
class Write_Reset_For_THR_FIFO_in_FCR extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Write_Reset_For_THR_FIFO_in_FCR)

    //Class Constructor
    function new(string name = "Write_Reset_For_THR_FIFO_in_FCR");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == WRITE; req.data == 8'b01000100;})      //Writing FCR to clear THR FIFO
    endtask : body  

endclass  : Write_Reset_For_THR_FIFO_in_FCR

//Sequence to clear reset bit in FCR THR
class Clear_Reset_For_THR_FIFO_in_FCR extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(Clear_Reset_For_THR_FIFO_in_FCR)

    //Class Constructor
    function new(string name = "Clear_Reset_For_THR_FIFO_in_FCR");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*2; req.trans == WRITE; req.data == 8'b01000000;})      //Writing FCR to clear THR FIFO reset bit
    endtask : body  

endclass  : Clear_Reset_For_THR_FIFO_in_FCR

//Sequence to set the even parity = 0, baudrate = 9600, char_len = 5
  class UART_config_BD_9600_CL_5_PE_1_Even_0_Stop_0 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_9600_CL_5_PE_1_Even_0_Stop_0)

    //Class Constructor
    function new(string name = "UART_config_BD_9600_CL_5_PE_1_Even_0_Stop_0");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10001000;})     //Writing to the LCR to configure the UART
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000010;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 8'b10001011;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00001000;})     //Writing to the LCR to disable the divisor latch
    endtask : body

  endclass : UART_config_BD_9600_CL_5_PE_1_Even_0_Stop_0

  //Sequence to set the even parity = 0, baudrate = 9600, char_len = 6
  class UART_config_BD_9600_CL_6_PE_1_Even_0_Stop_0 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_9600_CL_6_PE_1_Even_0_Stop_0)

    //Class Constructor
    function new(string name = "UART_config_BD_9600_CL_6_PE_1_Even_0_Stop_0");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10001001;})     //Writing to the LCR to configure the UART
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000010;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 8'b10001011;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00001001;})     //Writing to the LCR to disable the divisor latch
    endtask : body

  endclass : UART_config_BD_9600_CL_6_PE_1_Even_0_Stop_0

  //Sequence to set the even parity = 0, baudrate = 9600, char_len = 7
  class UART_config_BD_9600_CL_7_PE_1_Even_0_Stop_0 extends wishbone_base_sequence;

    //Object macro
    `uvm_object_utils(UART_config_BD_9600_CL_7_PE_1_Even_0_Stop_0)

    //Class Constructor
    function new(string name = "UART_config_BD_9600_CL_7_PE_1_Even_0_Stop_0");
      super.new(name);
    endfunction : new

    //Body task
    virtual task body();
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b10001010;})     //Writing to the LCR to configure the UART
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.trans == WRITE; req.data == 8'b00000010;})     //Writing to the MSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*0; req.trans == WRITE; req.data == 8'b10001011;})     //Writing to LSBs of Divisor latch
      `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*3; req.trans == WRITE; req.data == 8'b00001001;})     //Writing to the LCR to disable the divisor latch
    endtask : body

  endclass : UART_config_BD_9600_CL_7_PE_1_Even_0_Stop_0






















//Test for configuring the UART before transmission
class Config_for_Rx_trigger_equal_4 extends wishbone_base_sequence;
  bit LSR0;

  //Object macro
  `uvm_object_utils(Config_for_Rx_trigger_equal_4)

  //Class Constructor
  function new(string name = "Config_for_Rx_trigger_equal_4");
    super.new(name);
  endfunction : new

  //Body task
  virtual task body();
    `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*1; req.data == 8'b00000001; req.trans == WRITE;})   //Writing into the IER
    while(!LSR0)    //Polling until bit 0 of LSR becomes 1
      begin
        `uvm_do_with(req, {req.adr_i == `UART_BASE_ADDRESS+4*5; req.trans == READ;})     //Reading from LSR until its bit 0 becomes 1
        get_response(rsp); // get the response after item_done in driver
        LSR0 = rsp.data[0]; // LSR bit 0 indicates receiver data ready
      end
      LSR0 = 0;
  endtask : body


endclass : Config_for_Rx_trigger_equal_4


