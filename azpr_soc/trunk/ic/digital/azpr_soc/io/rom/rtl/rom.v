/*
 -- ============================================================================
 -- FILE NAME	: rom.v
 -- DESCRIPTION : Read Only Memory
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
`include "rom.h"

/********** ���W���[�� **********/
module rom (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,		// �N���b�N
	input  wire				   reset,	// �񓯊����Z�b�g
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire				   cs_,		// �`�b�v�Z���N�g
	input  wire				   as_,		// �A�h���X�X�g���[�u
	input  wire [`RomAddrBus]  addr,	// �A�h���X
	output wire [`WordDataBus] rd_data, // �ǂݏo���f�[�^
	output reg				   rdy_		// ���f�B
);

	/********** Xilinx FPGA Block RAM : �V���O���|�[�gROM **********/
	x_s3e_sprom x_s3e_sprom (
		.clka  (clk),					// �N���b�N
		.addra (addr),					// �A�h���X
		.douta (rd_data)				// �ǂݏo���f�[�^
	);

	/********** ���f�B�̐��� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			rdy_ <= #1 `DISABLE_;
		end else begin
			/* ���f�B�̐��� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_ <= #1 `ENABLE_;
			end else begin
				rdy_ <= #1 `DISABLE_;
			end
		end
	end

endmodule
