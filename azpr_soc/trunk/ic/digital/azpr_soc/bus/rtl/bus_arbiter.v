/*
 -- ============================================================================
 -- FILE	 : bus_arbiter.v
 -- SYNOPSIS : �o�X�A�[�r�^
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
module bus_arbiter (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire		   clk,		 // �N���b�N
	input  wire		   reset,	 // �񓯊����Z�b�g
	/********** �A�[�r�g���[�V�����M�� **********/
	// �o�X�}�X�^0��
	input  wire		   m0_req_,	 // �o�X���N�G�X�g
	output reg		   m0_grnt_, // �o�X�O�����g
	// �o�X�}�X�^1��
	input  wire		   m1_req_,	 // �o�X���N�G�X�g
	output reg		   m1_grnt_, // �o�X�O�����g
	// �o�X�}�X�^2��
	input  wire		   m2_req_,	 // �o�X���N�G�X�g
	output reg		   m2_grnt_, // �o�X�O�����g
	// �o�X�}�X�^3��
	input  wire		   m3_req_,	 // �o�X���N�G�X�g
	output reg		   m3_grnt_	 // �o�X�O�����g
);

	/********** �����M�� **********/
	reg [`BusOwnerBus] owner;	 // �o�X���̏��L��
   
	/********** �o�X�O�����g�̐��� **********/
	always @(*) begin
		/* �o�X�O�����g�̏����� */
		m0_grnt_ = `DISABLE_;
		m1_grnt_ = `DISABLE_;
		m2_grnt_ = `DISABLE_;
		m3_grnt_ = `DISABLE_;
		/* �o�X�O�����g�̐��� */
		case (owner)
			`BUS_OWNER_MASTER_0 : begin // �o�X�}�X�^0��
				m0_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_1 : begin // �o�X�}�X�^1��
				m1_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_2 : begin // �o�X�}�X�^2��
				m2_grnt_ = `ENABLE_;
			end
			`BUS_OWNER_MASTER_3 : begin // �o�X�}�X�^3��
				m3_grnt_ = `ENABLE_;
			end
		endcase
	end
   
	/********** �o�X���̃A�[�r�g���[�V���� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			owner <= #1 `BUS_OWNER_MASTER_0;
		end else begin
			/* �A�[�r�g���[�V���� */
			case (owner)
				`BUS_OWNER_MASTER_0 : begin // �o�X�����L�ҁF�o�X�}�X�^0��
					/* ���Ƀo�X�����l������}�X�^ */
					if (m0_req_ == `ENABLE_) begin			// �o�X�}�X�^0��
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // �o�X�}�X�^1��
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // �o�X�}�X�^2��
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // �o�X�}�X�^3��
						owner <= #1 `BUS_OWNER_MASTER_3;
					end
				end
				`BUS_OWNER_MASTER_1 : begin // �o�X�����L�ҁF�o�X�}�X�^1��
					/* ���Ƀo�X�����l������}�X�^ */
					if (m1_req_ == `ENABLE_) begin			// �o�X�}�X�^1��
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // �o�X�}�X�^2��
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // �o�X�}�X�^3��
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // �o�X�}�X�^0��
						owner <= #1 `BUS_OWNER_MASTER_0;
					end
				end
				`BUS_OWNER_MASTER_2 : begin // �o�X�����L�ҁF�o�X�}�X�^2��
					/* ���Ƀo�X�����l������}�X�^ */
					if (m2_req_ == `ENABLE_) begin			// �o�X�}�X�^2��
						owner <= #1 `BUS_OWNER_MASTER_2;
					end else if (m3_req_ == `ENABLE_) begin // �o�X�}�X�^3��
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // �o�X�}�X�^0��
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // �o�X�}�X�^1��
						owner <= #1 `BUS_OWNER_MASTER_1;
					end
				end
				`BUS_OWNER_MASTER_3 : begin // �o�X�����L�ҁF�o�X�}�X�^3��
					/* ���Ƀo�X�����l������}�X�^ */
					if (m3_req_ == `ENABLE_) begin			// �o�X�}�X�^3��
						owner <= #1 `BUS_OWNER_MASTER_3;
					end else if (m0_req_ == `ENABLE_) begin // �o�X�}�X�^0��
						owner <= #1 `BUS_OWNER_MASTER_0;
					end else if (m1_req_ == `ENABLE_) begin // �o�X�}�X�^1��
						owner <= #1 `BUS_OWNER_MASTER_1;
					end else if (m2_req_ == `ENABLE_) begin // �o�X�}�X�^2��
						owner <= #1 `BUS_OWNER_MASTER_2;
					end
				end
			endcase
		end
	end

endmodule
