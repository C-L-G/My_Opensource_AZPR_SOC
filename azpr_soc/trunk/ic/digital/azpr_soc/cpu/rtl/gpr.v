/* 
 -- ============================================================================
 -- FILE NAME	: gpr.v
 -- DESCRIPTION : �ėp���W�X�^
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
module gpr (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,				   // �N���b�N
	input  wire				   reset,			   // �񓯊����Z�b�g
	/********** �ǂݏo���|�[�g 0 **********/
	input  wire [`RegAddrBus]  rd_addr_0,		   // �ǂݏo���A�h���X
	output wire [`WordDataBus] rd_data_0,		   // �ǂݏo���f�[�^
	/********** �ǂݏo���|�[�g 1 **********/
	input  wire [`RegAddrBus]  rd_addr_1,		   // �ǂݏo���A�h���X
	output wire [`WordDataBus] rd_data_1,		   // �ǂݏo���f�[�^
	/********** �������݃|�[�g **********/
	input  wire				   we_,				   // �������ݗL��
	input  wire [`RegAddrBus]  wr_addr,			   // �������݃A�h���X
	input  wire [`WordDataBus] wr_data			   // �������݃f�[�^
);

	/********** �����M�� **********/
	reg [`WordDataBus]		   gpr [`REG_NUM-1:0]; // ���W�X�^�z��
	integer					   i;				   // �C�e���[�^

	/********** �ǂݏo���A�N�Z�X (Write After Read) **********/
	// �ǂݏo���|�[�g 0
	assign rd_data_0 = ((we_ == `ENABLE_) && (wr_addr == rd_addr_0)) ? 
					   wr_data : gpr[rd_addr_0];
	// �ǂݏo���|�[�g 1
	assign rd_data_1 = ((we_ == `ENABLE_) && (wr_addr == rd_addr_1)) ? 
					   wr_data : gpr[rd_addr_1];
   
	/********** �������݃A�N�Z�X **********/
	always @ (posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin 
			/* �񓯊����Z�b�g */
			for (i = 0; i < `REG_NUM; i = i + 1) begin
				gpr[i]		 <= #1 `WORD_DATA_W'h0;
			end
		end else begin
			/* �������݃A�N�Z�X */
			if (we_ == `ENABLE_) begin 
				gpr[wr_addr] <= #1 wr_data;
			end
		end
	end

endmodule 
