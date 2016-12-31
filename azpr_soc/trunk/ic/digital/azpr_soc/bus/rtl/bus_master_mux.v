/*
 -- ============================================================================
 -- FILE NAME	: bus_master_mux.v
 -- DESCRIPTION : �o�X�}�X�^�}���`�v���N�T
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
`include "bus.h"

/********** ���W���[�� **********/
module bus_master_mux (
	/********** �o�X�}�X�^�M�� **********/
	// �o�X�}�X�^0��
	input  wire [`WordAddrBus] m0_addr,	   // �A�h���X
	input  wire				   m0_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m0_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m0_wr_data, // �������݃f�[�^
	input  wire				   m0_grnt_,   // �o�X�O�����g
	// �o�X�}�X�^1��
	input  wire [`WordAddrBus] m1_addr,	   // �A�h���X
	input  wire				   m1_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m1_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m1_wr_data, // �������݃f�[�^
	input  wire				   m1_grnt_,   // �o�X�O�����g
	// �o�X�}�X�^2��
	input  wire [`WordAddrBus] m2_addr,	   // �A�h���X
	input  wire				   m2_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m2_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m2_wr_data, // �������݃f�[�^
	input  wire				   m2_grnt_,   // �o�X�O�����g
	// �o�X�}�X�^3��
	input  wire [`WordAddrBus] m3_addr,	   // �A�h���X
	input  wire				   m3_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m3_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m3_wr_data, // �������݃f�[�^
	input  wire				   m3_grnt_,   // �o�X�O�����g
	/********** �o�X�X���[�u���ʐM�� **********/
	output reg	[`WordAddrBus] s_addr,	   // �A�h���X
	output reg				   s_as_,	   // �A�h���X�X�g���[�u
	output reg				   s_rw,	   // �ǂ݁^����
	output reg	[`WordDataBus] s_wr_data   // �������݃f�[�^
);

	/********** �o�X�}�X�^�}���`�v���N�T **********/
	always @(*) begin
		/* �o�X���������Ă���}�X�^�̑I�� */
		if (m0_grnt_ == `ENABLE_) begin			 // �o�X�}�X�^0��
			s_addr	  = m0_addr;
			s_as_	  = m0_as_;
			s_rw	  = m0_rw;
			s_wr_data = m0_wr_data;
		end else if (m1_grnt_ == `ENABLE_) begin // �o�X�}�X�^0��
			s_addr	  = m1_addr;
			s_as_	  = m1_as_;
			s_rw	  = m1_rw;
			s_wr_data = m1_wr_data;
		end else if (m2_grnt_ == `ENABLE_) begin // �o�X�}�X�^0��
			s_addr	  = m2_addr;
			s_as_	  = m2_as_;
			s_rw	  = m2_rw;
			s_wr_data = m2_wr_data;
		end else if (m3_grnt_ == `ENABLE_) begin // �o�X�}�X�^0��
			s_addr	  = m3_addr;
			s_as_	  = m3_as_;
			s_rw	  = m3_rw;
			s_wr_data = m3_wr_data;
		end else begin							 // �f�t�H���g�l
			s_addr	  = `WORD_ADDR_W'h0;
			s_as_	  = `DISABLE_;
			s_rw	  = `READ;
			s_wr_data = `WORD_DATA_W'h0;
		end
	end

endmodule
