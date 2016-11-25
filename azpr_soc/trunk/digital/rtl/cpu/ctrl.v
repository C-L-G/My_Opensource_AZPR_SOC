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
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "cpu.h"
`include "rom.h"
`include "spm.h"

module ctrl (
    input  wire                   clk,          // クロック
    input  wire                   reset,        // 非同期リセット
    input  wire [`RegAddrBus]     creg_rd_addr, // 読み出しアドレス
    output reg  [`WordDataBus]    creg_rd_data, // 読み出しデータ
    output reg  [`CpuExeModeBus]  exe_mode,     // 実行モード
    input  wire [`CPU_IRQ_CH-1:0] irq,          // 割り込み要求
    output reg                    int_detect,   // 割り込み検出
    input  wire [`WordAddrBus]    id_pc,        // プログラムカウンタ
    input  wire [`WordAddrBus]    mem_pc,       // プログランカウンタ
    input  wire                   mem_en,       // パイプラインデータの有効
    input  wire                   mem_br_flag,  // 分岐フラグ
    input  wire [`CtrlOpBus]      mem_ctrl_op,  // 制御レジスタオペレーション
    input  wire [`RegAddrBus]     mem_dst_addr, // 書き込みアドレス
    input  wire [`IsaExpBus]      mem_exp_code, // 例外コード
    input  wire [`WordDataBus]    mem_out,      // 処理結果
    input  wire                   if_busy,      // IFステージビジー
    input  wire                   ld_hazard,    // ロードハザード
    input  wire                   mem_busy,     // MEMステージビジー
    output wire                   if_stall,     // IFステージストール
    output wire                   id_stall,     // IDステージストール
    output wire                   ex_stall,     // EXステージストール
    output wire                   mem_stall,    // MEMステージストール
    output wire                   if_flush,     // IFステージフラッシュ
    output wire                   id_flush,     // IDステージフラッシュ
    output wire                   ex_flush,     // EXステージフラッシュ
    output wire                   mem_flush,    // MEMステージフラッシュ
    output reg  [`WordAddrBus]    new_pc        // 新しいプログラムカウンタ
);

    reg                          int_en;        // 0番 : 割り込み有効
    reg  [`CpuExeModeBus]        pre_exe_mode;  // 1番 : 実行モード
    reg                          pre_int_en;    // 1番 : 割り込み有効
    reg  [`WordAddrBus]          epc;           // 3番 : 例外プログラムカウンタ
    reg  [`WordAddrBus]          exp_vector;    // 4番 : 例外ベクタ
    reg  [`IsaExpBus]            exp_code;      // 5番 : 例外コード
    reg                          dly_flag;      // 6番 : ディレイスロットフラグ
    reg  [`CPU_IRQ_CH-1:0]       mask;          // 7番 : 割り込みマスク

    reg [`WordAddrBus]        pre_pc;           // 前のプログラムカウンタ
    reg                       br_flag;          // 分岐フラグ

    wire   stall     = if_busy | mem_busy;
    assign if_stall  = stall | ld_hazard;
    assign id_stall  = stall;
    assign ex_stall  = stall;
    assign mem_stall = stall;
    reg    flush;
    assign if_flush  = flush;
    assign id_flush  = flush | ld_hazard;
    assign ex_flush  = flush;
    assign mem_flush = flush;

    always @(*) begin
        new_pc = `WORD_ADDR_W'h0;
        flush  = `DISABLE;
        if (mem_en == `ENABLE) begin // パイプラインのデータが有効
            if (mem_exp_code != `ISA_EXP_NO_EXP) begin       // 例外発生
                new_pc = exp_vector;
                flush  = `ENABLE;
            end else if (mem_ctrl_op == `CTRL_OP_EXRT) begin // EXRT命令
                new_pc = epc;
                flush  = `ENABLE;
            end else if (mem_ctrl_op == `CTRL_OP_WRCR) begin // WRCR命令
                new_pc = mem_pc;
                flush  = `ENABLE;
            end
        end
    end

    /********** 割り込みの検出 **********/
    always @(*) begin
        if ((int_en == `ENABLE) && ((|((~mask) & irq)) == `ENABLE)) begin
            int_detect = `ENABLE;
        end else begin
            int_detect = `DISABLE;
        end
    end
   
    /********** 読み出しアクセス **********/
    always @(*) begin
        case (creg_rd_addr)
           `CREG_ADDR_STATUS     : begin // 0番:ステータス
               creg_rd_data = {{`WORD_DATA_W-2{1'b0}}, int_en, exe_mode};
           end
           `CREG_ADDR_PRE_STATUS : begin // 1番:例外発生前のステータス
               creg_rd_data = {{`WORD_DATA_W-2{1'b0}}, 
                               pre_int_en, pre_exe_mode};
           end
           `CREG_ADDR_PC         : begin // 2番:プログラムカウンタ
               creg_rd_data = {id_pc, `BYTE_OFFSET_W'h0};
           end
           `CREG_ADDR_EPC        : begin // 3番:例外プログラムカウンタ
               creg_rd_data = {epc, `BYTE_OFFSET_W'h0};
           end
           `CREG_ADDR_EXP_VECTOR : begin // 4番:例外ベクタ
               creg_rd_data = {exp_vector, `BYTE_OFFSET_W'h0};
           end
           `CREG_ADDR_CAUSE      : begin // 5番:例外原因
               creg_rd_data = {{`WORD_DATA_W-1-`ISA_EXP_W{1'b0}}, 
                               dly_flag, exp_code};
           end
           `CREG_ADDR_INT_MASK   : begin // 6番:割り込みマスク
               creg_rd_data = {{`WORD_DATA_W-`CPU_IRQ_CH{1'b0}}, mask};
           end
           `CREG_ADDR_IRQ        : begin // 6番:割り込み原因
               creg_rd_data = {{`WORD_DATA_W-`CPU_IRQ_CH{1'b0}}, irq};
           end
           `CREG_ADDR_ROM_SIZE   : begin // 7番:ROMのサイズ
               creg_rd_data = $unsigned(`ROM_SIZE);
           end
           `CREG_ADDR_SPM_SIZE   : begin // 8番:SPMのサイズ
               creg_rd_data = $unsigned(`SPM_SIZE);
           end
           `CREG_ADDR_CPU_INFO   : begin // 9番:CPUの情報
               creg_rd_data = {`RELEASE_YEAR, `RELEASE_MONTH, 
                               `RELEASE_VERSION, `RELEASE_REVISION};
           end
           default               : begin // デフォルト値
               creg_rd_data = `WORD_DATA_W'h0;
           end
        endcase
    end

    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin
            exe_mode     <= #1 `CPU_KERNEL_MODE;
            int_en       <= #1 `DISABLE;
            pre_exe_mode <= #1 `CPU_KERNEL_MODE;
            pre_int_en   <= #1 `DISABLE;
            exp_code     <= #1 `ISA_EXP_NO_EXP;
            mask         <= #1 {`CPU_IRQ_CH{`ENABLE}};
            dly_flag     <= #1 `DISABLE;
            epc          <= #1 `WORD_ADDR_W'h0;
            exp_vector   <= #1 `WORD_ADDR_W'h0;
            pre_pc       <= #1 `WORD_ADDR_W'h0;
            br_flag      <= #1 `DISABLE;
        end else begin
            if ((mem_en == `ENABLE) && (stall == `DISABLE)) begin
                pre_pc       <= #1 mem_pc;
                br_flag      <= #1 mem_br_flag;
                if (mem_exp_code != `ISA_EXP_NO_EXP) begin       // 例外発生
                    exe_mode     <= #1 `CPU_KERNEL_MODE;
                    int_en       <= #1 `DISABLE;
                    pre_exe_mode <= #1 exe_mode;
                    pre_int_en   <= #1 int_en;
                    exp_code     <= #1 mem_exp_code;
                    dly_flag     <= #1 br_flag;
                    epc          <= #1 pre_pc;
                end else if (mem_ctrl_op == `CTRL_OP_EXRT) begin // EXRT命令
                    exe_mode     <= #1 pre_exe_mode;
                    int_en       <= #1 pre_int_en;
                end else if (mem_ctrl_op == `CTRL_OP_WRCR) begin // WRCR命令
                    case (mem_dst_addr)
                        `CREG_ADDR_STATUS     : begin // ステータス
                            exe_mode     <= #1 mem_out[`CregExeModeLoc];
                            int_en       <= #1 mem_out[`CregIntEnableLoc];
                        end
                        `CREG_ADDR_PRE_STATUS : begin // 例外発生前のステータス
                            pre_exe_mode <= #1 mem_out[`CregExeModeLoc];
                            pre_int_en   <= #1 mem_out[`CregIntEnableLoc];
                        end
                        `CREG_ADDR_EPC        : begin // 例外プログラムカウンタ
                            epc          <= #1 mem_out[`WordAddrLoc];
                        end
                        `CREG_ADDR_EXP_VECTOR : begin // 例外ベクタ
                            exp_vector   <= #1 mem_out[`WordAddrLoc];
                        end
                        `CREG_ADDR_CAUSE      : begin // 例外原因
                            dly_flag     <= #1 mem_out[`CregDlyFlagLoc];
                            exp_code     <= #1 mem_out[`CregExpCodeLoc];
                        end
                        `CREG_ADDR_INT_MASK   : begin // 割り込みマスク
                            mask         <= #1 mem_out[`CPU_IRQ_CH-1:0];
                        end
                    endcase
                end
            end
        end
    end

endmodule
