class wishbone_mcsequencer extends uvm_sequencer;

    //Handles of sequencers
    wishbone_sequencer m_wb_sequencer;      //Wishbone master sequencer
    wishbone_slave_sequencer m_wb_slave_sequencer;      //Wishbone slave sequencer
    uart_tx_sequencer m_uart_tx_sequencer;
    //clock_and_reset_sequencer m_clock_and_reset_sequencer;  //Helpful if we want to trigger the reset during run time

    //UVM component macro
    `uvm_component_utils(wishbone_mcsequencer)

    //Class constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : wishbone_mcsequencer