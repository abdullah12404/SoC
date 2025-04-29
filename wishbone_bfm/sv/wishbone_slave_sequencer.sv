class wishbone_slave_sequencer  extends uvm_sequencer #(wishbone_transaction);

   `uvm_component_utils(wishbone_slave_sequencer)

   //Class Constructor
   function new(string name, uvm_component parent);   
      super.new(name, parent);     
   endfunction

   // start_of_simulation phase
   function void start_of_simulation_phase(uvm_phase phase);
     `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_LOW)
   endfunction : start_of_simulation_phase

   //Build phase
   virtual function void build_phase(uvm_phase phase);
       super.build_phase(phase);
       `uvm_info(get_type_name(), "Inside the build phase of wishbone sequencer", UVM_LOW)
   endfunction : build_phase

   //Run phase
   virtual task run_phase(uvm_phase phase);
	`uvm_info(get_type_name(), "Inside run phase of sequencer.", UVM_LOW)
   endtask : run_phase


endclass : wishbone_slave_sequencer