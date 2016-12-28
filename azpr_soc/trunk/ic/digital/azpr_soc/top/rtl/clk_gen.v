/* 
 -- ============================================================================
 -- FILE NAME	: clk_gen.v
 -- DESCRIPTION : �N���b�N�������W���[��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

/********** ���ʃw�b�_�t�@�C�� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** ���W���[�� **********/
module clk_gen (
	/********** �N���b�N & ���Z�b�g **********/
	input wire	clk_ref,   // ���N���b�N
	input wire	reset_sw,  // ���Z�b�g�X�C�b�`
	/********** �����N���b�N **********/
	output wire clk,	   // �N���b�N
	output wire clk_,	   // ���]�N���b�N
	/********** �`�b�v���Z�b�g **********/
	output wire chip_reset // �`�b�v���Z�b�g
);

	/********** �����M�� **********/
	wire		locked;	   // ���b�N
	wire		dcm_reset; // ���Z�b�g

	/********** ���Z�b�g�̐��� **********/
	// DCM���Z�b�g
	assign dcm_reset  = (reset_sw == `RESET_ENABLE) ? `ENABLE : `DISABLE;
	// �`�b�v���Z�b�g
	assign chip_reset = ((reset_sw == `RESET_ENABLE) || (locked == `DISABLE)) ?
							`RESET_ENABLE : `RESET_DISABLE;

	/********** Xilinx DCM (Digitl Clock Manager) **********/
	x_s3e_dcm x_s3e_dcm (
		.CLKIN_IN		 (clk_ref),	  // ���N���b�N
		.RST_IN			 (dcm_reset), // DCM���Z�b�g
		.CLK0_OUT		 (clk),		  // �N���b�N
		.CLK180_OUT		 (clk_),	  // ���]�N���b�N
		.LOCKED_OUT		 (locked)	  // ���b�N
   );

endmodule
