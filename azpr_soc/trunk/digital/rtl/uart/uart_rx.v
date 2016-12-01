
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

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
