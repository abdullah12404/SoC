typedef enum {IDLE, WRITE, READ} transaction_type;

class wishbone_transaction  extends uvm_sequence_item;

    //Signals of wishbone interface
    rand logic [31 : 0] adr_i;
    rand logic [31 : 0] data;
    rand transaction_type trans;
    logic inta_o, reset;
    logic [31 : 0] Data_o;

  //Class Constructor
  function new (string name = "wishbone_transaction");
        super.new(name);
    endfunction

    //Macros for built-in automation 
    `uvm_object_utils_begin(wishbone_transaction )
        `uvm_field_int(adr_i, UVM_ALL_ON)
        `uvm_field_enum(transaction_type, trans, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON + UVM_DEC)
        `uvm_field_int(inta_o, UVM_ALL_ON)
        `uvm_field_int(reset, UVM_ALL_ON)
        `uvm_field_int(Data_o, UVM_ALL_ON)
    `uvm_object_utils_end

endclass : wishbone_transaction
