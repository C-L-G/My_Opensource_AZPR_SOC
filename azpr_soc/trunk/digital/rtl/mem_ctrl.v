/*
 -- ============================================================================
 -- FILE NAME	: mem_ctrl.v
 -- DESCRIPTION : �������A�N�Z�X���䃆�j�b�g
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
`include "bus.h"

/********** ���W���[�� **********/
module mem_ctrl (
	/********** EX/MEM�p�C�v���C�����W�X�^ **********/
	input  wire				   ex_en,		   // �p�C�v���C���f�[�^�̗L��
	input  wire [`MemOpBus]	   ex_mem_op,	   // �������I�y���[�V����
	input  wire [`WordDataBus] ex_mem_wr_data, // �������������݃f�[�^
	input  wire [`WordDataBus] ex_out,		   // ��������
	/********** �������A�N�Z�X�C���^�t�F�[�X **********/
	input  wire [`WordDataBus] rd_data,		   // �ǂݏo���f�[�^
	output wire [`WordAddrBus] addr,		   // �A�h���X
	output reg				   as_,			   // �A�h���X�L��
	output reg				   rw,			   // �ǂ݁^����
	output wire [`WordDataBus] wr_data,		   // �������݃f�[�^
	/********** �������A�N�Z�X���� **********/
	output reg [`WordDataBus]  out	 ,		   // �������A�N�Z�X����
	output reg				   miss_align	   // �~�X�A���C��
);

	/********** �����M�� **********/
	wire [`ByteOffsetBus]	 offset;		   // �I�t�Z�b�g

	/********** �o�͂̃A�T�C�� **********/
	assign wr_data = ex_mem_wr_data;		   // �������݃f�[�^
	assign addr	   = ex_out[`WordAddrLoc];	   // �A�h���X
	assign offset  = ex_out[`ByteOffsetLoc];   // �I�t�Z�b�g

	/********** �������A�N�Z�X�̐��� **********/
	always @(*) begin
		/* �f�t�H���g�l */
		miss_align = `DISABLE;
		out		   = `WORD_DATA_W'h0;
		as_		   = `DISABLE_;
		rw		   = `READ;
		/* �������A�N�Z�X */
		if (ex_en == `ENABLE) begin
			case (ex_mem_op)
				`MEM_OP_LDW : begin // ���[�h�ǂݏo��
					/* �o�C�g�I�t�Z�b�g�̃`�F�b�N */
					if (offset == `BYTE_OFFSET_WORD) begin // �A���C��
						out			= rd_data;
						as_		   = `ENABLE_;
					end else begin						   // �~�X�A���C��
						miss_align	= `ENABLE;
					end
				end
				`MEM_OP_STW : begin // ���[�h��������
					/* �o�C�g�I�t�Z�b�g�̃`�F�b�N */
					if (offset == `BYTE_OFFSET_WORD) begin // �A���C��
						rw			= `WRITE;
						as_		   = `ENABLE_;
					end else begin						   // �~�X�A���C��
						miss_align	= `ENABLE;
					end
				end
				default		: begin // �������A�N�Z�X�Ȃ�
					out			= ex_out;
				end
			endcase
		end
	end

endmodule
