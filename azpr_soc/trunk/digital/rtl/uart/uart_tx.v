
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

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
