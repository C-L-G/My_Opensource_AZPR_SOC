
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

`include "uart.h"

module uart (
	input  wire				   clk,		 
	input  wire				   reset,	 
	input  wire				   cs_n,	 
	input  wire				   as_n,	 
	input  wire				   rw,		 
	input  wire [`UartAddrBus] addr,	 
	input  wire [`WordDataBus] wr_data,	 
	output wire [`WordDataBus] rd_data,	 
	output wire				   rdy_n,	 
	output wire				   irq_rx,	 
	output wire				   irq_tx,	 
	input  wire				   rx,		 
	output wire				   tx		 
);

	wire					   rx_busy;	 
	wire					   rx_end;	 
	wire [`ByteDataBus]		   rx_data;	 
	wire					   tx_busy;	 
	wire					   tx_end;	 
	wire					   tx_start; 
	wire [`ByteDataBus]		   tx_data;	 

	uart_ctrl uart_ctrl (
		.clk	  (clk),	   
		.reset	  (reset),	   
		.cs_n	  (cs_n),	   
		.as_n	  (as_n),	   
		.rw		  (rw),		   
		.addr	  (addr),	   
		.wr_data  (wr_data),   
		.rd_data  (rd_data),   
		.rdy_n	  (rdy_n),	   
		.irq_rx	  (irq_rx),	   
		.irq_tx	  (irq_tx),	   
		.rx_busy  (rx_busy),   
		.rx_end	  (rx_end),	   
		.rx_data  (rx_data),   
		.tx_busy  (tx_busy),   
		.tx_end	  (tx_end),	   
		.tx_start (tx_start),  
		.tx_data  (tx_data)	   
	);

	uart_tx uart_tx (
		.clk	  (clk),	   
		.reset	  (reset),	   
		.tx_start (tx_start),  
		.tx_data  (tx_data),   
		.tx_busy  (tx_busy),   
		.tx_end	  (tx_end),	   
		.tx		  (tx)		   
	);

	uart_rx uart_rx (
		.clk	  (clk),	   
		.reset	  (reset),	   
		.rx_busy  (rx_busy),   
		.rx_end	  (rx_end),	   
		.rx_data  (rx_data),   
		.rx		  (rx)		   
	);

endmodule
