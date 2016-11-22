/*
 -- ============================================================================
 -- FILE NAME	: uart_ctrl.v
 -- DESCRIPTION : UART���䃂�W���[��
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
module uart_ctrl (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,		 // �N���b�N
	input  wire				   reset,	 // �񓯊����Z�b�g
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire				   cs_,		 // �`�b�v�Z���N�g
	input  wire				   as_,		 // �A�h���X�X�g���[�u
	input  wire				   rw,		 // Read / Write
	input  wire [`UartAddrBus] addr,	 // �A�h���X
	input  wire [`WordDataBus] wr_data,	 // �������݃f�[�^
	output reg	[`WordDataBus] rd_data,	 // �ǂݏo���f�[�^
	output reg				   rdy_,	 // ���f�B
	/********** ���荞�� **********/
	output reg				   irq_rx,	 // ��M�������荞�݁i���䃌�W�X�^ 0�j
	output reg				   irq_tx,	 // ���M�������荞�݁i���䃌�W�X�^ 0�j
	/********** ����M�� **********/
	// ��M����
	input  wire				   rx_busy,	 // ��M���t���O�i���䃌�W�X�^ 0�j
	input  wire				   rx_end,	 // ��M�����M��
	input  wire [`ByteDataBus] rx_data,	 // ��M�f�[�^
	// ���M����
	input  wire				   tx_busy,	 // ���M���t���O�i���䃌�W�X�^ 0�j
	input  wire				   tx_end,	 // ���M�����M��
	output reg				   tx_start, // ���M�J�n�M��
	output reg	[`ByteDataBus] tx_data	 // ���M�f�[�^
);

	/********** ���䃌�W�c�^ **********/
	// ���䃌�W�X�^ 1 : ����M�f�[�^
	reg [`ByteDataBus]		   rx_buf;	 // ��M�o�b�t�@

	/********** UART����_�� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			rd_data	 <= #1 `WORD_DATA_W'h0;
			rdy_	 <= #1 `DISABLE_;
			irq_rx	 <= #1 `DISABLE;
			irq_tx	 <= #1 `DISABLE;
			rx_buf	 <= #1 `BYTE_DATA_W'h0;
			tx_start <= #1 `DISABLE;
			tx_data	 <= #1 `BYTE_DATA_W'h0;
	   end else begin
			/* ���f�B�̐��� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_	 <= #1 `ENABLE_;
			end else begin
				rdy_	 <= #1 `DISABLE_;
			end
			/* �ǂݏo���A�N�Z�X */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
				case (addr)
					`UART_ADDR_STATUS	 : begin // ���䃌�W�X�^ 0
						rd_data	 <= #1 {{`WORD_DATA_W-4{1'b0}}, 
										tx_busy, rx_busy, irq_tx, irq_rx};
					end
					`UART_ADDR_DATA		 : begin // ���䃌�W�X�^ 1
						rd_data	 <= #1 {{`BYTE_DATA_W*2{1'b0}}, rx_buf};
					end
				endcase
			end else begin
				rd_data	 <= #1 `WORD_DATA_W'h0;
			end
			/* �������݃A�N�Z�X */
			// ���䃌�W�X�^ 0 : ���M�������荞��
			if (tx_end == `ENABLE) begin
				irq_tx<= #1 `ENABLE;
			end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
						 (rw == `WRITE) && (addr == `UART_ADDR_STATUS)) begin
				irq_tx<= #1 wr_data[`UartCtrlIrqTx];
			end
			// ���䃌�W�X�^ 0 : ��M�������荞��
			if (rx_end == `ENABLE) begin
				irq_rx<= #1 `ENABLE;
			end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
						 (rw == `WRITE) && (addr == `UART_ADDR_STATUS)) begin
				irq_rx<= #1 wr_data[`UartCtrlIrqRx];
			end
			// ���䃌�W�X�^ 1
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `UART_ADDR_DATA)) begin // ���M�J�n
				tx_start <= #1 `ENABLE;
				tx_data	 <= #1 wr_data[`BYTE_MSB:`LSB];
			end else begin
				tx_start <= #1 `DISABLE;
				tx_data	 <= #1 `BYTE_DATA_W'h0;
			end
			/* ��M�f�[�^�̎�荞�� */
			if (rx_end == `ENABLE) begin
				rx_buf	 <= #1 rx_data;
			end
		end
	end

endmodule
