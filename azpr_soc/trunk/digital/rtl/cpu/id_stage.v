/*
 -- ============================================================================
 -- FILE NAME	: id_stage.v
 -- DESCRIPTION : ID�X�e�[�W
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
module id_stage (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire					 clk,			 // �N���b�N
	input  wire					 reset,			 // �񓯊����Z�b�g
	/********** GPR�C���^�t�F�[�X **********/
	input  wire [`WordDataBus]	 gpr_rd_data_0,	 // �ǂݏo���f�[�^ 0
	input  wire [`WordDataBus]	 gpr_rd_data_1,	 // �ǂݏo���f�[�^ 1
	output wire [`RegAddrBus]	 gpr_rd_addr_0,	 // �ǂݏo���A�h���X 0
	output wire [`RegAddrBus]	 gpr_rd_addr_1,	 // �ǂݏo���A�h���X 1
	/********** �t�H���[�f�B���O **********/
	// EX�X�e�[�W����̃t�H���[�f�B���O
	input  wire					 ex_en,			// �p�C�v���C���f�[�^�̗L��
	input  wire [`WordDataBus]	 ex_fwd_data,	 // �t�H���[�f�B���O�f�[�^
	input  wire [`RegAddrBus]	 ex_dst_addr,	 // �������݃A�h���X
	input  wire					 ex_gpr_we_,	 // �������ݗL��
	// MEM�X�e�[�W����̃t�H���[�f�B���O
	input  wire [`WordDataBus]	 mem_fwd_data,	 // �t�H���[�f�B���O�f�[�^
	/********** ���䃌�W�X�^�C���^�t�F�[�X **********/
	input  wire [`CpuExeModeBus] exe_mode,		 // ���s���[�h
	input  wire [`WordDataBus]	 creg_rd_data,	 // �ǂݏo���f�[�^
	output wire [`RegAddrBus]	 creg_rd_addr,	 // �ǂݏo���A�h���X
	/********** �p�C�v���C������M�� **********/
	input  wire					 stall,			 // �X�g�[��
	input  wire					 flush,			 // �t���b�V��
	output wire [`WordAddrBus]	 br_addr,		 // ����A�h���X
	output wire					 br_taken,		 // ����̐���
	output wire					 ld_hazard,		 // ���[�h�n�U�[�h
	/********** IF/ID�p�C�v���C�����W�X�^ **********/
	input  wire [`WordAddrBus]	 if_pc,			 // �v���O�����J�E���^
	input  wire [`WordDataBus]	 if_insn,		 // ����
	input  wire					 if_en,			 // �p�C�v���C���f�[�^�̗L��
	/********** ID/EX�p�C�v���C�����W�X�^ **********/
	output wire [`WordAddrBus]	 id_pc,			 // �v���O�����J�E���^
	output wire					 id_en,			 // �p�C�v���C���f�[�^�̗L��
	output wire [`AluOpBus]		 id_alu_op,		 // ALU�I�y���[�V����
	output wire [`WordDataBus]	 id_alu_in_0,	 // ALU���� 0
	output wire [`WordDataBus]	 id_alu_in_1,	 // ALU���� 1
	output wire					 id_br_flag,	 // ����t���O
	output wire [`MemOpBus]		 id_mem_op,		 // �������I�y���[�V����
	output wire [`WordDataBus]	 id_mem_wr_data, // �������������݃f�[�^
	output wire [`CtrlOpBus]	 id_ctrl_op,	 // ����I�y���[�V����
	output wire [`RegAddrBus]	 id_dst_addr,	 // GPR�������݃A�h���X
	output wire					 id_gpr_we_,	 // GPR�������ݗL��
	output wire [`IsaExpBus]	 id_exp_code	 // ��O�R�[�h
);

	/********** �f�R�[�h�M�� **********/
	wire  [`AluOpBus]			 alu_op;		 // ALU�I�y���[�V����
	wire  [`WordDataBus]		 alu_in_0;		 // ALU���� 0
	wire  [`WordDataBus]		 alu_in_1;		 // ALU���� 1
	wire						 br_flag;		 // ����t���O
	wire  [`MemOpBus]			 mem_op;		 // �������I�y���[�V����
	wire  [`WordDataBus]		 mem_wr_data;	 // �������������݃f�[�^
	wire  [`CtrlOpBus]			 ctrl_op;		 // ����I�y���[�V����
	wire  [`RegAddrBus]			 dst_addr;		 // GPR�������݃A�h���X
	wire						 gpr_we_;		 // GPR�������ݗL��
	wire  [`IsaExpBus]			 exp_code;		 // ��O�R�[�h

	/********** �f�R�[�_ **********/
	decoder decoder (
		/********** IF/ID�p�C�v���C�����W�X�^ **********/
		.if_pc			(if_pc),		  // �v���O�����J�E���^
		.if_insn		(if_insn),		  // ����
		.if_en			(if_en),		  // �p�C�v���C���f�[�^�̗L��
		/********** GPR�C���^�t�F�[�X **********/
		.gpr_rd_data_0	(gpr_rd_data_0),  // �ǂݏo���f�[�^ 0
		.gpr_rd_data_1	(gpr_rd_data_1),  // �ǂݏo���f�[�^ 1
		.gpr_rd_addr_0	(gpr_rd_addr_0),  // �ǂݏo���A�h���X 0
		.gpr_rd_addr_1	(gpr_rd_addr_1),  // �ǂݏo���A�h���X 1
		/********** �t�H���[�f�B���O **********/
		// ID�X�e�[�W����̃t�H���[�f�B���O
		.id_en			(id_en),		  // �p�C�v���C���f�[�^�̗L��
		.id_dst_addr	(id_dst_addr),	  // �������݃A�h���X
		.id_gpr_we_		(id_gpr_we_),	  // �������ݗL��
		.id_mem_op		(id_mem_op),	  // �������I�y���[�V����
		// EX�X�e�[�W����̃t�H���[�f�B���O
		.ex_en			(ex_en),		  // �p�C�v���C���f�[�^�̗L��
		.ex_fwd_data	(ex_fwd_data),	  // �t�H���[�f�B���O�f�[�^
		.ex_dst_addr	(ex_dst_addr),	  // �������݃A�h���X
		.ex_gpr_we_		(ex_gpr_we_),	  // �������ݗL��
		// MEM�X�e�[�W����̃t�H���[�f�B���O
		.mem_fwd_data	(mem_fwd_data),	  // �t�H���[�f�B���O�f�[�^
		/********** ���䃌�W�X�^�C���^�t�F�[�X **********/
		.exe_mode		(exe_mode),		  // ���s���[�h
		.creg_rd_data	(creg_rd_data),	  // �ǂݏo���f�[�^
		.creg_rd_addr	(creg_rd_addr),	  // �ǂݏo���A�h���X
		/********** �f�R�[�h�M�� **********/
		.alu_op			(alu_op),		  // ALU�I�y���[�V����
		.alu_in_0		(alu_in_0),		  // ALU���� 0
		.alu_in_1		(alu_in_1),		  // ALU���� 1
		.br_addr		(br_addr),		  // ����A�h���X
		.br_taken		(br_taken),		  // ����̐���
		.br_flag		(br_flag),		  // ����t���O
		.mem_op			(mem_op),		  // �������I�y���[�V����
		.mem_wr_data	(mem_wr_data),	  // �������������݃f�[�^
		.ctrl_op		(ctrl_op),		  // ����I�y���[�V����
		.dst_addr		(dst_addr),		  // �ėp���W�X�^�������݃A�h���X
		.gpr_we_		(gpr_we_),		  // �ėp���W�X�^�������ݗL��
		.exp_code		(exp_code),		  // ��O�R�[�h
		.ld_hazard		(ld_hazard)		  // ���[�h�n�U�[�h
	);

	/********** �p�C�v���C�����W�X�^ **********/
	id_reg id_reg (
		/********** �N���b�N & ���Z�b�g **********/
		.clk			(clk),			  // �N���b�N
		.reset			(reset),		  // �񓯊����Z�b�g
		/********** �f�R�[�h���� **********/
		.alu_op			(alu_op),		  // ALU�I�y���[�V����
		.alu_in_0		(alu_in_0),		  // ALU���� 0
		.alu_in_1		(alu_in_1),		  // ALU���� 1
		.br_flag		(br_flag),		  // ����t���O
		.mem_op			(mem_op),		  // �������I�y���[�V����
		.mem_wr_data	(mem_wr_data),	  // �������������݃f�[�^
		.ctrl_op		(ctrl_op),		  // ����I�y���[�V����
		.dst_addr		(dst_addr),		  // �ėp���W�X�^�������݃A�h���X
		.gpr_we_		(gpr_we_),		  // �ėp���W�X�^�������ݗL��
		.exp_code		(exp_code),		  // ��O�R�[�h
		/********** �p�C�v���C������M�� **********/
		.stall			(stall),		  // �X�g�[��
		.flush			(flush),		  // �t���b�V��
		/********** IF/ID�p�C�v���C�����W�X�^ **********/
		.if_pc			(if_pc),		  // �v���O�����J�E���^
		.if_en			(if_en),		  // �p�C�v���C���f�[�^�̗L��
		/********** ID/EX�p�C�v���C�����W�X�^ **********/
		.id_pc			(id_pc),		  // �v���O�����J�E���^
		.id_en			(id_en),		  // �p�C�v���C���f�[�^�̗L��
		.id_alu_op		(id_alu_op),	  // ALU�I�y���[�V����
		.id_alu_in_0	(id_alu_in_0),	  // ALU���� 0
		.id_alu_in_1	(id_alu_in_1),	  // ALU���� 1
		.id_br_flag		(id_br_flag),	  // ����t���O
		.id_mem_op		(id_mem_op),	  // �������I�y���[�V����
		.id_mem_wr_data (id_mem_wr_data), // �������������݃f�[�^
		.id_ctrl_op		(id_ctrl_op),	  // ����I�y���[�V����
		.id_dst_addr	(id_dst_addr),	  // �ėp���W�X�^�������݃A�h���X
		.id_gpr_we_		(id_gpr_we_),	  // �ėp���W�X�^�������ݗL��
		.id_exp_code	(id_exp_code)	  // ��O�R�[�h
	);

endmodule
