/*
 -- ============================================================================
 -- FILE NAME	: timer.v
 -- DESCRIPTION : �^�C�}
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
`include "timer.h"

/********** ���W���[�� **********/
module timer (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire					clk,	   // �N���b�N
	input  wire					reset,	   // �񓯊����Z�b�g
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire					cs_,	   // �`�b�v�Z���N�g
	input  wire					as_,	   // �A�h���X�X�g���[�u
	input  wire					rw,		   // Read / Write
	input  wire [`TimerAddrBus] addr,	   // �A�h���X
	input  wire [`WordDataBus]	wr_data,   // �������݃f�[�^
	output reg	[`WordDataBus]	rd_data,   // �ǂݏo���f�[�^
	output reg					rdy_,	   // ���f�B
	/********** ���荞�� **********/
	output reg					irq		   // ���荞�ݗv���i���䃌�W�X�^ 1�j
);

	/********** ���䃌�W�c�^ **********/
	// ���䃌�W�X�^ 0 : �R���g���[��
	reg							mode;	   // ���[�h�r�b�g
	reg							start;	   // �X�^�[�g�r�b�g
	// ���䃌�W�X�^ 2 : �����l
	reg [`WordDataBus]			expr_val;  // �����l
	// ���䃌�W�X�^ 3 : �J�E���^
	reg [`WordDataBus]			counter;   // �J�E���^

	/********** �����t���O **********/
	wire expr_flag = ((start == `ENABLE) && (counter == expr_val)) ?
					 `ENABLE : `DISABLE;

	/********** �^�C�}���� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			rd_data	 <= #1 `WORD_DATA_W'h0;
			rdy_	 <= #1 `DISABLE_;
			start	 <= #1 `DISABLE;
			mode	 <= #1 `TIMER_MODE_ONE_SHOT;
			irq		 <= #1 `DISABLE;
			expr_val <= #1 `WORD_DATA_W'h0;
			counter	 <= #1 `WORD_DATA_W'h0;
		end else begin
			/* ���f�B�̐��� */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
				rdy_	 <= #1 `ENABLE_;
			end else begin
				rdy_	 <= #1 `DISABLE_;
			end
			/* �ǂݏo���A�N�Z�X */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
				case (addr)
					`TIMER_ADDR_CTRL	: begin // ���䃌�W�X�^ 0
						rd_data	 <= #1 {{`WORD_DATA_W-2{1'b0}}, mode, start};
					end
					`TIMER_ADDR_INTR	: begin // ���䃌�W�X�^ 1
						rd_data	 <= #1 {{`WORD_DATA_W-1{1'b0}}, irq};
					end
					`TIMER_ADDR_EXPR	: begin // ���䃌�W�X�^ 2
						rd_data	 <= #1 expr_val;
					end
					`TIMER_ADDR_COUNTER : begin // ���䃌�W�X�^ 3
						rd_data	 <= #1 counter;
					end
				endcase
			end else begin
				rd_data	 <= #1 `WORD_DATA_W'h0;
			end
			/* �������݃A�N�Z�X */
			// ���䃌�W�X�^ 0
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_CTRL)) begin
				start	 <= #1 wr_data[`TimerStartLoc];
				mode	 <= #1 wr_data[`TimerModeLoc];
			end else if ((expr_flag == `ENABLE)	 &&
						 (mode == `TIMER_MODE_ONE_SHOT)) begin
				start	 <= #1 `DISABLE;
			end
			// ���䃌�W�X�^ 1
			if (expr_flag == `ENABLE) begin
				irq		 <= #1 `ENABLE;
			end else if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
						 (rw == `WRITE) && (addr ==	 `TIMER_ADDR_INTR)) begin
				irq		 <= #1 wr_data[`TimerIrqLoc];
			end
			// ���䃌�W�X�^ 2
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_EXPR)) begin
				expr_val <= #1 wr_data;
			end
			// ���䃌�W�X�^ 3
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && 
				(rw == `WRITE) && (addr == `TIMER_ADDR_COUNTER)) begin
				counter	 <= #1 wr_data;
			end else if (expr_flag == `ENABLE) begin
				counter	 <= #1 `WORD_DATA_W'h0;
			end else if (start == `ENABLE) begin
				counter	 <= #1 counter + 1'd1;
			end
		end
	end

endmodule
