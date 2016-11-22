/*
 -- ============================================================================
 -- FILE NAME	: alu.v
 -- DESCRIPTION : �Z�p�_�����Z���j�b�g
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
module alu (
	input  wire [`WordDataBus] in_0,  // ���� 0
	input  wire [`WordDataBus] in_1,  // ���� 1
	input  wire [`AluOpBus]	   op,	  // �I�y���[�V����
	output reg	[`WordDataBus] out,	  // �o��
	output reg				   of	  // �I�[�o�t���[
);

	/********** �����t�����o�͐M�� **********/
	wire signed [`WordDataBus] s_in_0 = $signed(in_0); // �����t������ 0
	wire signed [`WordDataBus] s_in_1 = $signed(in_1); // �����t������ 1
	wire signed [`WordDataBus] s_out  = $signed(out);  // �����t���o��

	/********** �Z�p�_�����Z **********/
	always @(*) begin
		case (op)
			`ALU_OP_AND	 : begin // �_���ρiAND�j
				out	  = in_0 & in_1;
			end
			`ALU_OP_OR	 : begin // �_���a�iOR�j
				out	  = in_0 | in_1;
			end
			`ALU_OP_XOR	 : begin // �r���I�_���a�iXOR�j
				out	  = in_0 ^ in_1;
			end
			`ALU_OP_ADDS : begin // �����t�����Z
				out	  = in_0 + in_1;
			end
			`ALU_OP_ADDU : begin // �����Ȃ����Z
				out	  = in_0 + in_1;
			end
			`ALU_OP_SUBS : begin // �����t�����Z
				out	  = in_0 - in_1;
			end
			`ALU_OP_SUBU : begin // �����Ȃ����Z
				out	  = in_0 - in_1;
			end
			`ALU_OP_SHRL : begin // �_���E�V�t�g
				out	  = in_0 >> in_1[`ShAmountLoc];
			end
			`ALU_OP_SHLL : begin // �_�����V�t�g
				out	  = in_0 << in_1[`ShAmountLoc];
			end
			default		 : begin // �f�t�H���g�l (No Operation)
				out	  = in_0;
			end
		endcase
	end

	/********** �I�[�o�t���[�`�F�b�N **********/
	always @(*) begin
		case (op)
			`ALU_OP_ADDS : begin // ���Z�I�[�o�t���[�̃`�F�b�N
				if (((s_in_0 > 0) && (s_in_1 > 0) && (s_out < 0)) ||
					((s_in_0 < 0) && (s_in_1 < 0) && (s_out > 0))) begin
					of = `ENABLE;
				end else begin
					of = `DISABLE;
				end
			end
			`ALU_OP_SUBS : begin // ���Z�I�[�o�t���[�̃`�F�b�N
				if (((s_in_0 < 0) && (s_in_1 > 0) && (s_out > 0)) ||
					((s_in_0 > 0) && (s_in_1 < 0) && (s_out < 0))) begin
					of = `ENABLE;
				end else begin
					of = `DISABLE;
				end
			end
			default		: begin // �f�t�H���g�l
				of = `DISABLE;
			end
		endcase
	end

endmodule
