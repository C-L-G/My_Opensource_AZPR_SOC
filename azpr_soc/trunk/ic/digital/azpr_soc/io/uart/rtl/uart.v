/*
 -- ============================================================================
 -- FILE NAME	: uart.v
 -- DESCRIPTION : Universal Asynchronous Receiver and Transmitter
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
`include "uart.h"

/********** モジュール **********/
module uart (
	/********** クロック & リセット **********/
	input  wire				   clk,		 // クロック
	input  wire				   reset,	 // 非同期リセット
	/********** バスインタフェース **********/
	input  wire				   cs_,		 // チップセレクト
	input  wire				   as_,		 // アドレスストローブ
	input  wire				   rw,		 // Read / Write
	input  wire [`UartAddrBus] addr,	 // アドレス
	input  wire [`WordDataBus] wr_data,	 // 書き込みデータ
	output wire [`WordDataBus] rd_data,	 // 読み出しデータ
	output wire				   rdy_,	 // レディ
	/********** 割り込み **********/
	output wire				   irq_rx,	 // 受信完了割り込み
	output wire				   irq_tx,	 // 送信完了割り込み
	/********** UART送受信信号	**********/
	input  wire				   rx,		 // UART受信信号
	output wire				   tx		 // UART送信信号
);

	/********** 制御信号 **********/
	// 受信制御
	wire					   rx_busy;	 // 受信中フラグ
	wire					   rx_end;	 // 受信完了信号
	wire [`ByteDataBus]		   rx_data;	 // 受信データ
	// 送信制御
	wire					   tx_busy;	 // 送信中フラグ
	wire					   tx_end;	 // 送信完了信号
	wire					   tx_start; // 送信開始信号
	wire [`ByteDataBus]		   tx_data;	 // 送信データ

	/********** UART制御モジュール **********/
	uart_ctrl uart_ctrl (
		/********** クロック & リセット **********/
		.clk	  (clk),	   // クロック
		.reset	  (reset),	   // 非同期リセット
		/********** Host Interface **********/
		.cs_	  (cs_),	   // チップセレクト
		.as_	  (as_),	   // アドレスストローブ
		.rw		  (rw),		   // Read / Write
		.addr	  (addr),	   // アドレス
		.wr_data  (wr_data),   // 書き込みデータ
		.rd_data  (rd_data),   // 読み出しデータ
		.rdy_	  (rdy_),	   // レディ
		/********** Interrupt  **********/
		.irq_rx	  (irq_rx),	   // 受信完了割り込み
		.irq_tx	  (irq_tx),	   // 送信完了割り込み
		/********** 制御信号 **********/
		// 受信制御
		.rx_busy  (rx_busy),   // 受信中フラグ
		.rx_end	  (rx_end),	   // 受信完了信号
		.rx_data  (rx_data),   // 受信データ
		// 送信制御
		.tx_busy  (tx_busy),   // 送信中フラグ
		.tx_end	  (tx_end),	   // 送信完了信号
		.tx_start (tx_start),  // 送信開始信号
		.tx_data  (tx_data)	   // 送信データ
	);

	/********** UART送信モジュール **********/
	uart_tx uart_tx (
		/********** クロック & リセット **********/
		.clk	  (clk),	   // クロック
		.reset	  (reset),	   // 非同期リセット
		/********** 制御信号 **********/
		.tx_start (tx_start),  // 送信開始信号
		.tx_data  (tx_data),   // 送信データ
		.tx_busy  (tx_busy),   // 送信中フラグ
		.tx_end	  (tx_end),	   // 送信完了信号
		/********** Transmit Signal **********/
		.tx		  (tx)		   // UART送信信号
	);

	/********** UART受信モジュール **********/
	uart_rx uart_rx (
		/********** クロック & リセット **********/
		.clk	  (clk),	   // クロック
		.reset	  (reset),	   // 非同期リセット
		/********** 制御信号 **********/
		.rx_busy  (rx_busy),   // 受信中フラグ
		.rx_end	  (rx_end),	   // 受信完了信号
		.rx_data  (rx_data),   // 受信データ
		/********** Receive Signal **********/
		.rx		  (rx)		   // UART受信信号
	);

endmodule
