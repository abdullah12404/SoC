class wishbone_slave_base_sequence  extends uvm_sequence #(wishbone_transaction);

  int ok;

  `uvm_object_utils(wishbone_slave_base_sequence)

  //Class constructor
  function new(string name = "wishbone_slave_base_sequence");
    super.new(name);
    	//set_automatic_phase_objection(1);
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

endclass : wishbone_slave_base_sequence

//Basic sequence for testing the interface UVC
class basic_slave_seq extends wishbone_base_sequence;

  `uvm_object_utils(basic_slave_seq)
  //Class Constructor
  function new(string name = "basic_slave_seq");
    super.new(name);
  endfunction
  //Body task for generating the sequence
  virtual task body();
    `uvm_info(get_type_name(), "Executing the basic sequence.", UVM_LOW)
    forever
    	`uvm_do(req)
  endtask : body

endclass : basic_slave_seq
