class wishbone_driver  extends uvm_driver #(wishbone_transaction );
   
   virtual interface wishbone_if vif;
   wishbone_transaction req, rsp;

   logic [7 : 0] Data_out;
   bit LSR0;

  `uvm_component_utils(wishbone_driver )

   //Class constructor
   function new(string name , uvm_component parent);
      super.new(name, parent);
   endfunction

   //run phase
   virtual task run_phase(uvm_phase phase);
      //get pakets from sequencer and send to DUT
      forever begin
         int rec1;      //For transaction recording
         req = wishbone_transaction::type_id::create("req");
         rsp = wishbone_transaction::type_id::create("rsp");
         seq_item_port.get_next_item(req);
//         $display("[DRIVER : Before send to DUT]" );
//	 req.print();
  rec1 = begin_tr(req, "Wishbone master driver transaction");
         vif.send_to_dut(req);
         rsp.data = vif.dat_o;
         rsp.adr_i = vif.adr_i;
         rsp.set_sequence_id(req.get_sequence_id());
         // Send back response to sequencer
         seq_item_port.put_response(rsp);
         end_tr(req);
         seq_item_port.item_done();
  //      $display("[DRIVER]" );
//	 req.print();
      end

   endtask : run_phase

   //Connect phase
    virtual function void connect_phase(uvm_phase phase);
	   `uvm_info(get_type_name(), "Inside connect phase of wishbone driver class.", UVM_LOW)
        if (!wb_vif_config::get(this, get_full_name(),"vif", vif))
            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    endfunction : connect_phase


endclass : wishbone_driver


