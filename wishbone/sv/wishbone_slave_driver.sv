class wishbone_slave_driver extends uvm_driver #(wishbone_transaction);

    `uvm_component_utils(wishbone_slave_driver)

    virtual interface wishbone_if vif;

    //Class constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);       
    endfunction : new

    //Run phase
    // task run_phase(uvm_phase phase);
    //     `uvm_info(get_type_name(), "Inside the run phase of wishbone slave driver class.", UVM_LOW)
    //     forever begin
    //         int ok;     //For transaction recording
    //         seq_item_port.get_next_item(req);
    //         ok = begin_tr(req, "Wishbone Slave driver response");
    //         vif.send_to_dut_slave(req.adr_i, req.data, req.trans, req.ack_o);
    //         end_tr(req);
    //         seq_item_port.item_done();
    //         req.print();
    //     end
    // endtask : run_phase


//    //Connect phase
//     virtual function void connect_phase(uvm_phase phase);
// 	   `uvm_info(get_type_name(), "Inside connect phase of wishbone driver class.", UVM_LOW)
//         if (!wb_vif_config::get(this, get_full_name(),"vif", vif))
//             `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
//     endfunction : connect_phase


endclass : wishbone_slave_driver
