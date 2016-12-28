/*
 -- ============================================================================
 -- FILE NAME	: x_s3e_dpram.v
 -- DESCRIPTION : Xilinx Spartan-3E Dual Port RAM �^�����f��
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
`include "spm.h"

/********** ���W���[�� **********/
module x_s3e_dpram (
	/********** �|�[�g A **********/
	input  wire				   clka,  // �N���b�N
	input  wire [`SpmAddrBus]  addra, // �A�h���X
	input  wire [`WordDataBus] dina,  // �������݃f�[�^
	input  wire				   wea,	  // �������ݗL��
	output reg	[`WordDataBus] douta, // �ǂݏo���f�[�^
	/********** �|�[�g B **********/
	input  wire				   clkb,  // �N���b�N
	input  wire [`SpmAddrBus]  addrb, // �A�h���X
	input  wire [`WordDataBus] dinb,  // �������݃f�[�^
	input  wire				   web,	  // �������ݗL��
	output reg	[`WordDataBus] doutb  // �ǂݏo���f�[�^
);

	/********** ������ **********/
	reg [`WordDataBus] mem [0:`SPM_DEPTH-1];

	/********** �������A�N�Z�X�i�|�[�g A�j **********/
	always @(posedge clka) begin
		// �ǂݏo���A�N�Z�X
		if ((web == `ENABLE) && (addra == addrb)) begin
			douta	  <= #1 dinb;
		end else begin
			douta	  <= #1 mem[addra];
		end
		// �������݃A�N�Z�X
		if (wea == `ENABLE) begin
			mem[addra]<= #1 dina;
		end
	end

	/********** �������A�N�Z�X�i�|�[�g B�j **********/
	always @(posedge clkb) begin
		// �ǂݏo���A�N�Z�X
		if ((wea == `ENABLE) && (addrb == addra)) begin
			doutb	  <= #1 dina;
		end else begin
			doutb	  <= #1 mem[addrb];
		end
		// �������݃A�N�Z�X
		if (web == `ENABLE) begin
			mem[addrb]<= #1 dinb;
		end
	end

endmodule
