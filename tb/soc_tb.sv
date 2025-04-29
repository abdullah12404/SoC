class soc_tb  extends uvm_env;

    //handle of wishbone env
    wishbone_env  m_wb_env;
    //handle of uart env
    uart_env m_uart_env;
    //handle of clock and reset env
    clock_and_reset_env m_clock_and_reset_env;

    //Virtual/Multichannel sequencer
    soc_mcsequencer mcsequencer;

    //soc_module_uvc
    soc_module m_soc_module;



    `uvm_component_utils(soc_tb)
    //Class constructor
    function new(string name = "soc_tb", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      `uvm_info(get_type_name(), "Inside testbench build phase", UVM_HIGH)
      m_wb_env = wishbone_env ::type_id::create("m_wb_env", this);
      m_uart_env = uart_env::type_id::create("m_uart_env", this);
      m_clock_and_reset_env = clock_and_reset_env::type_id::create("m_clock_and_reset_env", this);
      // virtual sequencer
      mcsequencer = soc_mcsequencer::type_id::create("mcsequencer", this);
      //SoC Module UVC
      m_soc_module = soc_module ::type_id::create("m_soc_module", this);


    endfunction : build_phase

    //Connect phase
    function void connect_phase(uvm_phase phase);
	m_wb_env.m_wb_agent.is_active = UVM_PASSIVE;
      //Multichannel sequencer connections
      mcsequencer.m_wb_sequencer = m_wb_env.m_wb_agent.m_wb_sequencer;      //Wishbone master sequencer
      //mcsequencer.m_wb_slave_sequencer = m_wb_env.m_wb_slave_agent.m_wb_slave_sequencer;      //Wishbone slave sequencer
      mcsequencer.m_uart_tx_sequencer = m_uart_env.m_uart_tx_agent.m_uart_tx_sequencer; 

      //Connecting the monitor and scoreboard
      m_wb_env.m_wb_agent.m_wb_monitor.wb_analysis_port.connect(m_soc_module.m_wb_interconnect_ref_model.wb_bfm_analysis_imp);
//      m_wb_env.m_wb_agent.m_wb_monitor.wb_analysis_port.connect(m_uart_module.uart_sbd.wb_uart_analysis_imp);
      m_uart_env.m_uart_tx_agent.m_uart_tx_monitor.uart_tx_analysis_port.connect(m_soc_module.soc_sbd.uart_tx_analysis_imp);
      m_uart_env.m_uart_rx_agent.m_uart_rx_monitor.uart_rx_analysis_port.connect(m_soc_module.soc_sbd.uart_rx_analysis_imp);
	

    endfunction : connect_phase

endclass : soc_tb
