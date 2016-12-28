/*
 -- ============================================================================
 -- FILE NAME	: bus_addr_dec.v
 -- DESCRIPTION : �A�h���X�f�R�[�_
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
module bus_addr_dec (
	/********** �A�h���X **********/
	input  wire [`WordAddrBus] s_addr, // �A�h���X
	/********** �`�b�v�Z���N�g **********/
	output reg				   s0_cs_, // �o�X�X���[�u0��
	output reg				   s1_cs_, // �o�X�X���[�u1��
	output reg				   s2_cs_, // �o�X�X���[�u2��
	output reg				   s3_cs_, // �o�X�X���[�u3��
	output reg				   s4_cs_, // �o�X�X���[�u4��
	output reg				   s5_cs_, // �o�X�X���[�u5��
	output reg				   s6_cs_, // �o�X�X���[�u6��
	output reg				   s7_cs_  // �o�X�X���[�u7��
);

	/********** �o�X�X���[�u�C���f�b�N�X **********/
	wire [`BusSlaveIndexBus] s_index = s_addr[`BusSlaveIndexLoc];

	/********** �o�X�X���[�u�}���`�v���N�T **********/
	always @(*) begin
		/* �`�b�v�Z���N�g�̏����� */
		s0_cs_ = `DISABLE_;
		s1_cs_ = `DISABLE_;
		s2_cs_ = `DISABLE_;
		s3_cs_ = `DISABLE_;
		s4_cs_ = `DISABLE_;
		s5_cs_ = `DISABLE_;
		s6_cs_ = `DISABLE_;
		s7_cs_ = `DISABLE_;
		/* �A�h���X�ɑΉ�����X���[�u�̑I�� */
		case (s_index)
			`BUS_SLAVE_0 : begin // �o�X�X���[�u0��
				s0_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_1 : begin // �o�X�X���[�u1��
				s1_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_2 : begin // �o�X�X���[�u2��
				s2_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_3 : begin // �o�X�X���[�u3��
				s3_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_4 : begin // �o�X�X���[�u4��
				s4_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_5 : begin // �o�X�X���[�u5��
				s5_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_6 : begin // �o�X�X���[�u6��
				s6_cs_	= `ENABLE_;
			end
			`BUS_SLAVE_7 : begin // �o�X�X���[�u7��
				s7_cs_	= `ENABLE_;
			end
		endcase
	end

endmodule
