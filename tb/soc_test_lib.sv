class base_test extends uvm_test;

    //Wishbone testbench
    soc_tb  m_soc_tb;

    `uvm_component_utils(base_test)

    //Class constructor
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // uvm_objection obj = phase.get_objection();
        // obj.set_drain_time(this, 12000000000/9600);
        // uvm_objection.set_drain_time(this, 12000000000/9600);
        //Default sequence of wishbone master sequencer
        // uvm_config_wrapper::set(this, "m_soc_tb.m_wb_env.m_wb_agent.m_wb_sequencer.run_phase",
        //                         "default_sequence", basic_seq::get_type());
        // //Default sequence for wishbone slave sequencer
        // uvm_config_wrapper::set(this, "m_soc_tb.m_wb_env.m_wb_slave_agent.m_wb_slave_sequencer.run_phase",
        //                         "default_sequence", basic_slave_seq::get_type());
        //Creating the instance of wishbone testbench
        m_soc_tb = soc_tb ::type_id::create("m_soc_tb", this);
        `uvm_info(get_type_name(), "Inside build phase of base_test (test library class)", UVM_HIGH)
    endfunction : build_phase

    //End of elaboration phase
    function void end_of_elaboration_phase(uvm_phase phase);
      	 uvm_root uvm_top = uvm_root::get();
         uvm_top.print_topology();
    endfunction : end_of_elaboration_phase
    //End of elaboration phase
    function void start_of_simulation_phase(uvm_phase phase);
	   uvm_objection obj = phase.get_objection();
         obj.set_drain_time(this, 2*12000000000/115200);
     // phase.set_drain_time(this,500ns);
    endfunction : start_of_simulation_phase


endclass : base_test


//simple test for mcsequencer
class mcsequencer_simple_test extends base_test;

    `uvm_component_utils(mcsequencer_simple_test)

    //Class contructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", soc_mcseqs_lib::get_type());
                
    endfunction: build_phase

endclass : mcsequencer_simple_test


//Test for checking Data transmitted = Data in transmit FIFO
class test_Data_Transmitted_equals_data_in_transmit_FIFO extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Transmitted_equals_data_in_transmit_FIFO)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", Data_Transmitted_equals_data_in_FIFO::get_type());
                
    endfunction: build_phase

endclass : test_Data_Transmitted_equals_data_in_transmit_FIFO

//Test for checking Data received = Data written on Rx pin
class test_Data_Received_equals_data_in extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Received_equals_data_in)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", Data_Received_equals_Data_in_FIFO::get_type());
                
    endfunction: build_phase

endclass : test_Data_Received_equals_data_in

//Data transmission at baud rate = 4800
//Test for checking Data transmitted = Data in transmit FIFO
class test_Data_Transmitted_equals_data_in_transmit_FIFO_BD_115200 extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Transmitted_equals_data_in_transmit_FIFO_BD_115200)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", Data_Transmitted_equals_data_in_FIFO_BD_115200::get_type());
                
    endfunction: build_phase

endclass : test_Data_Transmitted_equals_data_in_transmit_FIFO_BD_115200 
///Test for checking Data received = Data written on Rx pin
class test_Data_Received_equals_data_in_FIFO_BD_4800 extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Received_equals_data_in_FIFO_BD_4800)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", Data_Received_equals_Data_in_FIFO_BD_4800::get_type());
                
    endfunction: build_phase

endclass : test_Data_Received_equals_data_in_FIFO_BD_4800

///Test to check the parity bit by transmitting the wrong parity via transmit
//UVC of UART with buad rate = 115200 
class test_BAD_PARITY_BD_115200_EVEN_1 extends base_test;
    
    //Component macro
    `uvm_component_utils(test_BAD_PARITY_BD_115200_EVEN_1)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", BAD_PARITY_BD_115200_EVEN_1::get_type());
                
    endfunction: build_phase

endclass : test_BAD_PARITY_BD_115200_EVEN_1

