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
//File Name      : uart_tx.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl//uart/uart_tx.v
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

module uart_tx (
	input  wire				   clk,		 
	input  wire				   reset,	 
	input  wire				   tx_start, 
	input  wire [`ByteDataBus] tx_data,	 
	output wire				   tx_busy,	 
	output reg				   tx_end,	 
	output reg				   tx		 
);

	reg [`UartStateBus]		   state;	 
	reg [`UartDivCntBus]	   div_cnt;	 
	reg [`UartBitCntBus]	   bit_cnt;	 
	reg [`ByteDataBus]		   sh_reg;	 

	assign tx_busy = (state == `UART_STATE_TX) ? `ENABLE : `DISABLE;

	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			state	<= #1 `UART_STATE_IDLE;
			div_cnt <= #1 `UART_DIV_RATE;
			bit_cnt <= #1 `UART_BIT_CNT_START;
			sh_reg	<= #1 `BYTE_DATA_W'h0;
			tx_end	<= #1 `DISABLE;
			tx		<= #1 `UART_STOP_BIT;
		end else begin
			case (state)
				`UART_STATE_IDLE : begin 
					if (tx_start == `ENABLE) begin 
						state	<= #1 `UART_STATE_TX;
						sh_reg	<= #1 tx_data;
						tx		<= #1 `UART_START_BIT;
					end
					tx_end	<= #1 `DISABLE;
				end
				`UART_STATE_TX	 : begin 
					if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin 
						case (bit_cnt)
							`UART_BIT_CNT_MSB  : begin 
								bit_cnt <= #1 `UART_BIT_CNT_STOP;
								tx		<= #1 `UART_STOP_BIT;
							end
							`UART_BIT_CNT_STOP : begin 
								state	<= #1 `UART_STATE_IDLE;
								bit_cnt <= #1 `UART_BIT_CNT_START;
								tx_end	<= #1 `ENABLE;
							end
							default			   : begin 
								bit_cnt <= #1 bit_cnt + 1'b1;
								sh_reg	<= #1 sh_reg >> 1'b1;
								tx		<= #1 sh_reg[`LSB];
							end
						endcase
						div_cnt <= #1 `UART_DIV_RATE;
					end else begin 
						div_cnt <= #1 div_cnt - 1'b1 ;
					end
				end
			endcase
		end
	end

endmodule
