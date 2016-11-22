/*
 -- ============================================================================
 -- FILE NAME	: ex_stage.v
 -- DESCRIPTION : EX�X�e�[�W
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
module ex_stage (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,			   // �N���b�N
	input  wire				   reset,		   // �񓯊����Z�b�g
	/********** �p�C�v���C������M�� **********/
	input  wire				   stall,		   // �X�g�[��
	input  wire				   flush,		   // �t���b�V��
	input  wire				   int_detect,	   // ���荞�݌��o
	/********** �t�H���[�f�B���O **********/
	output wire [`WordDataBus] fwd_data,	   // �t�H���[�f�B���O�f�[�^
	/********** ID/EX�p�C�v���C�����W�X�^ **********/
	input  wire [`WordAddrBus] id_pc,		   // �v���O�����J�E���^
	input  wire				   id_en,		   // �p�C�v���C���f�[�^�̗L��
	input  wire [`AluOpBus]	   id_alu_op,	   // ALU�I�y���[�V����
	input  wire [`WordDataBus] id_alu_in_0,	   // ALU���� 0
	input  wire [`WordDataBus] id_alu_in_1,	   // ALU���� 1
	input  wire				   id_br_flag,	   // ����t���O
	input  wire [`MemOpBus]	   id_mem_op,	   // �������I�y���[�V����
	input  wire [`WordDataBus] id_mem_wr_data, // �������������݃f�[�^
	input  wire [`CtrlOpBus]   id_ctrl_op,	   // ���䃌�W�X�^�I�y���[�V����
	input  wire [`RegAddrBus]  id_dst_addr,	   // �ėp���W�X�^�������݃A�h���X
	input  wire				   id_gpr_we_,	   // �ėp���W�X�^�������ݗL��
	input  wire [`IsaExpBus]   id_exp_code,	   // ��O�R�[�h
	/********** EX/MEM�p�C�v���C�����W�X�^ **********/
	output wire [`WordAddrBus] ex_pc,		   // �v���O�����J�E���^
	output wire				   ex_en,		   // �p�C�v���C���f�[�^�̗L��
	output wire				   ex_br_flag,	   // ����t���O
	output wire [`MemOpBus]	   ex_mem_op,	   // �������I�y���[�V����
	output wire [`WordDataBus] ex_mem_wr_data, // �������������݃f�[�^
	output wire [`CtrlOpBus]   ex_ctrl_op,	   // ���䃌�W�X�^�I�y���[�V����
	output wire [`RegAddrBus]  ex_dst_addr,	   // �ėp���W�X�^�������݃A�h���X
	output wire				   ex_gpr_we_,	   // �ėp���W�X�^�������ݗL��
	output wire [`IsaExpBus]   ex_exp_code,	   // ��O�R�[�h
	output wire [`WordDataBus] ex_out		   // ��������
);

	/********** ALU�̏o�� **********/
	wire [`WordDataBus]		   alu_out;		   // ���Z����
	wire					   alu_of;		   // �I�[�o�t���[

	/********** ���Z���ʂ̃t�H���[�f�B���O **********/
	assign fwd_data = alu_out;

	/********** ALU **********/
	alu alu (
		.in_0			(id_alu_in_0),	  // ���� 0
		.in_1			(id_alu_in_1),	  // ���� 1
		.op				(id_alu_op),	  // �I�y���[�V����
		.out			(alu_out),		  // �o��
		.of				(alu_of)		  // �I�[�o�t���[
	);

	/********** �p�C�v���C�����W�X�^ **********/
	ex_reg ex_reg (
		/********** �N���b�N & ���Z�b�g **********/
		.clk			(clk),			  // �N���b�N
		.reset			(reset),		  // �񓯊����Z�b�g
		/********** ALU�̏o�� **********/
		.alu_out		(alu_out),		  // ���Z����
		.alu_of			(alu_of),		  // �I�[�o�t���[
		/********** �p�C�v���C������M�� **********/
		.stall			(stall),		  // �X�g�[��
		.flush			(flush),		  // �t���b�V��
		.int_detect		(int_detect),	  // ���荞�݌��o
		/********** ID/EX�p�C�v���C�����W�X�^ **********/
		.id_pc			(id_pc),		  // �v���O�����J�E���^
		.id_en			(id_en),		  // �p�C�v���C���f�[�^�̗L��
		.id_br_flag		(id_br_flag),	  // ����t���O
		.id_mem_op		(id_mem_op),	  // �������I�y���[�V����
		.id_mem_wr_data (id_mem_wr_data), // �������������݃f�[�^
		.id_ctrl_op		(id_ctrl_op),	  // ���䃌�W�X�^�I�y���[�V����
		.id_dst_addr	(id_dst_addr),	  // �ėp���W�X�^�������݃A�h���X
		.id_gpr_we_		(id_gpr_we_),	  // �ėp���W�X�^�������ݗL��
		.id_exp_code	(id_exp_code),	  // ��O�R�[�h
		/********** EX/MEM�p�C�v���C�����W�X�^ **********/
		.ex_pc			(ex_pc),		  // �v���O�����J�E���^
		.ex_en			(ex_en),		  // �p�C�v���C���f�[�^�̗L��
		.ex_br_flag		(ex_br_flag),	  // ����t���O
		.ex_mem_op		(ex_mem_op),	  // �������I�y���[�V����
		.ex_mem_wr_data (ex_mem_wr_data), // �������������݃f�[�^
		.ex_ctrl_op		(ex_ctrl_op),	  // ���䃌�W�X�^�I�y���[�V����
		.ex_dst_addr	(ex_dst_addr),	  // �ėp���W�X�^�������݃A�h���X
		.ex_gpr_we_		(ex_gpr_we_),	  // �ėp���W�X�^�������ݗL��
		.ex_exp_code	(ex_exp_code),	  // ��O�R�[�h
		.ex_out			(ex_out)		  // ��������
	);

endmodule
