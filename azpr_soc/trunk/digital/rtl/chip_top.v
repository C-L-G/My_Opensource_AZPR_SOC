/* 
 -- ============================================================================
 -- FILE NAME	: chip_top.v
 -- DESCRIPTION : トップモジュール
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 新規作成
 -- ============================================================================
*/

/********** 共通ヘッダファイル **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** 個別ヘッダファイル **********/
`include "gpio.h"

/********** モジュール **********/
module chip_top (
	/********** クロック & リセット **********/
	input wire				   clk_ref,		  // 基底クロック
	input wire				   reset_sw		  // グローバルリセット
	/********** UART **********/
`ifdef IMPLEMENT_UART // UART実装
	, input wire			   uart_rx		  // UART受信信号
	, output wire			   uart_tx		  // UART送信信号
`endif
	/********** 汎用入出力ポート **********/
`ifdef IMPLEMENT_GPIO // GPIO実装
`ifdef GPIO_IN_CH	 // 入力ポートの実装
	, input wire [`GPIO_IN_CH-1:0]	 gpio_in  // 入力ポート
`endif
`ifdef GPIO_OUT_CH	 // 出力ポートの実装
	, output wire [`GPIO_OUT_CH-1:0] gpio_out // 出力ポート
`endif
`ifdef GPIO_IO_CH	 // 入出力ポートの実装
	, inout wire [`GPIO_IO_CH-1:0]	 gpio_io  // 入出力ポート
`endif
`endif
);

	/********** クロック & リセット **********/
	wire					   clk;			  // クロック
	wire					   clk_;		  // 反転クロック
	wire					   chip_reset;	  // チップリセット
   
	/********** クロックモジュール **********/
	clk_gen clk_gen (
		/********** クロック & リセット **********/
		.clk_ref	  (clk_ref),			  // 基底クロック
		.reset_sw	  (reset_sw),			  // グローバルリセット
		/********** 生成クロック **********/
		.clk		  (clk),				  // クロック
		.clk_		  (clk_),				  // 反転クロック
		/********** チップリセット **********/
		.chip_reset	  (chip_reset)			  // チップリセット
	);

	/********** チップ **********/
	chip chip (
		/********** クロック & リセット **********/
		.clk	  (clk),					  // クロック
		.clk_	  (clk_),					  // 反転クロック
		.reset	  (chip_reset)				  // リセット
		/********** UART **********/
`ifdef IMPLEMENT_UART
		, .uart_rx	(uart_rx)				  // UART受信波形
		, .uart_tx	(uart_tx)				  // UART送信波形
`endif
		/********** 汎用入出力ポート **********/
`ifdef IMPLEMENT_GPIO
`ifdef GPIO_IN_CH  // 入力ポートの実装
		, .gpio_in (gpio_in)				  // 入力ポート
`endif
`ifdef GPIO_OUT_CH // 出力ポートの実装
		, .gpio_out (gpio_out)				  // 出力ポート
`endif
`ifdef GPIO_IO_CH  // 入出力ポートの実装
		, .gpio_io	(gpio_io)				  // 入出力ポート
`endif
`endif
	);

endmodule
