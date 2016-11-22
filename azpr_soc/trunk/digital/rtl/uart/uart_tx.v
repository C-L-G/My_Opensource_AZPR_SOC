/*
 -- ============================================================================
 -- FILE NAME	: uart_tx.v
 -- DESCRIPTION : UART���M���W���[��
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
module uart_tx (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,		 // �N���b�N
	input  wire				   reset,	 // �񓯊����Z�b�g
	/********** ����M�� **********/
	input  wire				   tx_start, // ���M�J�n�M��
	input  wire [`ByteDataBus] tx_data,	 // ���M�f�[�^
	output wire				   tx_busy,	 // ���M���t���O
	output reg				   tx_end,	 // ���M�����M��
	/********** UART���M�M�� **********/
	output reg				   tx		 // UART���M�M��
);

	/********** �����M�� **********/
	reg [`UartStateBus]		   state;	 // �X�e�[�g
	reg [`UartDivCntBus]	   div_cnt;	 // �����J�E���^
	reg [`UartBitCntBus]	   bit_cnt;	 // �r�b�g�J�E���^
	reg [`ByteDataBus]		   sh_reg;	 // ���M�p�V�t�g���W�X�^

	/********** ���M���t���O�̐��� **********/
	assign tx_busy = (state == `UART_STATE_TX) ? `ENABLE : `DISABLE;

	/********** ���M�_�� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			state	<= #1 `UART_STATE_IDLE;
			div_cnt <= #1 `UART_DIV_RATE;
			bit_cnt <= #1 `UART_BIT_CNT_START;
			sh_reg	<= #1 `BYTE_DATA_W'h0;
			tx_end	<= #1 `DISABLE;
			tx		<= #1 `UART_STOP_BIT;
		end else begin
			/* ���M�X�e�[�g */
			case (state)
				`UART_STATE_IDLE : begin // �A�C�h�����
					if (tx_start == `ENABLE) begin // ���M�J�n
						state	<= #1 `UART_STATE_TX;
						sh_reg	<= #1 tx_data;
						tx		<= #1 `UART_START_BIT;
					end
					tx_end	<= #1 `DISABLE;
				end
				`UART_STATE_TX	 : begin // ���M��
					/* �N���b�N�����ɂ��{�[���[�g���� */
					if (div_cnt == {`UART_DIV_CNT_W{1'b0}}) begin // ����
						/* ���f�[�^�̑��M */
						case (bit_cnt)
							`UART_BIT_CNT_MSB  : begin // �X�g�b�v�r�b�g�̑��M
								bit_cnt <= #1 `UART_BIT_CNT_STOP;
								tx		<= #1 `UART_STOP_BIT;
							end
							`UART_BIT_CNT_STOP : begin // ���M����
								state	<= #1 `UART_STATE_IDLE;
								bit_cnt <= #1 `UART_BIT_CNT_START;
								tx_end	<= #1 `ENABLE;
							end
							default			   : begin // �f�[�^�̑��M
								bit_cnt <= #1 bit_cnt + 1'b1;
								sh_reg	<= #1 sh_reg >> 1'b1;
								tx		<= #1 sh_reg[`LSB];
							end
						endcase
						div_cnt <= #1 `UART_DIV_RATE;
					end else begin // �J�E���g�_�E��
						div_cnt <= #1 div_cnt - 1'b1 ;
					end
				end
			endcase
		end
	end

endmodule
