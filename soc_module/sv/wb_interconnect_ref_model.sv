class wb_interconnect_ref_model extends uvm_scoreboard;

	import wishbone_pkg::*;
	import uart_pkg::*;
	import soc_module_pkg::*;
     //Component utility macro
    `uvm_component_utils(wb_interconnect_ref_model)

   
     //TLM implementation ports
    `uvm_analysis_imp_decl(_wb_bfm)

    //Implementation port for Wishbone Bus Functional Moel
    
    uvm_analysis_imp_wb_bfm #(wishbone_transaction, wb_interconnect_ref_model) wb_bfm_analysis_imp;


    // Peripherals connection to their ref models
    //
    uvm_analysis_port #(wishbone_transaction) wb_uart_analysis;
    uvm_analysis_port #(wishbone_transaction) wb_gpio_analysis;
    uvm_analysis_port #(wishbone_transaction) wb_spi1_analysis;
    uvm_analysis_port #(wishbone_transaction) wb_spi2_analysis;
    uvm_analysis_port #(wishbone_transaction) wb_i2c_analysis;
    uvm_analysis_port #(wishbone_transaction) wb_ptc_analysis;
    uvm_analysis_port #(wishbone_transaction) wb_clint_analysis;
//    uvm_analysis_port #(wishbone_transaction) wb_spi_ref_model_analysis_port;

    //Class constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        wb_bfm_analysis_imp = new("wb_bfm_analysis_imp", this);
        wb_uart_analysis = new("wb_uart_analysis", this);
    endfunction : new

    //Write implementation of wb analysis import
    function void write_wb_bfm (wishbone_transaction m_wb_trans);
        
        //Creating the handle to clone it
        wishbone_transaction clone_m_wb_trans;
        $cast(clone_m_wb_trans, m_wb_trans.clone());


	if(m_wb_trans.reset == 1)
		wb_uart_analysis.write(m_wb_trans);


	if(m_wb_trans.adr_i >= `UART_BASE_ADDRESS && m_wb_trans.adr_i <= `UART_END_ADDRESS) 
	begin
	end
	else if(m_wb_trans.adr_i >= `GPIO_BASE_ADDRESS && m_wb_trans.adr_i <= `GPIO_END_ADDRESS) 
	begin
		wb_gpio_analysis.write(m_wb_trans);
	end
	else if(m_wb_trans.adr_i >= `SPI1_BASE_ADDRESS && m_wb_trans.adr_i <= `SPI1_END_ADDRESS) 
	begin
		wb_spi1_analysis.write(m_wb_trans);
	end
	else if(m_wb_trans.adr_i >= `SPI2_BASE_ADDRESS && m_wb_trans.adr_i <= `SPI2_END_ADDRESS) 
	begin
		wb_spi2_analysis.write(m_wb_trans);
	end
	else if(m_wb_trans.adr_i >= `I2C_BASE_ADDRESS && m_wb_trans.adr_i <= `I2C_END_ADDRESS) 
	begin
		wb_i2c_analysis.write(m_wb_trans);
	end
	else if(m_wb_trans.adr_i >= `PTC_BASE_ADDRESS && m_wb_trans.adr_i <= `PTC_END_ADDRESS) 
	begin
		wb_ptc_analysis.write(m_wb_trans);
	end
	else if(m_wb_trans.adr_i >= `CLINT_BASE_ADDRESS && m_wb_trans.adr_i <= `CLINT_END_ADDRESS) 
	begin
		wb_clint_analysis.write(m_wb_trans);
	end
endfunction
endclass : wb_interconnect_ref_model
