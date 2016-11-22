/*
 -- ============================================================================
 -- FILE NAME	: ex_reg.v
 -- DESCRIPTION : EX�X�e�[�W�p�C�v���C�����W�X�^
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
module ex_reg (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,			   // �N���b�N
	input  wire				   reset,		   // �񓯊����Z�b�g
	/********** ALU�̏o�� **********/
	input  wire [`WordDataBus] alu_out,		   // ���Z����
	input  wire				   alu_of,		   // �I�[�o�t���[
	/********** �p�C�v���C������M�� **********/
	input  wire				   stall,		   // �X�g�[��
	input  wire				   flush,		   // �t���b�V��
	input  wire				   int_detect,	   // ���荞�݌��o
	/********** ID/EX�p�C�v���C�����W�X�^ **********/
	input  wire [`WordAddrBus] id_pc,		   // �v���O�����J�E���^
	input  wire				   id_en,		   // �p�C�v���C���f�[�^�̗L��
	input  wire				   id_br_flag,	   // ����t���O
	input  wire [`MemOpBus]	   id_mem_op,	   // �������I�y���[�V����
	input  wire [`WordDataBus] id_mem_wr_data, // �������������݃f�[�^
	input  wire [`CtrlOpBus]   id_ctrl_op,	   // ���䃌�W�X�^�I�y���[�V����
	input  wire [`RegAddrBus]  id_dst_addr,	   // �ėp���W�X�^�������݃A�h���X
	input  wire				   id_gpr_we_,	   // �ėp���W�X�^�������ݗL��
	input  wire [`IsaExpBus]   id_exp_code,	   // ��O�R�[�h
	/********** EX/MEM�p�C�v���C�����W�X�^ **********/
	output reg	[`WordAddrBus] ex_pc,		   // �v���O�����J�E���^
	output reg				   ex_en,		   // �p�C�v���C���f�[�^�̗L��
	output reg				   ex_br_flag,	   // ����t���O
	output reg	[`MemOpBus]	   ex_mem_op,	   // �������I�y���[�V����
	output reg	[`WordDataBus] ex_mem_wr_data, // �������������݃f�[�^
	output reg	[`CtrlOpBus]   ex_ctrl_op,	   // ���䃌�W�X�^�I�y���[�V����
	output reg	[`RegAddrBus]  ex_dst_addr,	   // �ėp���W�X�^�������݃A�h���X
	output reg				   ex_gpr_we_,	   // �ėp���W�X�^�������ݗL��
	output reg	[`IsaExpBus]   ex_exp_code,	   // ��O�R�[�h
	output reg	[`WordDataBus] ex_out		   // ��������
);

	/********** �p�C�v���C�����W�X�^ **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		/* �񓯊����Z�b�g */
		if (reset == `RESET_ENABLE) begin 
			ex_pc		   <= #1 `WORD_ADDR_W'h0;
			ex_en		   <= #1 `DISABLE;
			ex_br_flag	   <= #1 `DISABLE;
			ex_mem_op	   <= #1 `MEM_OP_NOP;
			ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
			ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
			ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
			ex_gpr_we_	   <= #1 `DISABLE_;
			ex_exp_code	   <= #1 `ISA_EXP_NO_EXP;
			ex_out		   <= #1 `WORD_DATA_W'h0;
		end else begin
			/* �p�C�v���C�����W�X�^�̍X�V */
			if (stall == `DISABLE) begin 
				if (flush == `ENABLE) begin				  // �t���b�V��
					ex_pc		   <= #1 `WORD_ADDR_W'h0;
					ex_en		   <= #1 `DISABLE;
					ex_br_flag	   <= #1 `DISABLE;
					ex_mem_op	   <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
					ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_	   <= #1 `DISABLE_;
					ex_exp_code	   <= #1 `ISA_EXP_NO_EXP;
					ex_out		   <= #1 `WORD_DATA_W'h0;
				end else if (int_detect == `ENABLE) begin // ���荞�݂̌��o
					ex_pc		   <= #1 id_pc;
					ex_en		   <= #1 id_en;
					ex_br_flag	   <= #1 id_br_flag;
					ex_mem_op	   <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
					ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_	   <= #1 `DISABLE_;
					ex_exp_code	   <= #1 `ISA_EXP_EXT_INT;
					ex_out		   <= #1 `WORD_DATA_W'h0;
				end else if (alu_of == `ENABLE) begin	  // �Z�p�I�[�o�t���[
					ex_pc		   <= #1 id_pc;
					ex_en		   <= #1 id_en;
					ex_br_flag	   <= #1 id_br_flag;
					ex_mem_op	   <= #1 `MEM_OP_NOP;
					ex_mem_wr_data <= #1 `WORD_DATA_W'h0;
					ex_ctrl_op	   <= #1 `CTRL_OP_NOP;
					ex_dst_addr	   <= #1 `REG_ADDR_W'd0;
					ex_gpr_we_	   <= #1 `DISABLE_;
					ex_exp_code	   <= #1 `ISA_EXP_OVERFLOW;
					ex_out		   <= #1 `WORD_DATA_W'h0;
				end else begin							  // ���̃f�[�^
					ex_pc		   <= #1 id_pc;
					ex_en		   <= #1 id_en;
					ex_br_flag	   <= #1 id_br_flag;
					ex_mem_op	   <= #1 id_mem_op;
					ex_mem_wr_data <= #1 id_mem_wr_data;
					ex_ctrl_op	   <= #1 id_ctrl_op;
					ex_dst_addr	   <= #1 id_dst_addr;
					ex_gpr_we_	   <= #1 id_gpr_we_;
					ex_exp_code	   <= #1 id_exp_code;
					ex_out		   <= #1 alu_out;
				end
			end
		end
	end

endmodule
