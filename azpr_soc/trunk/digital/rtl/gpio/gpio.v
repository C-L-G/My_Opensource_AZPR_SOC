//****************************************************************************************************  
//*---------------Copyright (c) 2016 C-L-G.FPGA1988.lichangbeiju. All rights reserved-----------------
//
//                   --              It to be define                --
//                   --                    ...                      --
//                   --                    ...                      --
//                   --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : chip_top.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/chip.v
//License        : Apache-2.0
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2016-11-22 17:00
//First Author   : lichangbeiju
//Last Modify    : 2016-11-23 14:20
//Last Author    : lichangbeiju
//Version Number : 12 commits 
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------

`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

`include "gpio.h"

module gpio (
    input  wire                     clk,     // �N���b�N
    input  wire                     reset,   // ���Z�b�g
    input  wire                     cs_,     // �`�b�v�Z���N�g
    input  wire                     as_,     // �A�h���X�X�g���[�u
    input  wire                     rw,      // Read / Write
    input  wire [`GpioAddrBus]      addr,    // �A�h���X
    input  wire [`WordDataBus]      wr_data, // �������݃f�[�^
    output reg  [`WordDataBus]      rd_data, // �ǂݏo���f�[�^
    output reg                      rdy_     // ���f�B
`ifdef GPIO_IN_CH    // ���̓|�[�g�̎���
    , input wire [`GPIO_IN_CH-1:0]  gpio_in  // ���̓|�[�g�i���䃌�W�X�^0�j
`endif
`ifdef GPIO_OUT_CH   // �o�̓|�[�g�̎���
    , output reg [`GPIO_OUT_CH-1:0] gpio_out // �o�̓|�[�g�i���䃌�W�X�^1�j
`endif
`ifdef GPIO_IO_CH    // ���o�̓|�[�g�̎���
    , inout wire [`GPIO_IO_CH-1:0]  gpio_io  // ���o�̓|�[�g�i���䃌�W�X�^2�j
`endif
);

`ifdef GPIO_IO_CH    // ���o�̓|�[�g�̐���
    /********** ���o�͐M�� **********/
    wire [`GPIO_IO_CH-1:0]          io_in;   // ���̓f�[�^
    reg  [`GPIO_IO_CH-1:0]          io_out;  // �o�̓f�[�^
    reg  [`GPIO_IO_CH-1:0]          io_dir;  // ���o�͕����i���䃌�W�X�^3�j
    reg  [`GPIO_IO_CH-1:0]          io;      // ���o��
    integer                         i;       // �C�e���[�^
   
    assign io_in       = gpio_io;            // ���̓f�[�^
    assign gpio_io     = io;                 // ���o��

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
            rd_data  <= #1 `WORD_DATA_W'h0;
            rdy_     <= #1 `DISABLE_;
`ifdef GPIO_OUT_CH   // �o�̓|�[�g�̃��Z�b�g
            gpio_out <= #1 {`GPIO_OUT_CH{`LOW}};
`endif
`ifdef GPIO_IO_CH    // ���o�̓|�[�g�̃��Z�b�g
            io_out   <= #1 {`GPIO_IO_CH{`LOW}};
            io_dir   <= #1 {`GPIO_IO_CH{`GPIO_DIR_IN}};
`endif
        end else begin
            /* ���f�B�̐��� */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
                rdy_     <= #1 `ENABLE_;
            end else begin
                rdy_     <= #1 `DISABLE_;
            end 
            /* �ǂݏo���A�N�Z�X */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
                case (addr)
`ifdef GPIO_IN_CH   // ���̓|�[�g�̓ǂݏo��
                    `GPIO_ADDR_IN_DATA  : begin // ���䃌�W�X�^ 0
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_IN_CH{1'b0}}, 
                                        gpio_in};
                    end
`endif
`ifdef GPIO_OUT_CH  // �o�̓|�[�g�̓ǂݏo��
                    `GPIO_ADDR_OUT_DATA : begin // ���䃌�W�X�^ 1
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_OUT_CH{1'b0}}, 
                                        gpio_out};
                    end
`endif
`ifdef GPIO_IO_CH   // ���o�̓|�[�g�̓ǂݏo��
                    `GPIO_ADDR_IO_DATA  : begin // ���䃌�W�X�^ 2
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
                                        io_in};
                     end
                    `GPIO_ADDR_IO_DIR   : begin // ���䃌�W�X�^ 3
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
                                        io_dir};
                    end
`endif
                endcase
            end else begin
                rd_data  <= #1 `WORD_DATA_W'h0;
            end
            /* �������݃A�N�Z�X */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)) begin
                case (addr)
`ifdef GPIO_OUT_CH  // �o�̓|�[�g�ւ̏�������
                    `GPIO_ADDR_OUT_DATA : begin // ���䃌�W�X�^ 1
                        gpio_out <= #1 wr_data[`GPIO_OUT_CH-1:0];
                    end
`endif
`ifdef GPIO_IO_CH   // ���o�̓|�[�g�ւ̏�������
                    `GPIO_ADDR_IO_DATA  : begin // ���䃌�W�X�^ 2
                        io_out   <= #1 wr_data[`GPIO_IO_CH-1:0];
                     end
                    `GPIO_ADDR_IO_DIR   : begin // ���䃌�W�X�^ 3
                        io_dir   <= #1 wr_data[`GPIO_IO_CH-1:0];
                    end
`endif
                endcase
            end
        end
    end

endmodule
