//****************************************************************************************************  
//*---------------Copyright (c) 2016 C-L-G.FPGA1988.lichangbeiju. All rights reserved-----------------
//
//                   --              It to be define                --
//                   --                    ...                      --
//                   --                    ...                      --
//                   --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : uart.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl//uart/uart.v
//License        : Apache-2.0
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2016-11-22 17:00
//First Author   : lichangbeiju
//Last Modify    : 2016-11-23 14:20
//Last Author    : lichangbeiju
//Version Number : 12 commits 
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.12.08 - lichangbeiju - Change the include.
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//**************************************************************************************************** 
//File Include : system header file
`include "../sys_include.h"


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
