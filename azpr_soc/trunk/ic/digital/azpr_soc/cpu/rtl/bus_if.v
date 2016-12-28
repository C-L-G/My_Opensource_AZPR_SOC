/*
 -- ============================================================================
 -- FILE NAME	: bus_if.v
 -- DESCRIPTION : �o�X�C���^�t�F�[�X
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
`include "bus.h"

/********** ���W���[�� **********/
module bus_if (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire				   clk,			   // �N���b�N
	input  wire				   reset,		   // �񓯊����Z�b�g
	/********** �p�C�v���C������M�� **********/
	input  wire				   stall,		   // �X�g�[��
	input  wire				   flush,		   // �t���b�V���M��
	output reg				   busy,		   // �r�W�[�M��
	/********** CPU�C���^�t�F�[�X **********/
	input  wire [`WordAddrBus] addr,		   // �A�h���X
	input  wire				   as_,			   // �A�h���X�L��
	input  wire				   rw,			   // �ǂ݁^����
	input  wire [`WordDataBus] wr_data,		   // �������݃f�[�^
	output reg	[`WordDataBus] rd_data,		   // �ǂݏo���f�[�^
	/********** SPM�C���^�t�F�[�X **********/
	input  wire [`WordDataBus] spm_rd_data,	   // �ǂݏo���f�[�^
	output wire [`WordAddrBus] spm_addr,	   // �A�h���X
	output reg				   spm_as_,		   // �A�h���X�X�g���[�u
	output wire				   spm_rw,		   // �ǂ݁^����
	output wire [`WordDataBus] spm_wr_data,	   // �������݃f�[�^
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire [`WordDataBus] bus_rd_data,	   // �ǂݏo���f�[�^
	input  wire				   bus_rdy_,	   // ���f�B
	input  wire				   bus_grnt_,	   // �o�X�O�����g
	output reg				   bus_req_,	   // �o�X���N�G�X�g
	output reg	[`WordAddrBus] bus_addr,	   // �A�h���X
	output reg				   bus_as_,		   // �A�h���X�X�g���[�u
	output reg				   bus_rw,		   // �ǂ݁^����
	output reg	[`WordDataBus] bus_wr_data	   // �������݃f�[�^
);

	/********** �����M�� **********/
	reg	 [`BusIfStateBus]	   state;		   // �o�X�C���^�t�F�[�X�̏��
	reg	 [`WordDataBus]		   rd_buf;		   // �ǂݏo���o�b�t�@
	wire [`BusSlaveIndexBus]   s_index;		   // �o�X�X���[�u�C���f�b�N�X

	/********** �o�X�X���[�u�̃C���f�b�N�X **********/
	assign s_index	   = addr[`BusSlaveIndexLoc];

	/********** �o�͂̃A�T�C�� **********/
	assign spm_addr	   = addr;
	assign spm_rw	   = rw;
	assign spm_wr_data = wr_data;
						 
	/********** �������A�N�Z�X�̐��� **********/
	always @(*) begin
		/* �f�t�H���g�l */
		rd_data	 = `WORD_DATA_W'h0;
		spm_as_	 = `DISABLE_;
		busy	 = `DISABLE;
		/* �o�X�C���^�t�F�[�X�̏�� */
		case (state)
			`BUS_IF_STATE_IDLE	 : begin // �A�C�h��
				/* �������A�N�Z�X */
				if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin
					/* �A�N�Z�X��̑I�� */
					if (s_index == `BUS_SLAVE_1) begin // SPM�փA�N�Z�X
						if (stall == `DISABLE) begin // �X�g�[�������̃`�F�b�N
							spm_as_	 = `ENABLE_;
							if (rw == `READ) begin // �ǂݏo���A�N�Z�X
								rd_data	 = spm_rd_data;
							end
						end
					end else begin					   // �o�X�փA�N�Z�X
						busy	 = `ENABLE;
					end
				end
			end
			`BUS_IF_STATE_REQ	 : begin // �o�X���N�G�X�g
				busy	 = `ENABLE;
			end
			`BUS_IF_STATE_ACCESS : begin // �o�X�A�N�Z�X
				/* ���f�B�҂� */
				if (bus_rdy_ == `ENABLE_) begin // ���f�B����
					if (rw == `READ) begin // �ǂݏo���A�N�Z�X
						rd_data	 = bus_rd_data;
					end
				end else begin					// ���f�B������
					busy	 = `ENABLE;
				end
			end
			`BUS_IF_STATE_STALL	 : begin // �X�g�[��
				if (rw == `READ) begin // �ǂݏo���A�N�Z�X
					rd_data	 = rd_buf;
				end
			end
		endcase
	end

   /********** �o�X�C���^�t�F�[�X�̏�Ԑ��� **********/ 
   always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			state		<= #1 `BUS_IF_STATE_IDLE;
			bus_req_	<= #1 `DISABLE_;
			bus_addr	<= #1 `WORD_ADDR_W'h0;
			bus_as_		<= #1 `DISABLE_;
			bus_rw		<= #1 `READ;
			bus_wr_data <= #1 `WORD_DATA_W'h0;
			rd_buf		<= #1 `WORD_DATA_W'h0;
		end else begin
			/* �o�X�C���^�t�F�[�X�̏�� */
			case (state)
				`BUS_IF_STATE_IDLE	 : begin // �A�C�h��
					/* �������A�N�Z�X */
					if ((flush == `DISABLE) && (as_ == `ENABLE_)) begin 
						/* �A�N�Z�X��̑I�� */
						if (s_index != `BUS_SLAVE_1) begin // �o�X�փA�N�Z�X
							state		<= #1 `BUS_IF_STATE_REQ;
							bus_req_	<= #1 `ENABLE_;
							bus_addr	<= #1 addr;
							bus_rw		<= #1 rw;
							bus_wr_data <= #1 wr_data;
						end
					end
				end
				`BUS_IF_STATE_REQ	 : begin // �o�X���N�G�X�g
					/* �o�X�O�����g�҂� */
					if (bus_grnt_ == `ENABLE_) begin // �o�X���l��
						state		<= #1 `BUS_IF_STATE_ACCESS;
						bus_as_		<= #1 `ENABLE_;
					end
				end
				`BUS_IF_STATE_ACCESS : begin // �o�X�A�N�Z�X
					/* �A�h���X�X�g���[�u�̃l�Q�[�g */
					bus_as_		<= #1 `DISABLE_;
					/* ���f�B�҂� */
					if (bus_rdy_ == `ENABLE_) begin // ���f�B����
						bus_req_	<= #1 `DISABLE_;
						bus_addr	<= #1 `WORD_ADDR_W'h0;
						bus_rw		<= #1 `READ;
						bus_wr_data <= #1 `WORD_DATA_W'h0;
						/* �ǂݏo���f�[�^�̕ۑ� */
						if (bus_rw == `READ) begin // �ǂݏo���A�N�Z�X
							rd_buf		<= #1 bus_rd_data;
						end
						/* �X�g�[�������̃`�F�b�N */
						if (stall == `ENABLE) begin // �X�g�[������
							state		<= #1 `BUS_IF_STATE_STALL;
						end else begin				// �X�g�[��������
							state		<= #1 `BUS_IF_STATE_IDLE;
						end
					end
				end
				`BUS_IF_STATE_STALL	 : begin // �X�g�[��
					/* �X�g�[�������̃`�F�b�N */
					if (stall == `DISABLE) begin // �X�g�[������
						state		<= #1 `BUS_IF_STATE_IDLE;
					end
				end
			endcase
		end
	end

endmodule
