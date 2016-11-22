/*
 -- ============================================================================
 -- FILE NAME	: if_stage.v
 -- DESCRIPTION : IF�X�e�[�W
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
`include "cpu.h"

/********** ���W���[�� **********/
module if_stage (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,			// �N���b�N
	input  wire				   reset,		// �񓯊����Z�b�g
	/********** SPM�C���^�t�F�[�X **********/
	input  wire [`WordDataBus] spm_rd_data, // �ǂݏo���f�[�^
	output wire [`WordAddrBus] spm_addr,	// �A�h���X
	output wire				   spm_as_,		// �A�h���X�X�g���[�u
	output wire				   spm_rw,		// �ǂ݁^����
	output wire [`WordDataBus] spm_wr_data, // �������݃f�[�^
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire [`WordDataBus] bus_rd_data, // �ǂݏo���f�[�^
	input  wire				   bus_rdy_,	// ���f�B
	input  wire				   bus_grnt_,	// �o�X�O�����g
	output wire				   bus_req_,	// �o�X���N�G�X�g
	output wire [`WordAddrBus] bus_addr,	// �A�h���X
	output wire				   bus_as_,		// �A�h���X�X�g���[�u
	output wire				   bus_rw,		// �ǂ݁^����
	output wire [`WordDataBus] bus_wr_data, // �������݃f�[�^
	/********** �p�C�v���C������M�� **********/
	input  wire				   stall,		// �X�g�[��
	input  wire				   flush,		// �t���b�V��
	input  wire [`WordAddrBus] new_pc,		// �V�����v���O�����J�E���^
	input  wire				   br_taken,	// ����̐���
	input  wire [`WordAddrBus] br_addr,		// �����A�h���X
	output wire				   busy,		// �r�W�[�M��
	/********** IF/ID�p�C�v���C�����W�X�^ **********/
	output wire [`WordAddrBus] if_pc,		// �v���O�����J�E���^
	output wire [`WordDataBus] if_insn,		// ����
	output wire				   if_en		// �p�C�v���C���f�[�^�̗L��
);

	/********** �����ڑ��M�� **********/
	wire [`WordDataBus]		   insn;		// �t�F�b�`��������

	/********** �o�X�C���^�t�F�[�X **********/
	bus_if bus_if (
		/********** �N���b�N & ���Z�b�g **********/
		.clk		 (clk),					// �N���b�N
		.reset		 (reset),				// �񓯊����Z�b�g
		/********** �p�C�v���C������M�� **********/
		.stall		 (stall),				// �X�g�[��
		.flush		 (flush),				// �t���b�V���M��
		.busy		 (busy),				// �r�W�[�M��
		/********** CPU�C���^�t�F�[�X **********/
		.addr		 (if_pc),				// �A�h���X
		.as_		 (`ENABLE_),			// �A�h���X�L��
		.rw			 (`READ),				// �ǂ݁^����
		.wr_data	 (`WORD_DATA_W'h0),		// �������݃f�[�^
		.rd_data	 (insn),				// �ǂݏo���f�[�^
		/********** �X�N���b�`�p�b�h�������C���^�t�F�[�X **********/
		.spm_rd_data (spm_rd_data),			// �ǂݏo���f�[�^
		.spm_addr	 (spm_addr),			// �A�h���X
		.spm_as_	 (spm_as_),				// �A�h���X�X�g���[�u
		.spm_rw		 (spm_rw),				// �ǂ݁^����
		.spm_wr_data (spm_wr_data),			// �������݃f�[�^
		/********** �o�X�C���^�t�F�[�X **********/
		.bus_rd_data (bus_rd_data),			// �ǂݏo���f�[�^
		.bus_rdy_	 (bus_rdy_),			// ���f�B
		.bus_grnt_	 (bus_grnt_),			// �o�X�O�����g
		.bus_req_	 (bus_req_),			// �o�X���N�G�X�g
		.bus_addr	 (bus_addr),			// �A�h���X
		.bus_as_	 (bus_as_),				// �A�h���X�X�g���[�u
		.bus_rw		 (bus_rw),				// �ǂ݁^����
		.bus_wr_data (bus_wr_data)			// �������݃f�[�^
	);
   
	/********** IF�X�e�[�W�p�C�v���C�����W�X�^ **********/
	if_reg if_reg (
		/********** �N���b�N & ���Z�b�g **********/
		.clk		 (clk),					// �N���b�N
		.reset		 (reset),				// �񓯊����Z�b�g
		/********** �t�F�b�`�f�[�^ **********/
		.insn		 (insn),				// �t�F�b�`��������
		/********** �p�C�v���C������M�� **********/
		.stall		 (stall),				// �X�g�[��
		.flush		 (flush),				// �t���b�V��
		.new_pc		 (new_pc),				// �V�����v���O�����J�E���^
		.br_taken	 (br_taken),			// ����̐���
		.br_addr	 (br_addr),				// �����A�h���X
		/********** IF/ID�p�C�v���C�����W�X�^ **********/
		.if_pc		 (if_pc),				// �v���O�����J�E���^
		.if_insn	 (if_insn),				// ����
		.if_en		 (if_en)				// �p�C�v���C���f�[�^�̗L��
	);

endmodule
