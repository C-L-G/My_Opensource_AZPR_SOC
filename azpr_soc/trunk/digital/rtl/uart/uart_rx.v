/*
 -- ============================================================================
 -- FILE NAME	: uart_rx.v
 -- DESCRIPTION : UART��M���W���[��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

/********** ���ʃw�b�_�t�@�C�� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** �ʃw�b�_�t�@�C�� **********/
`include "uart.h"

/********** ���W���[�� **********/
module uart_rx (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,		// �N���b�N
	input  wire				   reset,	// �񓯊����Z�b�g
	/********** ����M�� **********/
	output wire				   rx_busy, // ��M���t���O
	output reg				   rx_end,	// ��M�����M��
	output reg	[`ByteDataBus] rx_data, // ��M�f�[�^
	/********** UART��M�M�� **********/
	input  wire				   rx		// UART��M�M��
);

	/********** �������W�X�^ **********/
	reg [`UartStateBus]		   state;	 // �X�e�[�g
	reg [`UartDivCntBus]	   div_cnt;	 // �����J�E���^
	reg [`UartBitCntBus]	   bit_cnt;	 // �r�b�g�J�E���^

	/********** ��M���t���O�̐��� **********/
	assign rx_busy = (state != `UART_STATE_IDLE) ? `ENABLE : `DISABLE;

	/********** ��M�_�� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			rx_end	<= #1 `DISABLE;
			rx_data <= #1 `BYTE_DATA_W'h0;
			state	<= #1 `UART_STATE_IDLE;
			div_cnt <= #1 `UART_DIV_RATE / 2;
			bit_cnt <= #1 `UART_BIT_CNT_W'h0;
		end else begin
			/* ��M�X�e�[�g */
			case (state)
				`UART_STATE_IDLE : begin // �A�C�h�����
					if (rx == `UART_START_BIT) begin // ��M�J�n
						state	<= #1 `UART_STATE_RX;
					end
					rx_end	<= #1 `DISABLE;
				end
				`UART_STATE_RX	 : begin // ��M��
					/* �N���b�N�����ɂ��{�[���[�g���� */
					if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin // ����
						/* ���f�[�^�̎�M */
						case (bit_cnt)
							`UART_BIT_CNT_STOP	: begin // �X�g�b�v�r�b�g�̎�M
								state	<= #1 `UART_STATE_IDLE;
								bit_cnt <= #1 `UART_BIT_CNT_START;
								div_cnt <= #1 `UART_DIV_RATE / 2;
								/* �t���[�~���O�G���[�̃`�F�b�N */
								if (rx == `UART_STOP_BIT) begin
									rx_end	<= #1 `ENABLE;
								end
							end
							default				: begin // �f�[�^�̎�M
								rx_data <= #1 {rx, rx_data[`BYTE_MSB:`LSB+1]};
								bit_cnt <= #1 bit_cnt + 1'b1;
								div_cnt <= #1 `UART_DIV_RATE;
							end
						endcase
					end else begin // �J�E���g�_�E��
						div_cnt <= #1 div_cnt - 1'b1;
					end
				end
			endcase
		end
	end

endmodule
