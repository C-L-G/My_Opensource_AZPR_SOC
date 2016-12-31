/*
 -- ============================================================================
 -- FILE NAME	: x_s3e_sprom.v
 -- DESCRIPTION : Xilinx Spartan-3E Single Port ROM �^�����f��
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
`include "rom.h"

/********** ���W���[�� **********/
module x_s3e_sprom (
	input wire				  clka,	 // �N���b�N
	input wire [`RomAddrBus]  addra, // �A�h���X
	output reg [`WordDataBus] douta	 // �ǂݏo���f�[�^
);

	/********** ������ **********/
	reg [`WordDataBus] mem [0:`ROM_DEPTH-1];

	/********** �ǂݏo���A�N�Z�X **********/
	always @(posedge clka) begin
		douta <= #1 mem[addra];
	end

endmodule
