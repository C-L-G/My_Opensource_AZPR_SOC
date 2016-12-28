/* 
 -- ============================================================================
 -- FILE NAME	: id_reg.v
 -- DESCRIPTION : ID�X�e�[�W�p�C�v���C�����W�X�^
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
module id_reg (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,			   // �N���b�N
	input  wire				   reset,		   // �񓯊����Z�b�g
	/********** �f�R�[�h���� **********/
	input  wire [`AluOpBus]	   alu_op,		   // ALU�I�y���[�V����
	input  wire [`WordDataBus] alu_in_0,	   // ALU���� 0
	input  wire [`WordDataBus] alu_in_1,	   // ALU���� 1
	input  wire				   br_flag,		   // ����t���O
	input  wire [`MemOpBus]	   mem_op,		   // �������I�y���[�V����
	input  wire [`WordDataBus] mem_wr_data,	   // �������������݃f�[�^
	input  wire [`CtrlOpBus]   ctrl_op,		   // ����I�y���[�V����
	input  wire [`RegAddrBus]  dst_addr,	   // �ėp���W�X�^�������݃A�h���X
	input  wire				   gpr_we_,		   // �ėp���W�X�^�������ݗL��
	input  wire [`IsaExpBus]   exp_code,	   // ��O�R�[�h
	/********** �p�C�v���C������M�� **********/
	input  wire				   stall,		   // �X�g�[��
	input  wire				   flush,		   // �t���b�V��
	/********** IF/ID�p�C�v���C�����W�X�^ **********/
	input  wire [`WordAddrBus] if_pc,		   // �v���O�����J�E���^
	input  wire				   if_en,		   // �p�C�v���C���f�[�^�̗L��
	/********** ID/EX�p�C�v���C�����W�X�^ **********/
	output reg	[`WordAddrBus] id_pc,		   // �v���O�����J�E���^
	output reg				   id_en,		   // �p�C�v���C���f�[�^�̗L��
	output reg	[`AluOpBus]	   id_alu_op,	   // ALU�I�y���[�V����
	output reg	[`WordDataBus] id_alu_in_0,	   // ALU���� 0
	output reg	[`WordDataBus] id_alu_in_1,	   // ALU���� 1
	output reg				   id_br_flag,	   // ����t���O
	output reg	[`MemOpBus]	   id_mem_op,	   // �������I�y���[�V����
	output reg	[`WordDataBus] id_mem_wr_data, // �������������݃f�[�^
	output reg	[`CtrlOpBus]   id_ctrl_op,	   // ����I�y���[�V����
	output reg	[`RegAddrBus]  id_dst_addr,	   // �ėp���W�X�^�������݃A�h���X
	output reg				   id_gpr_we_,	   // �ėp���W�X�^�������ݗL��
	output reg [`IsaExpBus]	   id_exp_code	   // ��O�R�[�h
);

	/********** �p�C�v���C�����W�X�^ **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin 
			/* �񓯊����Z�b�g */
			id_pc		   <= #1 `WORD_ADDR_W'h0;
			id_en		   <= #1 `DISABLE;
			id_alu_op	   <= #1 `ALU_OP_NOP;
			id_alu_in_0	   <= #1 `WORD_DATA_W'h0;
			id_alu_in_1	   <= #1 `WORD_DATA_W'h0;
			id_br_flag	   <= #1 `DISABLE;
			id_mem_op	   <= #1 `MEM_OP_NOP;
			id_mem_wr_data <= #1 `WORD_DATA_W'h0;
			id_ctrl_op	   <= #1 `CTRL_OP_NOP;
			id_dst_addr	   <= #1 `REG_ADDR_W'd0;
			id_gpr_we_	   <= #1 `DISABLE_;
			id_exp_code	   <= #1 `ISA_EXP_NO_EXP;
		end else begin
			/* �p�C�v���C�����W�X�^�̍X�V */
			if (stall == `DISABLE) begin 
				if (flush == `ENABLE) begin // �t���b�V��
				   id_pc		  <= #1 `WORD_ADDR_W'h0;
				   id_en		  <= #1 `DISABLE;
				   id_alu_op	  <= #1 `ALU_OP_NOP;
				   id_alu_in_0	  <= #1 `WORD_DATA_W'h0;
				   id_alu_in_1	  <= #1 `WORD_DATA_W'h0;
				   id_br_flag	  <= #1 `DISABLE;
				   id_mem_op	  <= #1 `MEM_OP_NOP;
				   id_mem_wr_data <= #1 `WORD_DATA_W'h0;
				   id_ctrl_op	  <= #1 `CTRL_OP_NOP;
				   id_dst_addr	  <= #1 `REG_ADDR_W'd0;
				   id_gpr_we_	  <= #1 `DISABLE_;
				   id_exp_code	  <= #1 `ISA_EXP_NO_EXP;
				end else begin				// ���̃f�[�^
				   id_pc		  <= #1 if_pc;
				   id_en		  <= #1 if_en;
				   id_alu_op	  <= #1 alu_op;
				   id_alu_in_0	  <= #1 alu_in_0;
				   id_alu_in_1	  <= #1 alu_in_1;
				   id_br_flag	  <= #1 br_flag;
				   id_mem_op	  <= #1 mem_op;
				   id_mem_wr_data <= #1 mem_wr_data;
				   id_ctrl_op	  <= #1 ctrl_op;
				   id_dst_addr	  <= #1 dst_addr;
				   id_gpr_we_	  <= #1 gpr_we_;
				   id_exp_code	  <= #1 exp_code;
				end
			end
		end
	end

endmodule
