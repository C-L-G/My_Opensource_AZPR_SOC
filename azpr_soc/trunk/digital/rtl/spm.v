/*
 -- ============================================================================
 -- FILE NAME	: spm.v
 -- DESCRIPTION : �X�N���b�`�p�b�h������
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
`include "spm.h"

/********** ���W���[�� **********/
module spm (
	/********** �N���b�N **********/
	input  wire				   clk,				// �N���b�N
	/********** �|�[�gA : IF�X�e�[�W **********/
	input  wire [`SpmAddrBus]  if_spm_addr,		// �A�h���X
	input  wire				   if_spm_as_,		// �A�h���X�X�g���[�u
	input  wire				   if_spm_rw,		// �ǂ݁^����
	input  wire [`WordDataBus] if_spm_wr_data,	// �������݃f�[�^
	output wire [`WordDataBus] if_spm_rd_data,	// �ǂݏo���f�[�^
	/********** �|�[�gB : MEM�X�e�[�W **********/
	input  wire [`SpmAddrBus]  mem_spm_addr,	// �A�h���X
	input  wire				   mem_spm_as_,		// �A�h���X�X�g���[�u
	input  wire				   mem_spm_rw,		// �ǂ݁^����
	input  wire [`WordDataBus] mem_spm_wr_data, // �������݃f�[�^
	output wire [`WordDataBus] mem_spm_rd_data	// �ǂݏo���f�[�^
);

	/********** �������ݗL���M�� **********/
	reg						   wea;			// �|�[�g A
	reg						   web;			// �|�[�g B

	/********** �������ݗL���M���̐��� **********/
	always @(*) begin
		/* �|�[�g A */
		if ((if_spm_as_ == `ENABLE_) && (if_spm_rw == `WRITE)) begin   
			wea = `MEM_ENABLE;	// �������ݗL��
		end else begin
			wea = `MEM_DISABLE; // �������ݖ���
		end
		/* �|�[�g B */
		if ((mem_spm_as_ == `ENABLE_) && (mem_spm_rw == `WRITE)) begin
			web = `MEM_ENABLE;	// �������ݗL��
		end else begin
			web = `MEM_DISABLE; // �������ݖ���
		end
	end

	/********** Xilinx FPGA Block RAM : �f���A���|�[�gRAM **********/
	x_s3e_dpram x_s3e_dpram (
		/********** �|�[�g A : IF�X�e�[�W **********/
		.clka  (clk),			  // �N���b�N
		.addra (if_spm_addr),	  // �A�h���X
		.dina  (if_spm_wr_data),  // �������݃f�[�^�i���ڑ��j
		.wea   (wea),			  // �������ݗL���i�l�Q�[�g�j
		.douta (if_spm_rd_data),  // �ǂݏo���f�[�^
		/********** �|�[�g B : MEM�X�e�[�W **********/
		.clkb  (clk),			  // �N���b�N
		.addrb (mem_spm_addr),	  // �A�h���X
		.dinb  (mem_spm_wr_data), // �������݃f�[�^
		.web   (web),			  // �������ݗL��
		.doutb (mem_spm_rd_data)  // �ǂݏo���f�[�^
	);
  
endmodule
