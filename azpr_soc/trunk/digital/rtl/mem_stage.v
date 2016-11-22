/*
 -- ============================================================================
 -- FILE NAME	: mem_stage.v
 -- DESCRIPTION : MEM�X�e�[�W
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
module mem_stage (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,			   // �N���b�N
	input  wire				   reset,		   // �񓯊����Z�b�g
	/********** �p�C�v���C������M�� **********/
	input  wire				   stall,		   // �X�g�[��
	input  wire				   flush,		   // �t���b�V��
	output wire				   busy,		   // �r�W�[�M��
	/********** �t�H���[�f�B���O **********/
	output wire [`WordDataBus] fwd_data,	   // �t�H���[�f�B���O�f�[�^
	/********** SPM�C���^�t�F�[�X **********/
	input  wire [`WordDataBus] spm_rd_data,	   // �ǂݏo���f�[�^
	output wire [`WordAddrBus] spm_addr,	   // �A�h���X
	output wire				   spm_as_,		   // �A�h���X�X�g���[�u
	output wire				   spm_rw,		   // �ǂ݁^����
	output wire [`WordDataBus] spm_wr_data,	   // �������݃f�[�^
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire [`WordDataBus] bus_rd_data,	   // �ǂݏo���f�[�^
	input  wire				   bus_rdy_,	   // ���f�B
	input  wire				   bus_grnt_,	   // �o�X�O�����g
	output wire				   bus_req_,	   // �o�X���N�G�X�g
	output wire [`WordAddrBus] bus_addr,	   // �A�h���X
	output wire				   bus_as_,		   // �A�h���X�X�g���[�u
	output wire				   bus_rw,		   // �ǂ݁^����
	output wire [`WordDataBus] bus_wr_data,	   // �������݃f�[�^
	/********** EX/MEM�p�C�v���C�����W�X�^ **********/
	input  wire [`WordAddrBus] ex_pc,		   // �v���O�����J�E���^
	input  wire				   ex_en,		   // �p�C�v���C���f�[�^�̗L��
	input  wire				   ex_br_flag,	   // ����t���O
	input  wire [`MemOpBus]	   ex_mem_op,	   // �������I�y���[�V����
	input  wire [`WordDataBus] ex_mem_wr_data, // �������������݃f�[�^
	input  wire [`CtrlOpBus]   ex_ctrl_op,	   // ���䃌�W�X�^�I�y���[�V����
	input  wire [`RegAddrBus]  ex_dst_addr,	   // �ėp���W�X�^�������݃A�h���X
	input  wire				   ex_gpr_we_,	   // �ėp���W�X�^�������ݗL��
	input  wire [`IsaExpBus]   ex_exp_code,	   // ��O�R�[�h
	input  wire [`WordDataBus] ex_out,		   // ��������
	/********** MEM/WB�p�C�v���C�����W�X�^ **********/
	output wire [`WordAddrBus] mem_pc,		   // �v���O�����J�E���^
	output wire				   mem_en,		   // �p�C�v���C���f�[�^�̗L��
	output wire				   mem_br_flag,	   // ����t���O
	output wire [`CtrlOpBus]   mem_ctrl_op,	   // ���䃌�W�X�^�I�y���[�V����
	output wire [`RegAddrBus]  mem_dst_addr,   // �ėp���W�X�^�������݃A�h���X
	output wire				   mem_gpr_we_,	   // �ėp���W�X�^�������ݗL��
	output wire [`IsaExpBus]   mem_exp_code,   // ��O�R�[�h
	output wire [`WordDataBus] mem_out		   // ��������
);

	/********** �����M�� **********/
	wire [`WordDataBus]		   rd_data;		   // �ǂݏo���f�[�^
	wire [`WordAddrBus]		   addr;		   // �A�h���X
	wire					   as_;			   // �A�h���X�L��
	wire					   rw;			   // �ǂ݁^����
	wire [`WordDataBus]		   wr_data;		   // �������݃f�[�^
	wire [`WordDataBus]		   out;			   // �������A�N�Z�X����
	wire					   miss_align;	   // �~�X�A���C��

	/********** ���ʂ̃t�H���[�f�B���O **********/
	assign fwd_data	 = out;

	/********** �������A�N�Z�X���䃆�j�b�g **********/
	mem_ctrl mem_ctrl (
		/********** EX/MEM�p�C�v���C�����W�X�^ **********/
		.ex_en			(ex_en),			   // �p�C�v���C���f�[�^�̗L��
		.ex_mem_op		(ex_mem_op),		   // �������I�y���[�V����
		.ex_mem_wr_data (ex_mem_wr_data),	   // �������������݃f�[�^
		.ex_out			(ex_out),			   // ��������
		/********** �������A�N�Z�X�C���^�t�F�[�X **********/
		.rd_data		(rd_data),			   // �ǂݏo���f�[�^
		.addr			(addr),				   // �A�h���X
		.as_			(as_),				   // �A�h���X�L��
		.rw				(rw),				   // �ǂ݁^����
		.wr_data		(wr_data),			   // �������݃f�[�^
		/********** �������A�N�Z�X���� **********/
		.out			(out),				   // �������A�N�Z�X����
		.miss_align		(miss_align)		   // �~�X�A���C��
	);

	/********** �o�X�C���^�t�F�[�X **********/
	bus_if bus_if (
		/********** �N���b�N & ���Z�b�g **********/
		.clk		 (clk),					   // �N���b�N
		.reset		 (reset),				   // �񓯊����Z�b�g
		/********** �p�C�v���C������M�� **********/
		.stall		 (stall),				   // �X�g�[��
		.flush		 (flush),				   // �t���b�V���M��
		.busy		 (busy),				   // �r�W�[�M��
		/********** CPU�C���^�t�F�[�X **********/
		.addr		 (addr),				   // �A�h���X
		.as_		 (as_),					   // �A�h���X�L��
		.rw			 (rw),					   // �ǂ݁^����
		.wr_data	 (wr_data),				   // �������݃f�[�^
		.rd_data	 (rd_data),				   // �ǂݏo���f�[�^
		/********** �X�N���b�`�p�b�h�������C���^�t�F�[�X **********/
		.spm_rd_data (spm_rd_data),			   // �ǂݏo���f�[�^
		.spm_addr	 (spm_addr),			   // �A�h���X
		.spm_as_	 (spm_as_),				   // �A�h���X�X�g���[�u
		.spm_rw		 (spm_rw),				   // �ǂ݁^����
		.spm_wr_data (spm_wr_data),			   // �������݃f�[�^
		/********** �o�X�C���^�t�F�[�X **********/
		.bus_rd_data (bus_rd_data),			   // �ǂݏo���f�[�^
		.bus_rdy_	 (bus_rdy_),			   // ���f�B
		.bus_grnt_	 (bus_grnt_),			   // �o�X�O�����g
		.bus_req_	 (bus_req_),			   // �o�X���N�G�X�g
		.bus_addr	 (bus_addr),			   // �A�h���X
		.bus_as_	 (bus_as_),				   // �A�h���X�X�g���[�u
		.bus_rw		 (bus_rw),				   // �ǂ݁^����
		.bus_wr_data (bus_wr_data)			   // �������݃f�[�^
	);

	/********** MEM�X�e�[�W�p�C�v���C�����W�X�^ **********/
	mem_reg mem_reg (
		/********** �N���b�N & ���Z�b�g **********/
		.clk		  (clk),				   // �N���b�N
		.reset		  (reset),				   // �񓯊����Z�b�g
		/********** �������A�N�Z�X���� **********/
		.out		  (out),				   // ����
		.miss_align	  (miss_align),			   // �~�X�A���C��
		/********** �p�C�v���C������M�� **********/
		.stall		  (stall),				   // �X�g�[��
		.flush		  (flush),				   // �t���b�V��
		/********** EX/MEM�p�C�v���C�����W�X�^ **********/
		.ex_pc		  (ex_pc),				   // �v���O�����J�E���^
		.ex_en		  (ex_en),				   // �p�C�v���C���f�[�^�̗L��
		.ex_br_flag	  (ex_br_flag),			   // ����t���O
		.ex_ctrl_op	  (ex_ctrl_op),			   // ���䃌�W�X�^�I�y���[�V����
		.ex_dst_addr  (ex_dst_addr),		   // �ėp���W�X�^�������݃A�h���X
		.ex_gpr_we_	  (ex_gpr_we_),			   // �ėp���W�X�^�������ݗL��
		.ex_exp_code  (ex_exp_code),		   // ��O�R�[�h
		/********** MEM/WB�p�C�v���C�����W�X�^ **********/
		.mem_pc		  (mem_pc),				   // �v���O�����J�E���^
		.mem_en		  (mem_en),				   // �p�C�v���C���f�[�^�̗L��
		.mem_br_flag  (mem_br_flag),		   // ����t���O
		.mem_ctrl_op  (mem_ctrl_op),		   // ���䃌�W�X�^�I�y���[�V����
		.mem_dst_addr (mem_dst_addr),		   // �ėp���W�X�^�������݃A�h���X
		.mem_gpr_we_  (mem_gpr_we_),		   // �ėp���W�X�^�������ݗL��
		.mem_exp_code (mem_exp_code),		   // ��O�R�[�h
		.mem_out	  (mem_out)				   // ��������
	);

endmodule
