class wishbone_env  extends uvm_env;

   wishbone_agent  m_wb_agent;
   // wishbone_slave_agent m_wb_slave_agent;
   // wishbone_monitor m_wb_bus_monitor;

   `uvm_component_utils(wishbone_env)

   //Class constructor
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   //Build phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Inside the build_phase of wishbone_env", UVM_LOW)
      m_wb_agent = wishbone_agent::type_id::create("m_wb_agent", this);
      // m_wb_slave_agent = wishbone_slave_agent::type_id::create("m_wb_slave_agent", this);
      // m_wb_bus_monitor = wishbone_monitor::type_id::create("m_wb_bus_monitor", this);
   endfunction : build_phase

   //Connect phase
  virtual function void connect_phase(uvm_phase phase);
	   `uvm_info(get_type_name(), "Inside connect phase of environment.", UVM_LOW)
      // m_wb_agent.m_wb_monitor = m_wb_bus_monitor;
      // m_wb_slave_agent.m_wb_monitor = m_wb_bus_monitor;
    endfunction : connect_phase

endclass : wishbone_env
