class soc_module extends uvm_env;
	`uvm_component_utils(soc_module);
	
	import uart_pkg::*;
	import soc_module_pkg::*;
	
	soc_scoreboard soc_sbd;
	wb_interconnect_ref_model m_wb_interconnect_ref_model;

	wb_x_uart_ref_model m_wb_x_uart_ref_model;

	function new(string name ="soc_module", uvm_component parent);
		super.new(name,parent);

	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		soc_sbd = soc_scoreboard::type_id::create("soc_sbd",this);
		m_wb_interconnect_ref_model = wb_interconnect_ref_model::type_id::create("m_wb_interconnect_ref_model",this);
		m_wb_x_uart_ref_model = wb_x_uart_ref_model::type_id::create("m_wb_x_uart_ref_model",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		soc_sbd.m_wb_x_uart_ref_model = m_wb_x_uart_ref_model;

		m_wb_interconnect_ref_model.wb_uart_analysis.connect(m_wb_x_uart_ref_model.wb_uart_analysis_imp_ref_model); //Connecting Wb Interconnect Ref to UART Ref Model 		
		m_wb_x_uart_ref_model.wb_uart_analysis_imp_sbd.connect(soc_sbd.wb_uart_analysis_imp);	//Connecting UART Ref Model to SBD	
		
	endfunction
endclass
