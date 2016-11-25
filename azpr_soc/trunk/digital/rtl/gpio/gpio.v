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
    input  wire                     clk,     // クロック
    input  wire                     reset,   // リセット
    input  wire                     cs_,     // チップセレクト
    input  wire                     as_,     // アドレスストローブ
    input  wire                     rw,      // Read / Write
    input  wire [`GpioAddrBus]      addr,    // アドレス
    input  wire [`WordDataBus]      wr_data, // 書き込みデータ
    output reg  [`WordDataBus]      rd_data, // 読み出しデータ
    output reg                      rdy_     // レディ
`ifdef GPIO_IN_CH    // 入力ポートの実装
    , input wire [`GPIO_IN_CH-1:0]  gpio_in  // 入力ポート（制御レジスタ0）
`endif
`ifdef GPIO_OUT_CH   // 出力ポートの実装
    , output reg [`GPIO_OUT_CH-1:0] gpio_out // 出力ポート（制御レジスタ1）
`endif
`ifdef GPIO_IO_CH    // 入出力ポートの実装
    , inout wire [`GPIO_IO_CH-1:0]  gpio_io  // 入出力ポート（制御レジスタ2）
`endif
);

`ifdef GPIO_IO_CH    // 入出力ポートの制御
    /********** 入出力信号 **********/
    wire [`GPIO_IO_CH-1:0]          io_in;   // 入力データ
    reg  [`GPIO_IO_CH-1:0]          io_out;  // 出力データ
    reg  [`GPIO_IO_CH-1:0]          io_dir;  // 入出力方向（制御レジスタ3）
    reg  [`GPIO_IO_CH-1:0]          io;      // 入出力
    integer                         i;       // イテレータ
   
    assign io_in       = gpio_io;            // 入力データ
    assign gpio_io     = io;                 // 入出力

    always @(*) begin
        for (i = 0; i < `GPIO_IO_CH; i = i + 1) begin : IO_DIR
            io[i] = (io_dir[i] == `GPIO_DIR_IN) ? 1'bz : io_out[i];
        end
    end

`endif
   
    /********** GPIOの制御 **********/
    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            /* 非同期リセット */
            rd_data  <= #1 `WORD_DATA_W'h0;
            rdy_     <= #1 `DISABLE_;
`ifdef GPIO_OUT_CH   // 出力ポートのリセット
            gpio_out <= #1 {`GPIO_OUT_CH{`LOW}};
`endif
`ifdef GPIO_IO_CH    // 入出力ポートのリセット
            io_out   <= #1 {`GPIO_IO_CH{`LOW}};
            io_dir   <= #1 {`GPIO_IO_CH{`GPIO_DIR_IN}};
`endif
        end else begin
            /* レディの生成 */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_)) begin
                rdy_     <= #1 `ENABLE_;
            end else begin
                rdy_     <= #1 `DISABLE_;
            end 
            /* 読み出しアクセス */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `READ)) begin
                case (addr)
`ifdef GPIO_IN_CH   // 入力ポートの読み出し
                    `GPIO_ADDR_IN_DATA  : begin // 制御レジスタ 0
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_IN_CH{1'b0}}, 
                                        gpio_in};
                    end
`endif
`ifdef GPIO_OUT_CH  // 出力ポートの読み出し
                    `GPIO_ADDR_OUT_DATA : begin // 制御レジスタ 1
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_OUT_CH{1'b0}}, 
                                        gpio_out};
                    end
`endif
`ifdef GPIO_IO_CH   // 入出力ポートの読み出し
                    `GPIO_ADDR_IO_DATA  : begin // 制御レジスタ 2
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
                                        io_in};
                     end
                    `GPIO_ADDR_IO_DIR   : begin // 制御レジスタ 3
                        rd_data  <= #1 {{`WORD_DATA_W-`GPIO_IO_CH{1'b0}}, 
                                        io_dir};
                    end
`endif
                endcase
            end else begin
                rd_data  <= #1 `WORD_DATA_W'h0;
            end
            /* 書き込みアクセス */
            if ((cs_ == `ENABLE_) && (as_ == `ENABLE_) && (rw == `WRITE)) begin
                case (addr)
`ifdef GPIO_OUT_CH  // 出力ポートへの書きこみ
                    `GPIO_ADDR_OUT_DATA : begin // 制御レジスタ 1
                        gpio_out <= #1 wr_data[`GPIO_OUT_CH-1:0];
                    end
`endif
`ifdef GPIO_IO_CH   // 入出力ポートへの書きこみ
                    `GPIO_ADDR_IO_DATA  : begin // 制御レジスタ 2
                        io_out   <= #1 wr_data[`GPIO_IO_CH-1:0];
                     end
                    `GPIO_ADDR_IO_DIR   : begin // 制御レジスタ 3
                        io_dir   <= #1 wr_data[`GPIO_IO_CH-1:0];
                    end
`endif
                endcase
            end
        end
    end

endmodule
