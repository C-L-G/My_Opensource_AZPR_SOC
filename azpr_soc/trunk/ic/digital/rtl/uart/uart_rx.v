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
//File Name      : uart_rx.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl//uart/uart_rx.v
//License        : Apache-2.0
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2016-11-22 17:00
//First Author   : lichangbeiju
//Last Modify    : 2016-12-08 14:20
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

module uart_rx (
	input  wire				   clk,		
	input  wire				   reset,	
	output wire				   rx_busy, 
	output reg				   rx_end,	
	output reg	[`ByteDataBus] rx_data, 
	input  wire				   rx		
);

	reg [`UartStateBus]		   state;	 
	reg [`UartDivCntBus]	   div_cnt;	 
	reg [`UartBitCntBus]	   bit_cnt;	 

	assign rx_busy = (state != `UART_STATE_IDLE) ? `ENABLE : `DISABLE;

	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			rx_end	<= #1 `DISABLE;
			rx_data <= #1 `BYTE_DATA_W'h0;
			state	<= #1 `UART_STATE_IDLE;
			div_cnt <= #1 `UART_DIV_RATE / 2;
			bit_cnt <= #1 `UART_BIT_CNT_W'h0;
		end else begin
			case (state)
				`UART_STATE_IDLE : begin 
					if (rx == `UART_START_BIT) begin 
						state	<= #1 `UART_STATE_RX;
					end
					rx_end	<= #1 `DISABLE;
				end
				`UART_STATE_RX	 : begin 
					if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin 
						case (bit_cnt)
							`UART_BIT_CNT_STOP	: begin 
								state	<= #1 `UART_STATE_IDLE;
								bit_cnt <= #1 `UART_BIT_CNT_START;
								div_cnt <= #1 `UART_DIV_RATE / 2;
								if (rx == `UART_STOP_BIT) begin
									rx_end	<= #1 `ENABLE;
								end
							end
							default				: begin 
								rx_data <= #1 {rx, rx_data[`BYTE_MSB:`LSB+1]};
								bit_cnt <= #1 bit_cnt + 1'b1;
								div_cnt <= #1 `UART_DIV_RATE;
							end
						endcase
					end else begin 
						div_cnt <= #1 div_cnt - 1'b1;
					end
				end
			endcase
		end
	end

endmodule
