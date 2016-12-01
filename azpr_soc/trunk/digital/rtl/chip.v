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
//2016.11.22 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
//File Include : system header file
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"
//File Include : module level header file
`include "cpu.h"
`include "bus.h"
`include "rom.h"
`include "timer.h"
`include "uart.h"
`include "gpio.h"

module chip (
    input  wire                      clk,         
    input  wire                      clk_,       
    input  wire                      reset      
    /********** UART  **********/
    `ifdef IMPLEMENT_UART 
    , input  wire                    uart_rx   
    , output wire                    uart_tx  
    `endif
    `ifdef IMPLEMENT_GPIO
    `ifdef GPIO_IN_CH   
    , input wire [`GPIO_IN_CH-1:0]   gpio_in
    `endif
    `ifdef GPIO_OUT_CH 
    , output wire [`GPIO_OUT_CH-1:0] gpio_out     
    `endif
    `ifdef GPIO_IO_CH    
    , inout wire [`GPIO_IO_CH-1:0]   gpio_io      
    `endif
    `endif
);

    //************************************************************************************************
    // 1.Parameter and constant define
    //************************************************************************************************
    
    
    //************************************************************************************************
    // 2.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 2.1 the output reg
    //------------------------------------------------------------------------------------------------   

    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------
    wire [`WordDataBus] m_rd_data;                
    wire                m_rdy_n;                   
    wire                m0_req_n;                  
    wire [`WordAddrBus] m0_addr;                  
    wire                m0_as_n;                   
    wire                m0_rw;                   
    wire [`WordDataBus] m0_wr_data;              
    wire                m0_grnt_;                
    wire                m1_req_n;                 
    wire [`WordAddrBus] m1_addr;                 
    wire                m1_as_n;                 
    wire                m1_rw;                   
    wire [`WordDataBus] m1_wr_data;              
    wire                m1_grnt_;                
    wire                m2_req_n;                 
    wire [`WordAddrBus] m2_addr;                 
    wire                m2_as_n;                 
    wire                m2_rw;                   
    wire [`WordDataBus] m2_wr_data;              
    wire                m2_grnt_;                
    wire                m3_req_n;                 
    wire [`WordAddrBus] m3_addr;                 
    wire                m3_as_n;                 
    wire                m3_rw;                   
    wire [`WordDataBus] m3_wr_data;              
    wire                m3_grnt_;                
    wire [`WordAddrBus] s_addr;                  
    wire                s_as_n;                  
    wire                s_rw;                    
    wire [`WordDataBus] s_wr_data;               
    wire [`WordDataBus] s0_rd_data;              
    wire                s0_rdy_n;                
    wire                s0_cs_n;                  
    wire [`WordDataBus] s1_rd_data;              
    wire                s1_rdy_n;                
    wire                s1_cs_n;                  
    wire [`WordDataBus] s2_rd_data;              
    wire                s2_rdy_n;                
    wire                s2_cs_n;                  
    wire [`WordDataBus] s3_rd_data;              
    wire                s3_rdy_n;                
    wire                s3_cs_n;                  
    wire [`WordDataBus] s4_rd_data;              
    wire                s4_rdy_n;                
    wire                s4_cs_n;                  
    wire [`WordDataBus] s5_rd_data;              
    wire                s5_rdy_n;                
    wire                s5_cs_n;                  
    wire [`WordDataBus] s6_rd_data;              
    wire                s6_rdy_n;                
    wire                s6_cs_n;                  
    wire [`WordDataBus] s7_rd_data;              
    wire                s7_rdy_n;                
    wire                s7_cs_n;                  
    wire                   irq_timer;            
    wire                   irq_uart_rx;          
    wire                   irq_uart_tx;          
    wire [`CPU_IRQ_CH-1:0] cpu_irq;              

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the master grant logic
    //------------------------------------------------------------------------------------------------
    assign cpu_irq = {{`CPU_IRQ_CH-3{`LOW}}, 
                      irq_uart_rx, irq_uart_tx, irq_timer};
    //************************************************************************************************
    // 4.Sub module instantiation
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the clk generate module
    //------------------------------------------------------------------------------------------------    

    /********** CPU **********/
    cpu cpu (
        .clk             (clk),        
        .clk_            (clk_),       
        .reset           (reset),      
        // IF Stage
        .if_bus_rd_data  (m_rd_data),  
        .if_bus_rdy_n     (m_rdy_n),   
        .if_bus_grnt_    (m0_grnt_),   
        .if_bus_req_n     (m0_req_n),    
        .if_bus_addr     (m0_addr),    
        .if_bus_as_n      (m0_as_n),   
        .if_bus_rw       (m0_rw),      
        .if_bus_wr_data  (m0_wr_data), 
        // MEM Stage
        .mem_bus_rd_data (m_rd_data),  
        .mem_bus_rdy_n    (m_rdy_n),   
        .mem_bus_grnt_   (m1_grnt_),   
        .mem_bus_req_n    (m1_req_n),    
        .mem_bus_addr    (m1_addr),    
        .mem_bus_as_n     (m1_as_n),   
        .mem_bus_rw      (m1_rw),      
        .mem_bus_wr_data (m1_wr_data), 
        .cpu_irq         (cpu_irq)     
    );

    assign m2_addr    = `WORD_ADDR_W'h0;
    assign m2_as_n     = `DISABLE_;
    assign m2_rw      = `READ;
    assign m2_wr_data = `WORD_DATA_W'h0;
    assign m2_req_n    = `DISABLE_;

    assign m3_addr    = `WORD_ADDR_W'h0;
    assign m3_as_n     = `DISABLE_;
    assign m3_rw      = `READ;
    assign m3_wr_data = `WORD_DATA_W'h0;
    assign m3_req_n    = `DISABLE_;
   
    rom rom (
        /********** Clock & Reset **********/
        .clk             (clk),                   
        .reset           (reset),                 
        /********** Bus Interface **********/
        .cs_n             (s0_cs_n),                
        .as_n             (s_as_n),               
        .addr            (s_addr[`RomAddrLoc]),   
        .rd_data         (s0_rd_data),            
        .rdy_n            (s0_rdy_n)              
    );

    assign s1_rd_data = `WORD_DATA_W'h0;
    assign s1_rdy_n    = `DISABLE_;

`ifdef IMPLEMENT_TIMER
    timer timer (
        .clk             (clk),                   
        .reset           (reset),                 
        .cs_n             (s2_cs_n),                
        .as_n             (s_as_n),               
        .addr            (s_addr[`TimerAddrLoc]), 
        .rw              (s_rw),                  
        .wr_data         (s_wr_data),             
        .rd_data         (s2_rd_data),            
        .rdy_n            (s2_rdy_n),             
        .irq             (irq_timer)              
     );
`else                  
    assign s2_rd_data = `WORD_DATA_W'h0;
    assign s2_rdy_n    = `DISABLE_;
    assign irq_timer  = `DISABLE;
`endif

`ifdef IMPLEMENT_UART 
    uart uart (
        .clk             (clk),                   
        .reset           (reset),                 
        .cs_n             (s3_cs_n),                
        .as_n             (s_as_n),               
        .rw              (s_rw),                  
        .addr            (s_addr[`UartAddrLoc]),  
        .wr_data         (s_wr_data),             
        .rd_data         (s3_rd_data),            
        .rdy_n            (s3_rdy_n),             
        .irq_rx          (irq_uart_rx),           
        .irq_tx          (irq_uart_tx),           
        .rx              (uart_rx),               
        .tx              (uart_tx)                
    );
`else                 
    assign s3_rd_data  = `WORD_DATA_W'h0;
    assign s3_rdy_n     = `DISABLE_;
    assign irq_uart_rx = `DISABLE;
    assign irq_uart_tx = `DISABLE;
`endif

`ifdef IMPLEMENT_GPIO 
    gpio gpio (
        .clk             (clk),                  
        .reset           (reset),                
        .cs_n             (s4_cs_n),               
        .as_n             (s_as_n),              
        .rw              (s_rw),                 
        .addr            (s_addr[`GpioAddrLoc]), 
        .wr_data         (s_wr_data),            
        .rd_data         (s4_rd_data),           
        .rdy_n            (s4_rdy_n)             
`ifdef GPIO_IN_CH    
        , .gpio_in       (gpio_in)               
`endif
`ifdef GPIO_OUT_CH   
        , .gpio_out      (gpio_out)              
`endif
`ifdef GPIO_IO_CH    
        , .gpio_io       (gpio_io)               
`endif
    );
`else                 
    assign s4_rd_data = `WORD_DATA_W'h0;
    assign s4_rdy_n    = `DISABLE_;
`endif

    assign s5_rd_data = `WORD_DATA_W'h0;
    assign s5_rdy_n    = `DISABLE_;
  
    assign s6_rd_data = `WORD_DATA_W'h0;
    assign s6_rdy_n    = `DISABLE_;
  
    assign s7_rd_data = `WORD_DATA_W'h0;
    assign s7_rdy_n    = `DISABLE_;

    bus bus (
        .clk             (clk),                  
        .reset           (reset),                
        .m_rd_data       (m_rd_data),            
        .m_rdy_n          (m_rdy_n),             
        .m0_req_n         (m0_req_n),              
        .m0_addr         (m0_addr),              
        .m0_as_n          (m0_as_n),             
        .m0_rw           (m0_rw),                
        .m0_wr_data      (m0_wr_data),           
        .m0_grnt_        (m0_grnt_),             
        .m1_req_n         (m1_req_n),              
        .m1_addr         (m1_addr),              
        .m1_as_n          (m1_as_n),             
        .m1_rw           (m1_rw),                
        .m1_wr_data      (m1_wr_data),           
        .m1_grnt_        (m1_grnt_),             
        .m2_req_n         (m2_req_n),              
        .m2_addr         (m2_addr),              
        .m2_as_n          (m2_as_n),             
        .m2_rw           (m2_rw),                
        .m2_wr_data      (m2_wr_data),           
        .m2_grnt_        (m2_grnt_),             
        .m3_req_n         (m3_req_n),              
        .m3_addr         (m3_addr),              
        .m3_as_n          (m3_as_n),             
        .m3_rw           (m3_rw),                
        .m3_wr_data      (m3_wr_data),           
        .m3_grnt_        (m3_grnt_),             
        .s_addr          (s_addr),               
        .s_as_n           (s_as_n),              
        .s_rw            (s_rw),                 
        .s_wr_data       (s_wr_data),            
        .s0_rd_data      (s0_rd_data),           
        .s0_rdy_n         (s0_rdy_n),            
        .s0_cs_n          (s0_cs_n),               
        .s1_rd_data      (s1_rd_data),           
        .s1_rdy_n         (s1_rdy_n),            
        .s1_cs_n          (s1_cs_n),               
        .s2_rd_data      (s2_rd_data),           
        .s2_rdy_n         (s2_rdy_n),            
        .s2_cs_n          (s2_cs_n),               
        .s3_rd_data      (s3_rd_data),           
        .s3_rdy_n         (s3_rdy_n),            
        .s3_cs_n          (s3_cs_n),               
        .s4_rd_data      (s4_rd_data),           
        .s4_rdy_n         (s4_rdy_n),            
        .s4_cs_n          (s4_cs_n),               
        .s5_rd_data      (s5_rd_data),           
        .s5_rdy_n         (s5_rdy_n),            
        .s5_cs_n          (s5_cs_n),               
        .s6_rd_data      (s6_rd_data),           
        .s6_rdy_n         (s6_rdy_n),            
        .s6_cs_n          (s6_cs_n),               
        .s7_rd_data      (s7_rd_data),           
        .s7_rdy_n         (s7_rdy_n),            
        .s7_cs_n          (s7_cs_n)                
    );

endmodule
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
