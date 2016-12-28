/*
 -- ============================================================================
 -- FILE NAME	: mem_reg.v
 -- DESCRIPTION : MEM�X�e�[�W�p�C�v���C�����W�X�^
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

/********** ���ʃw�b�_�t�@�C�� **********/
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

/********** �ʃw�b�_�t�@�C�� **********/
`include "isa.h"
`include "cpu.h"

/********** ���W���[�� **********/
module mem_reg (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,			 // �N���b�N
	input  wire				   reset,		 // �񓯊����Z�b�g
	/********** �������A�N�Z�X���� **********/
	input  wire [`WordDataBus] out,			 // �������A�N�Z�X����
	input  wire				   miss_align,	 // �~�X�A���C��
	/********** �p�C�v���C������M�� **********/
	input  wire				   stall,		 // �X�g�[��
	input  wire				   flush,		 // �t���b�V��
	/********** EX/MEM�p�C�v���C�����W�X�^ **********/
	input  wire [`WordAddrBus] ex_pc,		 // �v���O�����J�E���^
	input  wire				   ex_en,		 // �p�C�v���C���f�[�^�̗L��
	input  wire				   ex_br_flag,	 // ����t���O
	input  wire [`CtrlOpBus]   ex_ctrl_op,	 // ���䃌�W�X�^�I�y���[�V����
	input  wire [`RegAddrBus]  ex_dst_addr,	 // �ėp���W�X�^�������݃A�h���X
	input  wire				   ex_gpr_we_,	 // �ėp���W�X�^�������ݗL��
	input  wire [`IsaExpBus]   ex_exp_code,	 // ��O�R�[�h
	/********** MEM/WB�p�C�v���C�����W�X�^ **********/
	output reg	[`WordAddrBus] mem_pc,		 // �v���O�����J�E���^
	output reg				   mem_en,		 // �p�C�v���C���f�[�^�̗L��
	output reg				   mem_br_flag,	 // ����t���O
	output reg	[`CtrlOpBus]   mem_ctrl_op,	 // ���䃌�W�X�^�I�y���[�V����
	output reg	[`RegAddrBus]  mem_dst_addr, // �ėp���W�X�^�������݃A�h���X
	output reg				   mem_gpr_we_,	 // �ėp���W�X�^�������ݗL��
	output reg	[`IsaExpBus]   mem_exp_code, // ��O�R�[�h
	output reg	[`WordDataBus] mem_out		 // ��������
);

	/********** �p�C�v���C�����W�X�^ **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin	 
			/* �񓯊����Z�b�g */
			mem_pc		 <= #1 `WORD_ADDR_W'h0;
			mem_en		 <= #1 `DISABLE;
			mem_br_flag	 <= #1 `DISABLE;
			mem_ctrl_op	 <= #1 `CTRL_OP_NOP;
			mem_dst_addr <= #1 `REG_ADDR_W'h0;
			mem_gpr_we_	 <= #1 `DISABLE_;
			mem_exp_code <= #1 `ISA_EXP_NO_EXP;
			mem_out		 <= #1 `WORD_DATA_W'h0;
		end else begin
			if (stall == `DISABLE) begin 
				/* �p�C�v���C�����W�X�^�̍X�V */
				if (flush == `ENABLE) begin				  // �t���b�V��
					mem_pc		 <= #1 `WORD_ADDR_W'h0;
					mem_en		 <= #1 `DISABLE;
					mem_br_flag	 <= #1 `DISABLE;
					mem_ctrl_op	 <= #1 `CTRL_OP_NOP;
					mem_dst_addr <= #1 `REG_ADDR_W'h0;
					mem_gpr_we_	 <= #1 `DISABLE_;
					mem_exp_code <= #1 `ISA_EXP_NO_EXP;
					mem_out		 <= #1 `WORD_DATA_W'h0;
				end else if (miss_align == `ENABLE) begin // �~�X�A���C����O
					mem_pc		 <= #1 ex_pc;
					mem_en		 <= #1 ex_en;
					mem_br_flag	 <= #1 ex_br_flag;
					mem_ctrl_op	 <= #1 `CTRL_OP_NOP;
					mem_dst_addr <= #1 `REG_ADDR_W'h0;
					mem_gpr_we_	 <= #1 `DISABLE_;
					mem_exp_code <= #1 `ISA_EXP_MISS_ALIGN;
					mem_out		 <= #1 `WORD_DATA_W'h0;
				end else begin							  // ���̃f�[�^
					mem_pc		 <= #1 ex_pc;
					mem_en		 <= #1 ex_en;
					mem_br_flag	 <= #1 ex_br_flag;
					mem_ctrl_op	 <= #1 ex_ctrl_op;
					mem_dst_addr <= #1 ex_dst_addr;
					mem_gpr_we_	 <= #1 ex_gpr_we_;
					mem_exp_code <= #1 ex_exp_code;
					mem_out		 <= #1 out;
				end
			end
		end
	end

endmodule
