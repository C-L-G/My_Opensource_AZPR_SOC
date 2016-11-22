/*
 -- ============================================================================
 -- FILE NAME	: uart.v
 -- DESCRIPTION : Universal Asynchronous Receiver and Transmitter
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
module uart (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,		 // �N���b�N
	input  wire				   reset,	 // �񓯊����Z�b�g
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire				   cs_,		 // �`�b�v�Z���N�g
	input  wire				   as_,		 // �A�h���X�X�g���[�u
	input  wire				   rw,		 // Read / Write
	input  wire [`UartAddrBus] addr,	 // �A�h���X
	input  wire [`WordDataBus] wr_data,	 // �������݃f�[�^
	output wire [`WordDataBus] rd_data,	 // �ǂݏo���f�[�^
	output wire				   rdy_,	 // ���f�B
	/********** ���荞�� **********/
	output wire				   irq_rx,	 // ��M�������荞��
	output wire				   irq_tx,	 // ���M�������荞��
	/********** UART����M�M��	**********/
	input  wire				   rx,		 // UART��M�M��
	output wire				   tx		 // UART���M�M��
);

	/********** ����M�� **********/
	// ��M����
	wire					   rx_busy;	 // ��M���t���O
	wire					   rx_end;	 // ��M�����M��
	wire [`ByteDataBus]		   rx_data;	 // ��M�f�[�^
	// ���M����
	wire					   tx_busy;	 // ���M���t���O
	wire					   tx_end;	 // ���M�����M��
	wire					   tx_start; // ���M�J�n�M��
	wire [`ByteDataBus]		   tx_data;	 // ���M�f�[�^

	/********** UART���䃂�W���[�� **********/
	uart_ctrl uart_ctrl (
		/********** �N���b�N & ���Z�b�g **********/
		.clk	  (clk),	   // �N���b�N
		.reset	  (reset),	   // �񓯊����Z�b�g
		/********** Host Interface **********/
		.cs_	  (cs_),	   // �`�b�v�Z���N�g
		.as_	  (as_),	   // �A�h���X�X�g���[�u
		.rw		  (rw),		   // Read / Write
		.addr	  (addr),	   // �A�h���X
		.wr_data  (wr_data),   // �������݃f�[�^
		.rd_data  (rd_data),   // �ǂݏo���f�[�^
		.rdy_	  (rdy_),	   // ���f�B
		/********** Interrupt  **********/
		.irq_rx	  (irq_rx),	   // ��M�������荞��
		.irq_tx	  (irq_tx),	   // ���M�������荞��
		/********** ����M�� **********/
		// ��M����
		.rx_busy  (rx_busy),   // ��M���t���O
		.rx_end	  (rx_end),	   // ��M�����M��
		.rx_data  (rx_data),   // ��M�f�[�^
		// ���M����
		.tx_busy  (tx_busy),   // ���M���t���O
		.tx_end	  (tx_end),	   // ���M�����M��
		.tx_start (tx_start),  // ���M�J�n�M��
		.tx_data  (tx_data)	   // ���M�f�[�^
	);

	/********** UART���M���W���[�� **********/
	uart_tx uart_tx (
		/********** �N���b�N & ���Z�b�g **********/
		.clk	  (clk),	   // �N���b�N
		.reset	  (reset),	   // �񓯊����Z�b�g
		/********** ����M�� **********/
		.tx_start (tx_start),  // ���M�J�n�M��
		.tx_data  (tx_data),   // ���M�f�[�^
		.tx_busy  (tx_busy),   // ���M���t���O
		.tx_end	  (tx_end),	   // ���M�����M��
		/********** Transmit Signal **********/
		.tx		  (tx)		   // UART���M�M��
	);

	/********** UART��M���W���[�� **********/
	uart_rx uart_rx (
		/********** �N���b�N & ���Z�b�g **********/
		.clk	  (clk),	   // �N���b�N
		.reset	  (reset),	   // �񓯊����Z�b�g
		/********** ����M�� **********/
		.rx_busy  (rx_busy),   // ��M���t���O
		.rx_end	  (rx_end),	   // ��M�����M��
		.rx_data  (rx_data),   // ��M�f�[�^
		/********** Receive Signal **********/
		.rx		  (rx)		   // UART��M�M��
	);

endmodule
