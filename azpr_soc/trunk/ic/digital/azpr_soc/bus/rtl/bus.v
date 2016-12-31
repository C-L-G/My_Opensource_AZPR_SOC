/*
 -- ============================================================================
 -- FILE NAME	: bus.v
 -- DESCRIPTION : �o�X
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
module bus (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,		   // �N���b�N
	input  wire				   reset,	   // �񓯊����Z�b�g
	/********** �o�X�}�X�^�M�� **********/
	// �o�X�}�X�^���ʐM��
	output wire [`WordDataBus] m_rd_data,  // �ǂݏo���f�[�^
	output wire				   m_rdy_,	   // ���f�B
	// �o�X�}�X�^0��
	input  wire				   m0_req_,	   // �o�X���N�G�X�g
	input  wire [`WordAddrBus] m0_addr,	   // �A�h���X
	input  wire				   m0_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m0_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m0_wr_data, // �������݃f�[�^
	output wire				   m0_grnt_,   // �o�X�O�����g
	// �o�X�}�X�^1��
	input  wire				   m1_req_,	   // �o�X���N�G�X�g
	input  wire [`WordAddrBus] m1_addr,	   // �A�h���X
	input  wire				   m1_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m1_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m1_wr_data, // �������݃f�[�^
	output wire				   m1_grnt_,   // �o�X�O�����g
	// �o�X�}�X�^2��
	input  wire				   m2_req_,	   // �o�X���N�G�X�g
	input  wire [`WordAddrBus] m2_addr,	   // �A�h���X
	input  wire				   m2_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m2_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m2_wr_data, // �������݃f�[�^
	output wire				   m2_grnt_,   // �o�X�O�����g
	// �o�X�}�X�^3��
	input  wire				   m3_req_,	   // �o�X���N�G�X�g
	input  wire [`WordAddrBus] m3_addr,	   // �A�h���X
	input  wire				   m3_as_,	   // �A�h���X�X�g���[�u
	input  wire				   m3_rw,	   // �ǂ݁^����
	input  wire [`WordDataBus] m3_wr_data, // �������݃f�[�^
	output wire				   m3_grnt_,   // �o�X�O�����g
	/********** �o�X�X���[�u�M�� **********/
	// �o�X�X���[�u���ʐM��
	output wire [`WordAddrBus] s_addr,	   // �A�h���X
	output wire				   s_as_,	   // �A�h���X�X�g���[�u
	output wire				   s_rw,	   // �ǂ݁^����
	output wire [`WordDataBus] s_wr_data,  // �������݃f�[�^
	// �o�X�X���[�u0��
	input  wire [`WordDataBus] s0_rd_data, // �ǂݏo���f�[�^
	input  wire				   s0_rdy_,	   // ���f�B
	output wire				   s0_cs_,	   // �`�b�v�Z���N�g
	// �o�X�X���[�u1��
	input  wire [`WordDataBus] s1_rd_data, // �ǂݏo���f�[�^
	input  wire				   s1_rdy_,	   // ���f�B
	output wire				   s1_cs_,	   // �`�b�v�Z���N�g
	// �o�X�X���[�u2��
	input  wire [`WordDataBus] s2_rd_data, // �ǂݏo���f�[�^
	input  wire				   s2_rdy_,	   // ���f�B
	output wire				   s2_cs_,	   // �`�b�v�Z���N�g
	// �o�X�X���[�u3��
	input  wire [`WordDataBus] s3_rd_data, // �ǂݏo���f�[�^
	input  wire				   s3_rdy_,	   // ���f�B
	output wire				   s3_cs_,	   // �`�b�v�Z���N�g
	// �o�X�X���[�u4��
	input  wire [`WordDataBus] s4_rd_data, // �ǂݏo���f�[�^
	input  wire				   s4_rdy_,	   // ���f�B
	output wire				   s4_cs_,	   // �`�b�v�Z���N�g
	// �o�X�X���[�u5��
	input  wire [`WordDataBus] s5_rd_data, // �ǂݏo���f�[�^
	input  wire				   s5_rdy_,	   // ���f�B
	output wire				   s5_cs_,	   // �`�b�v�Z���N�g
	// �o�X�X���[�u6��
	input  wire [`WordDataBus] s6_rd_data, // �ǂݏo���f�[�^
	input  wire				   s6_rdy_,	   // ���f�B
	output wire				   s6_cs_,	   // �`�b�v�Z���N�g
	// �o�X�X���[�u7��
	input  wire [`WordDataBus] s7_rd_data, // �ǂݏo���f�[�^
	input  wire				   s7_rdy_,	   // ���f�B
	output wire				   s7_cs_	   // �`�b�v�Z���N�g
);

	/********** �o�X�A�[�r�^ **********/
	bus_arbiter bus_arbiter (
		/********** �N���b�N & ���Z�b�g **********/
		.clk		(clk),		  // �N���b�N
		.reset		(reset),	  // �񓯊����Z�b�g
		/********** �A�[�r�g���[�V�����M�� **********/
		// �o�X�}�X�^0��
		.m0_req_	(m0_req_),	  // �o�X���N�G�X�g
		.m0_grnt_	(m0_grnt_),	  // �o�X�O�����g
		// �o�X�}�X�^1��
		.m1_req_	(m1_req_),	  // �o�X���N�G�X�g
		.m1_grnt_	(m1_grnt_),	  // �o�X�O�����g
		// �o�X�}�X�^2��
		.m2_req_	(m2_req_),	  // �o�X���N�G�X�g
		.m2_grnt_	(m2_grnt_),	  // �o�X�O�����g
		// �o�X�}�X�^3��
		.m3_req_	(m3_req_),	  // �o�X���N�G�X�g
		.m3_grnt_	(m3_grnt_)	  // �o�X�O�����g
	);

	/********** �o�X�}�X�^�}���`�v���N�T **********/
	bus_master_mux bus_master_mux (
		/********** �o�X�}�X�^�M�� **********/
		// �o�X�}�X�^0��
		.m0_addr	(m0_addr),	  // �A�h���X
		.m0_as_		(m0_as_),	  // �A�h���X�X�g���[�u
		.m0_rw		(m0_rw),	  // �ǂ݁^����
		.m0_wr_data (m0_wr_data), // �������݃f�[�^
		.m0_grnt_	(m0_grnt_),	  // �o�X�O�����g
		// �o�X�}�X�^1��
		.m1_addr	(m1_addr),	  // �A�h���X
		.m1_as_		(m1_as_),	  // �A�h���X�X�g���[�u
		.m1_rw		(m1_rw),	  // �ǂ݁^����
		.m1_wr_data (m1_wr_data), // �������݃f�[�^
		.m1_grnt_	(m1_grnt_),	  // �o�X�O�����g
		// �o�X�}�X�^2��
		.m2_addr	(m2_addr),	  // �A�h���X
		.m2_as_		(m2_as_),	  // �A�h���X�X�g���[�u
		.m2_rw		(m2_rw),	  // �ǂ݁^����
		.m2_wr_data (m2_wr_data), // �������݃f�[�^
		.m2_grnt_	(m2_grnt_),	  // �o�X�O�����g
		// �o�X�}�X�^3��
		.m3_addr	(m3_addr),	  // �A�h���X
		.m3_as_		(m3_as_),	  // �A�h���X�X�g���[�u
		.m3_rw		(m3_rw),	  // �ǂ݁^����
		.m3_wr_data (m3_wr_data), // �������݃f�[�^
		.m3_grnt_	(m3_grnt_),	  // �o�X�O�����g
		/********** �o�X�X���[�u���ʐM�� **********/
		.s_addr		(s_addr),	  // �A�h���X
		.s_as_		(s_as_),	  // �A�h���X�X�g���[�u
		.s_rw		(s_rw),		  // �ǂ݁^����
		.s_wr_data	(s_wr_data)	  // �������݃f�[�^
	);

	/********** �A�h���X�f�R�[�_ **********/
	bus_addr_dec bus_addr_dec (
		/********** �A�h���X **********/
		.s_addr		(s_addr),	  // �A�h���X
		/********** �`�b�v�Z���N�g **********/
		.s0_cs_		(s0_cs_),	  // �o�X�X���[�u0��
		.s1_cs_		(s1_cs_),	  // �o�X�X���[�u1��
		.s2_cs_		(s2_cs_),	  // �o�X�X���[�u2��
		.s3_cs_		(s3_cs_),	  // �o�X�X���[�u3��
		.s4_cs_		(s4_cs_),	  // �o�X�X���[�u4��
		.s5_cs_		(s5_cs_),	  // �o�X�X���[�u5��
		.s6_cs_		(s6_cs_),	  // �o�X�X���[�u6��
		.s7_cs_		(s7_cs_)	  // �o�X�X���[�u7��
	);

	/********** �o�X�X���[�u�}���`�v���N�T **********/
	bus_slave_mux bus_slave_mux (
		/********** �`�b�v�Z���N�g **********/
		.s0_cs_		(s0_cs_),	  // �o�X�X���[�u0��
		.s1_cs_		(s1_cs_),	  // �o�X�X���[�u1��
		.s2_cs_		(s2_cs_),	  // �o�X�X���[�u2��
		.s3_cs_		(s3_cs_),	  // �o�X�X���[�u3��
		.s4_cs_		(s4_cs_),	  // �o�X�X���[�u4��
		.s5_cs_		(s5_cs_),	  // �o�X�X���[�u5��
		.s6_cs_		(s6_cs_),	  // �o�X�X���[�u6��
		.s7_cs_		(s7_cs_),	  // �o�X�X���[�u7��
		/********** �o�X�X���[�u�M�� **********/
		// �o�X�X���[�u0��
		.s0_rd_data (s0_rd_data), // �ǂݏo���f�[�^
		.s0_rdy_	(s0_rdy_),	  // ���f�B
		// �o�X�X���[�u1��
		.s1_rd_data (s1_rd_data), // �ǂݏo���f�[�^
		.s1_rdy_	(s1_rdy_),	  // ���f�B
		// �o�X�X���[�u2��
		.s2_rd_data (s2_rd_data), // �ǂݏo���f�[�^
		.s2_rdy_	(s2_rdy_),	  // ���f�B
		// �o�X�X���[�u3��
		.s3_rd_data (s3_rd_data), // �ǂݏo���f�[�^
		.s3_rdy_	(s3_rdy_),	  // ���f�B
		// �o�X�X���[�u4��
		.s4_rd_data (s4_rd_data), // �ǂݏo���f�[�^
		.s4_rdy_	(s4_rdy_),	  // ���f�B
		// �o�X�X���[�u5��
		.s5_rd_data (s5_rd_data), // �ǂݏo���f�[�^
		.s5_rdy_	(s5_rdy_),	  // ���f�B
		// �o�X�X���[�u6��
		.s6_rd_data (s6_rd_data), // �ǂݏo���f�[�^
		.s6_rdy_	(s6_rdy_),	  // ���f�B
		// �o�X�X���[�u7��
		.s7_rd_data (s7_rd_data), // �ǂݏo���f�[�^
		.s7_rdy_	(s7_rdy_),	  // ���f�B
		/********** �o�X�}�X�^���ʐM�� **********/
		.m_rd_data	(m_rd_data),  // �ǂݏo���f�[�^
		.m_rdy_		(m_rdy_)	  // ���f�B
	);

endmodule
