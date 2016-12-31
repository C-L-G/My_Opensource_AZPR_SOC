/*
 -- ============================================================================
 -- FILE NAME	: x_s3e_dcm.v
 -- DESCRIPTION : Xilinx Spartan-3E DCM �^�����f��
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

/********** ���ʃw�b�_�t�@�C�� **********/
`include "nettype.h"

/********** ���W���[�� **********/
module x_s3e_dcm (
	input  wire CLKIN_IN,		 // ����N���b�N
	input  wire RST_IN,			 // ���Z�b�g
	output wire CLK0_OUT,		 // �N���b�N�i��0�j
	output wire CLK180_OUT,		 // �N���b�N�i��180�j
	output wire LOCKED_OUT		 // ���b�N
);

	/********** �N���b�N�o�� **********/
	assign CLK0_OUT	  = CLKIN_IN;
	assign CLK180_OUT = ~CLKIN_IN;
	assign LOCKED_OUT = ~RST_IN;
   
endmodule
