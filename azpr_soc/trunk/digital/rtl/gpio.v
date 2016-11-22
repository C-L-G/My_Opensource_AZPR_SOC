/*
 -- ============================================================================
 -- FILE NAME	: gpio.v
 -- DESCRIPTION :  General Purpose I/O
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
`include "gpio.h"

/********** ���W���[�� **********/
module gpio (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire						clk,	 // �N���b�N
	input  wire						reset,	 // ���Z�b�g
	/********** �o�X�C���^�t�F�[�X **********/
	input  wire						cs_,	 // �`�b�v�Z���N�g
	input  wire						as_,	 // �A�h���X�X�g���[�u
	input  wire						rw,		 // Read / Write
	input  wire [`GpioAddrBus]		addr,	 // �A�h���X
	input  wire [`WordDataBus]		wr_data, // �������݃f�[�^
	output reg	[`WordDataBus]		rd_data, // �ǂݏo���f�[�^
	output reg						rdy_	 // ���f�B
	/********** �ėp���o�̓|�[�g **********/
`ifdef GPIO_IN_CH	 // ���̓|�[�g�̎���
	, input wire [`GPIO_IN_CH-1:0]	gpio_in	 // ���̓|�[�g�i���䃌�W�X�^0�j
`endif
`ifdef GPIO_OUT_CH	 // �o�̓|�[�g�̎���
	, output reg [`GPIO_OUT_CH-1:0] gpio_out // �o�̓|�[�g�i���䃌�W�X�^1�j
`endif
`ifdef GPIO_IO_CH	 // ���o�̓|�[�g�̎���
	, inout wire [`GPIO_IO_CH-1:0]	gpio_io	 // ���o�̓|�[�g�i���䃌�W�X�^2�j
`endif
);

`ifdef GPIO_IO_CH	 // ���o�̓|�[�g�̐���
	/********** ���o�͐M�� **********/
	wire [`GPIO_IO_CH-1:0]			io_in;	 // ���̓f�[�^
	reg	 [`GPIO_IO_CH-1:0]			io_out;	 // �o�̓f�[�^
	reg	 [`GPIO_IO_CH-1:0]			io_dir;	 // ���o�͕����i���䃌�W�X�^3�j
	reg	 [`GPIO_IO_CH-1:0]			io;		 // ���o��
	integer							i;		 // �C�e���[�^
   
	/********** ���o�͐M���̌p����� **********/
	assign io_in	   = gpio_io;			 // ���̓f�[�^
	assign gpio_io	   = io;				 // ���o��

	/********** ���o�͕����̐��� **********/
	always @(*) begin
		for (i = 0; i < `GPIO_IO_CH; i = i + 1) begin : IO_DIR
			io[i] = (io_dir[i] == `GPIO_DIR_IN) ? 1'bz : io_out[i];
		end
	end

`endif
   
	/********** GPIO�̐��� **********/
	always @(posedge clk or `RESET_EDGE reset) begin
		if (reset == `RESET_ENABLE) begin
			/* �񓯊����Z�b�g */
			rd_data	 <= #1 `WORD_DATA_W'h0;
			rdy_	 <= #1 `DISABLE_;
`ifdef GPIO_OUT_CH	 // �o�̓|�[�g�̃��Z�b�g
			gpio_out <= #1 {`GPIO_OUT_CH{`LOW}};
`endif
`ifdef GPIO_IO_CH	 // ���o�̓|�[�g�̃��Z�b�g
			io_out	 <= #1 {`GPIO_IO_CH{`LOW}};
			io_dir	 <= #1 {`GPIO_IO_CH{`GPIO_DIR_IN}};
`endif
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
`ifdef GPIO_IN_CH	// ���̓|�[�g�̓ǂݏo��
					`GPIO_ADDR_IN_DATA	: begin // ���䃌�W�X�^ 0
						rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_IN_CH{1'b0}}, 
										gpio_in};
					end
`endif
`ifdef GPIO_OUT_CH	// �o�̓|�[�g�̓ǂݏo��
					`GPIO_ADDR_OUT_DATA : begin // ���䃌�W�X�^ 1
						rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_OUT_CH{1'b0}}, 
										gpio_out};
					end
`endif
`ifdef GPIO_IO_CH	// ���o�̓|�[�g�̓ǂݏo��
					`GPIO_ADDR_IO_DATA	: begin // ���䃌�W�X�^ 2
						rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
										io_in};
					 end
					`GPIO_ADDR_IO_DIR	: begin // ���䃌�W�X�^ 3
						rd_data	 <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
										io_dir};
					end
`endif
				endcase
			end else begin
				rd_data	 <= #1 `WORD_DATA_W'h0;
			end
			/* �������݃A�N�Z�X */
			if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)) begin
				case (addr)
`ifdef GPIO_OUT_CH	// �o�̓|�[�g�ւ̏�������
					`GPIO_ADDR_OUT_DATA : begin // ���䃌�W�X�^ 1
						gpio_out <= #1 wr_data[`GPIO_OUT_CH-1:0];
					end
`endif
`ifdef GPIO_IO_CH	// ���o�̓|�[�g�ւ̏�������
					`GPIO_ADDR_IO_DATA	: begin // ���䃌�W�X�^ 2
						io_out	 <= #1 wr_data[`GPIO_IO_CH-1:0];
					 end
					`GPIO_ADDR_IO_DIR	: begin // ���䃌�W�X�^ 3
						io_dir	 <= #1 wr_data[`GPIO_IO_CH-1:0];
					end
`endif
				endcase
			end
		end
	end

endmodule
