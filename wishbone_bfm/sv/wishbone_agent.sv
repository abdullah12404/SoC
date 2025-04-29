class wishbone_agent  extends uvm_agent;

   wishbone_driver m_wb_driver;
   wishbone_monitor m_wb_monitor;
   wishbone_sequencer m_wb_sequencer;

   //Macros for built-in automation
   `uvm_component_utils_begin(wishbone_agent)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_component_utils_end

   //Class constructor
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   //Build phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Inside the build phase of wishbone_agent", UVM_LOW)
      m_wb_monitor = wishbone_monitor ::type_id::create("m_wb_monitor" , this);
      //Checking whether an agent is active or passive
      if(is_active == UVM_ACTIVE)
         begin
            m_wb_driver = wishbone_driver::type_id::create("m_wb_driver" , this);
            m_wb_sequencer = wishbone_sequencer::type_id::create("m_wb_sequencer" , this);
         end
   endfunction : build_phase

   //Connect phase
   virtual function void connect_phase(uvm_phase phase);
      `uvm_info(get_type_name(), "Inside the connect_phase of wishbone_agent class.", UVM_LOW)
      if(is_active == UVM_ACTIVE)
      begin
	      m_wb_driver.seq_item_port.connect(m_wb_sequencer.seq_item_export);
      end
   endfunction : connect_phase

   //Run phase
   task run_phase(uvm_phase phase);
	`uvm_info(get_type_name(), "Inside run phase of agent.", UVM_LOW)
   endtask : run_phase

endclass : wishbone_agent
