class wishbone_mcseqs_lib extends uvm_sequence;

    //Handles of wishbone sequences
    UART_config_BD_9600_CL_8_PE_0 wb_BD_9600_CL_8_PE_0_Stop_0;
    THR_Data wb_transmit_data;
    Read_LSR6 wb_Read_LSR6_bit;
    Enable_Loopback wb_LB_Enable;
    Enable_Loopback wb_Loop_Back_mode;
    Read_Receive_FIFO wb_Read_Rx_FIFO;
    Receive_Data_Available_Interrupt_Seq wb_receive_interrupt;
    READ_IIR_For_Receive_Interrupt wb_Receive_interrupt_Read;
    UART_config_BD_4800_CL_8_PE_0 wb_BD_4800_CL_8_PE_0_Stop_0;
    UART_config_BD_115200_CL_8_PE_0 wb_BD_115200_CL_8_PE_0_Stop_0;
    Enable_Parity_Even_1 wb_Parity_1_Even_1;
    Read_IIR wb_Read_IIR;
    Read_LSR wb_Read_LSR;
    Write_Reset_For_Rx_FIFO_in_FCR  wb_Rx_FIFO_reset;
    Clear_Reset_For_Rx_FIFO_in_FCR  wb_Rx_FIFO_reset_Clear;
    Write_Reset_For_THR_FIFO_in_FCR wb_THR_FIFO_reset;
    Clear_Reset_For_THR_FIFO_in_FCR wb_THR_FIFO_reset_Clear;
    THR_Data_Greater_10 wb_transmit_data_greater_10;
    UART_config_BD_9600_CL_5_PE_1_Even_0_Stop_0 wb_BD_9600_CL_5_PE_1_Stop_0;
    UART_config_BD_9600_CL_6_PE_1_Even_0_Stop_0 wb_BD_9600_CL_6_PE_1_Stop_0;
    UART_config_BD_9600_CL_7_PE_1_Even_0_Stop_0 wb_BD_9600_CL_7_PE_1_Stop_0;
    THR_Empty_Enable_Interrupt_Seq wb_THR_Empty_Interrupt;
    Read_IIR1 wb_Read_IIR1;
    Receiver_Line_Status_Interrupt_Seq wb_Receiver_Line_Status_interrupt;
    Read_IIR_1_2 wb_Read_IIR_1_2;                                                                                                                                                                                                                                         
    UART_config_BD_9600_CL_8_PE_1_Even_1_Stop_0 wb_BD_9600_CL_8_PE_1_Stop_0;

    basic_slave_seq wb_slave_seq;   //Wishbone slave sequence

    //Handle of uart sequence
    delay_seq1 uart_delay_seq1;
    frame_BD_9600_parity_0 uart_frame_9600_p_0;
    frame_BD_4800_parity_0 uart_frame_4800_p_0;
    frame_BD_115200_parity_0 uart_frame_115200_p_0;
    frame_BD_115200_parity_0_Directed_Data uart_frames_115200_p_0_Directed_Data;
    frame_BD_115200_parity_1_Even_1_P_Type_BAD uart_frame_115200_p_1_BAD;
    frame_BD_4800_parity_1_Even_1_P_Type_BAD uart_frame_4800_p_1_BAD;
    frame_BD_115200_Stop_Bit_0 uart_frame_115200_Stop_0;
    frame_BD_9600_parity_0_Directed_Data_Char_Len_5 uart_frame_9600_CL_5_p_0;
    frame_BD_9600_parity_0_Directed_Data_Char_Len_6 uart_frame_9600_CL_6_p_0;
    frame_BD_9600_parity_0_Directed_Data_Char_Len_7 uart_frame_9600_CL_7_p_0;
    frame_BD_9600_parity_1_Even_1_P_Type_BAD uart_frame_9600_p_1_BAD;                                                                                                      


    `uvm_object_utils(wishbone_mcseqs_lib)
    `uvm_declare_p_sequencer(wishbone_mcsequencer)

    //Class constructor
    function new(string name = "wishbone_mcseqs_lib");
        super.new(name);
    endfunction : new

    //Raising objection in pre body task
    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.raise_objection(this, get_type_name());
        `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask : pre_body

    //Dropping objection in post body task
    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.drop_objection(this, get_type_name());
        `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask : post_body


endclass : wishbone_mcseqs_lib


//Sequence to test transmitted data = data in transmit FIFO
class Data_Transmitted_equals_data_in_FIFO extends wishbone_mcseqs_lib;
    
    //Object macro
    `uvm_object_utils(Data_Transmitted_equals_data_in_FIFO)

    //Class Constructor 
    function new(string name = "Data_Transmitted_equals_data_in_FIFO");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        // `uvm_do_on(wb_Loop_Back_mode, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_transmit_data, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR6_bit, p_sequencer.m_wb_sequencer)
        // `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
    endtask : body


endclass : Data_Transmitted_equals_data_in_FIFO

//Sequence for checking the received data
class Data_Received_equals_Data_in_FIFO extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Data_Received_equals_Data_in_FIFO)

    //Class Constructor
    function new(string name = "Data_Received_equals_Data_in_FIFO");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Data_Received_equals_Data_in_FIFO

//Transmission at baud rate = 4800, parity enable = 0
//Sequence to test transmitted data = data in transmit FIFO
class Data_Transmitted_equals_data_in_FIFO_BD_4800 extends wishbone_mcseqs_lib;
    
    //Object macro
    `uvm_object_utils(Data_Transmitted_equals_data_in_FIFO_BD_4800)

    //Class Constructor 
    function new(string name = "Data_Transmitted_equals_data_in_FIFO_BD_4800");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_4800_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_transmit_data, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR6_bit, p_sequencer.m_wb_sequencer)
    endtask : body


endclass : Data_Transmitted_equals_data_in_FIFO_BD_4800

//Transmission at baud rate = 115200, parity enable = 0
//Sequence to test transmitted data = data in transmit FIFO
class Data_Transmitted_equals_data_in_FIFO_BD_115200 extends wishbone_mcseqs_lib;
    
    //Object macro
    `uvm_object_utils(Data_Transmitted_equals_data_in_FIFO_BD_115200)

    //Class Constructor 
    function new(string name = "Data_Transmitted_equals_data_in_FIFO_BD_115200");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_115200_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_transmit_data, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR6_bit, p_sequencer.m_wb_sequencer)

    endtask : body


endclass : Data_Transmitted_equals_data_in_FIFO_BD_115200

//Sequence for checking the received data at baud rate = 4800
class Data_Received_equals_Data_in_FIFO_BD_4800 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Data_Received_equals_Data_in_FIFO_BD_4800)

    //Class Constructor
    function new(string name = "Data_Received_equals_Data_in_FIFO_BD_4800");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_4800_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_4800_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Data_Received_equals_Data_in_FIFO_BD_4800

//Sequence for checking the received data at baud rate = 115200
class Data_Received_equals_Data_in_FIFO_BD_115200 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Data_Received_equals_Data_in_FIFO_BD_115200)

    //Class Constructor
    function new(string name = "Data_Received_equals_Data_in_FIFO_BD_115200");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_115200_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_115200_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Data_Received_equals_Data_in_FIFO_BD_115200

//Test to check the parity bit by transmitting the wrong parity via transmit UVC of UART with baud rate = 115200
class BAD_PARITY_BD_115200_EVEN_1 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(BAD_PARITY_BD_115200_EVEN_1)

    //Class Constructor
    function new(string name = "BAD_PARITY_BD_115200_EVEN_1");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_115200_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Parity_1_Even_1, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_115200_p_1_BAD, p_sequencer.m_uart_tx_sequencer)
   //     `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : BAD_PARITY_BD_115200_EVEN_1

//Test to check the parity bit by transmitting the wrong parity via transmit UVC of UART with baud rate = 4800
class BAD_PARITY_BD_4800_EVEN_1 extends wishbone_mcseqs_lib;


    //Object macro
    `uvm_object_utils(BAD_PARITY_BD_4800_EVEN_1)

    //Class Constructor
    function new(string name = "BAD_PARITY_BD_4800_EVEN_1");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_4800_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Parity_1_Even_1, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_4800_p_1_BAD, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : BAD_PARITY_BD_4800_EVEN_1

//Sequence to test the framing error
class Framing_Error_BD_115200_Stop_0 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Framing_Error_BD_115200_Stop_0)

    //Class Constructor
    function new(string name = "Framing_Error_BD_115200_Stop_0");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_115200_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        // `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_115200_Stop_0, p_sequencer.m_uart_tx_sequencer)
        // `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR, p_sequencer.m_wb_sequencer)
    endtask : body


endclass : Framing_Error_BD_115200_Stop_0

//Sequence for checking the reset on receiver FIFO at baud rate = 115200
class Reset_Receiver_FIFO_BD_115200 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Reset_Receiver_FIFO_BD_115200)

    //Class Constructor
    function new(string name = "Reset_Receiver_FIFO_BD_115200");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_115200_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_115200_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)

    endtask : body

endclass : Reset_Receiver_FIFO_BD_115200

//Sequence to test the reset's effect (FCR[1]) on Rx FIFO that contains data
class Reset_Rx_FIFO_BD_115200 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Reset_Rx_FIFO_BD_115200)

    //Class Constructor
    function new(string name = "Reset_Rx_FIFO_BD_115200");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_115200_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_115200_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Rx_FIFO_reset, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Rx_FIFO_reset_Clear, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frames_115200_p_0_Directed_Data, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Reset_Rx_FIFO_BD_115200

//Sequence to test the reset's effect (FCR[2]) on THR FIFO that contains data
class Reset_THR_FIFO_BD_115200 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Reset_THR_FIFO_BD_115200)

    //Class Constructor
    function new(string name = "Reset_THR_FIFO_BD_115200");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_115200_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_transmit_data, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_THR_FIFO_reset, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_THR_FIFO_reset_Clear, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_transmit_data_greater_10, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR6_bit, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_LSR, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Reset_THR_FIFO_BD_115200

//Sequence to transmit the data with character length = 5, Baud rate = 9600 and Parity Enable = 0
class Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_5 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_5)

    //Class Constructor
    function new(string name = "Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_5");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_5_PE_1_Stop_0, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_CL_5_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_5

//Sequence to transmit the data with character length = 6, Baud rate = 9600 and Parity Enable = 0
class Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_6 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_6)

    //Class Constructor
    function new(string name = "Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_6");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_6_PE_1_Stop_0, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_CL_6_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_6

//Sequence to transmit the data with character length = 7, Baud rate = 9600 and Parity Enable = 0
class Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_7 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_7)

    //Class Constructor
    function new(string name = "Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_7");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_7_PE_1_Stop_0, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_CL_7_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Data_Received_equals_Data_in_FIFO_BD_9600_Char_Len_7

//Sequence to test the receive data available interrupt at baud rate = 9600
class Receive_Data_Available_Interrupt_BD_9600 extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Receive_Data_Available_Interrupt_BD_9600)

    //Class Constructor
    function new(string name = "Receive_Data_Available_Interrupt_BD_9600");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_receive_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Receive_interrupt_Read, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_p_0, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Receive_Data_Available_Interrupt_BD_9600

//Sequence to test the THR empty interrupt status
class THR_Empty_Interrupt extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(THR_Empty_Interrupt)

    //Class Constructor
    function new(string name = "THR_Empty_Interrupt");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_8_PE_0_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_THR_Empty_Interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_transmit_data, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR1, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_transmit_data_greater_10, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : THR_Empty_Interrupt

//Sequence to verify the receiver line status interrupt
class Receiver_Line_Status_Interrupt extends wishbone_mcseqs_lib;

    //Object macro
    `uvm_object_utils(Receiver_Line_Status_Interrupt)

    //Class Constructor
    function new(string name = "Receiver_Line_Status_Interrupt");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_on(wb_BD_9600_CL_8_PE_1_Stop_0 , p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Receiver_Line_Status_interrupt, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_p_1_BAD, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_Rx_FIFO, p_sequencer.m_wb_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
        `uvm_do_on(uart_frame_9600_p_1_BAD, p_sequencer.m_uart_tx_sequencer)
        `uvm_do_on(wb_Read_IIR, p_sequencer.m_wb_sequencer)
    endtask : body

endclass : Receiver_Line_Status_Interrupt






