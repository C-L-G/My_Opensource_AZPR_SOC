/* 
 -- ============================================================================
 -- FILE NAME	: chip_top.v
 -- DESCRIPTION : �g�b�v���W���[��
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
`include "gpio.h"

/********** ���W���[�� **********/
module chip_top (
	/********** �N���b�N & ���Z�b�g **********/
	input wire				   clk_ref,		  // ���N���b�N
	input wire				   reset_sw		  // �O���[�o�����Z�b�g
	/********** UART **********/
`ifdef IMPLEMENT_UART // UART����
	, input wire			   uart_rx		  // UART��M�M��
	, output wire			   uart_tx		  // UART���M�M��
`endif
	/********** �ėp���o�̓|�[�g **********/
`ifdef IMPLEMENT_GPIO // GPIO����
`ifdef GPIO_IN_CH	 // ���̓|�[�g�̎���
	, input wire [`GPIO_IN_CH-1:0]	 gpio_in  // ���̓|�[�g
`endif
`ifdef GPIO_OUT_CH	 // �o�̓|�[�g�̎���
	, output wire [`GPIO_OUT_CH-1:0] gpio_out // �o�̓|�[�g
`endif
`ifdef GPIO_IO_CH	 // ���o�̓|�[�g�̎���
	, inout wire [`GPIO_IO_CH-1:0]	 gpio_io  // ���o�̓|�[�g
`endif
`endif
);

	/********** �N���b�N & ���Z�b�g **********/
	wire					   clk;			  // �N���b�N
	wire					   clk_;		  // ���]�N���b�N
	wire					   chip_reset;	  // �`�b�v���Z�b�g
   
	/********** �N���b�N���W���[�� **********/
	clk_gen clk_gen (
		/********** �N���b�N & ���Z�b�g **********/
		.clk_ref	  (clk_ref),			  // ���N���b�N
		.reset_sw	  (reset_sw),			  // �O���[�o�����Z�b�g
		/********** �����N���b�N **********/
		.clk		  (clk),				  // �N���b�N
		.clk_		  (clk_),				  // ���]�N���b�N
		/********** �`�b�v���Z�b�g **********/
		.chip_reset	  (chip_reset)			  // �`�b�v���Z�b�g
	);

	/********** �`�b�v **********/
	chip chip (
		/********** �N���b�N & ���Z�b�g **********/
		.clk	  (clk),					  // �N���b�N
		.clk_	  (clk_),					  // ���]�N���b�N
		.reset	  (chip_reset)				  // ���Z�b�g
		/********** UART **********/
`ifdef IMPLEMENT_UART
		, .uart_rx	(uart_rx)				  // UART��M�g�`
		, .uart_tx	(uart_tx)				  // UART���M�g�`
`endif
		/********** �ėp���o�̓|�[�g **********/
`ifdef IMPLEMENT_GPIO
`ifdef GPIO_IN_CH  // ���̓|�[�g�̎���
		, .gpio_in (gpio_in)				  // ���̓|�[�g
`endif
`ifdef GPIO_OUT_CH // �o�̓|�[�g�̎���
		, .gpio_out (gpio_out)				  // �o�̓|�[�g
`endif
`ifdef GPIO_IO_CH  // ���o�̓|�[�g�̎���
		, .gpio_io	(gpio_io)				  // ���o�̓|�[�g
`endif
`endif
	);

endmodule
