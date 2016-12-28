/*
 -- ============================================================================
 -- FILE NAME	: bus_slave_mux.v
 -- DESCRIPTION : �o�X�X���[�u�}���`�v���N�T
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
module bus_slave_mux (
	/********** �`�b�v�Z���N�g **********/
	input  wire				   s0_cs_,	   // �o�X�X���[�u0��
	input  wire				   s1_cs_,	   // �o�X�X���[�u1��
	input  wire				   s2_cs_,	   // �o�X�X���[�u2��
	input  wire				   s3_cs_,	   // �o�X�X���[�u3��
	input  wire				   s4_cs_,	   // �o�X�X���[�u4��
	input  wire				   s5_cs_,	   // �o�X�X���[�u5��
	input  wire				   s6_cs_,	   // �o�X�X���[�u6��
	input  wire				   s7_cs_,	   // �o�X�X���[�u7��
	/********** �o�X�X���[�u�M�� **********/
	// �o�X�X���[�u0��
	input  wire [`WordDataBus] s0_rd_data, // �ǂݏo���f�[�^
	input  wire				   s0_rdy_,	   // ���f�B
	// �o�X�X���[�u1��
	input  wire [`WordDataBus] s1_rd_data, // �ǂݏo���f�[�^
	input  wire				   s1_rdy_,	   // ���f�B
	// �o�X�X���[�u2��
	input  wire [`WordDataBus] s2_rd_data, // �ǂݏo���f�[�^
	input  wire				   s2_rdy_,	   // ���f�B
	// �o�X�X���[�u3��
	input  wire [`WordDataBus] s3_rd_data, // �ǂݏo���f�[�^
	input  wire				   s3_rdy_,	   // ���f�B
	// �o�X�X���[�u4��
	input  wire [`WordDataBus] s4_rd_data, // �ǂݏo���f�[�^
	input  wire				   s4_rdy_,	   // ���f�B
	// �o�X�X���[�u5��
	input  wire [`WordDataBus] s5_rd_data, // �ǂݏo���f�[�^
	input  wire				   s5_rdy_,	   // ���f�B
	// �o�X�X���[�u6��
	input  wire [`WordDataBus] s6_rd_data, // �ǂݏo���f�[�^
	input  wire				   s6_rdy_,	   // ���f�B
	// �o�X�X���[�u7��
	input  wire [`WordDataBus] s7_rd_data, // �ǂݏo���f�[�^
	input  wire				   s7_rdy_,	   // ���f�B
	/********** �o�X�}�X�^���ʐM�� **********/
	output reg	[`WordDataBus] m_rd_data,  // �ǂݏo���f�[�^
	output reg				   m_rdy_	   // ���f�B
);

	/********** �o�X�X���[�u�}���`�v���N�T **********/
	always @(*) begin
		/* �`�b�v�Z���N�g�ɑΉ�����X���[�u�̑I�� */
		if (s0_cs_ == `ENABLE_) begin		   // �o�X�X���[�u0��
			m_rd_data = s0_rd_data;
			m_rdy_	  = s0_rdy_;
		end else if (s1_cs_ == `ENABLE_) begin // �o�X�X���[�u1��
			m_rd_data = s1_rd_data;
			m_rdy_	  = s1_rdy_;
		end else if (s2_cs_ == `ENABLE_) begin // �o�X�X���[�u2��
			m_rd_data = s2_rd_data;
			m_rdy_	  = s2_rdy_;
		end else if (s3_cs_ == `ENABLE_) begin // �o�X�X���[�u3��
			m_rd_data = s3_rd_data;
			m_rdy_	  = s3_rdy_;
		end else if (s4_cs_ == `ENABLE_) begin // �o�X�X���[�u4��
			m_rd_data = s4_rd_data;
			m_rdy_	  = s4_rdy_;
		end else if (s5_cs_ == `ENABLE_) begin // �o�X�X���[�u5��
			m_rd_data = s5_rd_data;
			m_rdy_	  = s5_rdy_;
		end else if (s6_cs_ == `ENABLE_) begin // �o�X�X���[�u6��
			m_rd_data = s6_rd_data;
			m_rdy_	  = s6_rdy_;
		end else if (s7_cs_ == `ENABLE_) begin // �o�X�X���[�u7��
			m_rd_data = s7_rd_data;
			m_rdy_	  = s7_rdy_;
		end else begin						   // �f�t�H���g�l
			m_rd_data = `WORD_DATA_W'h0;
			m_rdy_	  = `DISABLE_;
		end
	end

endmodule
