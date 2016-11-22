//****************************************************************************************************  
//*----------------Copyright (c) 2016 C-L-G.FPGA1988.Roger Wang. All rights reserved------------------
//
//                   --              It to be define                --
//                   --                    ...                      --
//                   --                    ...                      --
//                   --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : gt0000_digital_top.v 
//Project Name   : gt0000
//Description    : the top module of gt0000
//Github Address : https://github.com/C-L-G/gt0000/trunk/ic/digital/rtl/gt0000_digital_top.v
//License        : CPL
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 01-07-2016 17:00(1th Fri,July,2016)
//First Author   : Roger Wang
//Modify Date    : 02-09-2016 14:20(1th Sun,July,2016)
//Last Author    : Roger Wang
//Version Number : 002   
//Last Commit    : 03-09-2016 14:30(1th Sun,July,2016)
//**************************************************************************************************** 
//Change History(latest change first)
//dd.mm.yyyy - Author - Your log of change
//**************************************************************************************************** 
//02.09.2016 - Roger Wang - Add the clock switch test logic,rename the clk gen module to clk gen top.
//29.08.2016 - Roger Wang - Add the system auxiliary module,add the test logic.
//29.08.2016 - Roger Wang - The initial version.
//*---------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
module gt0000_digital_top(
    clk             ,//01   In
    rst_n           ,//01   In
    en              ,//01   In
    clk_sel         ,//01   In
    led_sel         ,//01   In
    led             ,//08   Out
    test_o           //08   Out    
);

    //************************************************************************************************
    // 1.Parameter and constant define
    //************************************************************************************************
    
//    `define UDP
    `define CLK_TEST_EN
    
    
    //************************************************************************************************
    // 2.input and output declaration
    //************************************************************************************************
    input               clk             ;//the system clk = 20MHz
    input               rst_n           ;//the system reset,low active
    input               en              ;//enable signal
    input               clk_sel         ;//clock select signal
    input               led_sel         ;//led function select
    output  [07:00]     led             ;//8 bits led
    output  [07:00]     test_o          ;//8 bits test output
    
    //************************************************************************************************
    // 3.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 3.1 the clk wire signal
    //------------------------------------------------------------------------------------------------   
    wire                div_2_clk       ;//the divide 2 clock
    wire                div_4_clk       ;//the divide 4 clock
    wire                clk_en          ;//the clock enable signal
    wire                gated_clk       ;//the clock gating signal
    wire                sw_clk          ;//the selected clock by clk_sel
    //------------------------------------------------------------------------------------------------
    // 3.2 the clk wire signal
    //------------------------------------------------------------------------------------------------  
    reg     [07:00]     aux_data_i      ;//aux data input and output
    wire    [15:00]     aux_data_o      ;//aux data input and output
    
    
    
    //------------------------------------------------------------------------------------------------
    // 3.x the test logic
    //------------------------------------------------------------------------------------------------
    `ifdef CLK_TEST_EN
    reg     [03:00]     test_cnt_1      ;//
    reg     [03:00]     test_cnt_2      ;//
    reg     [03:00]     test_cnt_3      ;//
    `endif
    //************************************************************************************************
    // 4.Main code
    //************************************************************************************************
    assign  led         = led_sel ? aux_data_o[15:08] : aux_data_o[07:00]   ;//
    assign  clk_en      = en                ;//
//  assign  aux_data_i  = 8'b10101010       ;//
    always @(posedge clk or negedge rst_n) begin : AUX_DATA_IN
        if(!rst_n)
            begin
                aux_data_i     <= 'd0;
            end
        else
            begin
                aux_data_i      <= aux_data_i + 1'b1;
            end   
    end
    //------------------------------------------------------------------------------------------------
    // 4.x the Test Logic
    //------------------------------------------------------------------------------------------------    
    `ifdef CLK_TEST_EN
    always @(posedge div_2_clk or negedge rst_n) begin : TEST_LOGIC_1
        if(!rst_n)
            begin
                test_cnt_1     <= 'd0;
            end
        else
            begin
                test_cnt_1     <= test_cnt_1 + 1'b1;
            end   
    end
    always @(posedge div_4_clk or negedge rst_n) begin : TEST_LOGIC_2
        if(!rst_n)
            begin
                test_cnt_2     <= 'd0;
            end
        else
            begin
                test_cnt_2     <= test_cnt_2 + 1'b1;
            end   
    end
    always @(posedge gated_clk or negedge rst_n) begin : TEST_LOGIC_3
        if(!rst_n)
            begin
                test_cnt_3     <= 'd0;
            end
        else
            begin
                test_cnt_3     <= test_cnt_3 + 1'b1;
            end   
    end

    reg     ccd_log_test_1;
    reg     ccd_log_test_2;
    reg     ccd_log_test_3;
    reg     ccd_log_test_4;
    reg     ccd_log_test_5;

    always @(posedge clk or negedge rst_n) begin : CCD_LOG_1
        if(!rst_n)
            begin
                ccd_log_test_1  <= 'd0;
            end
        else
            begin
                ccd_log_test_1  <= ~test_cnt_3[0];
            end   
    end

    always @(posedge div_4_clk or negedge rst_n) begin : CCD_LOG_2
        if(!rst_n)
            begin
                ccd_log_test_2  <= 'd0;
            end
        else
            begin
                ccd_log_test_2  <= ~test_cnt_1[1];
            end   
    end
    always @(posedge clk or negedge rst_n) begin : CCD_LOG_3
        if(!rst_n)
            begin
                ccd_log_test_3  <= 'd0;
            end
        else
            begin
                ccd_log_test_3  <= ~test_cnt_2[1];
            end   
    end
    always @(posedge clk or negedge rst_n) begin : CCD_LOG_4
        if(!rst_n)
            begin
                ccd_log_test_4  <= 'd0;
            end
        else if(ccd_log_test_3)
            begin
                ccd_log_test_4  <= ((test_cnt_1 == 'd3) | (test_cnt_1 == 'd2) | (test_cnt_1 == 'd1)) | (test_cnt_1 & 'b101 == 'b010);
            end
        else
            begin
                ccd_log_test_4  <= ccd_log_test_4;
            end 
    end

    always @(posedge sw_clk or negedge rst_n) begin : CCD_LOG_5
        if(!rst_n)
            begin
                ccd_log_test_5  <= 'd0;
            end
        else
            begin
                ccd_log_test_5  <= ccd_log_test_4;
            end 
    end

    
    assign  test_o[0]   = test_cnt_1[03]        ;
    assign  test_o[1]   = test_cnt_2[03]        ;
    assign  test_o[2]   = test_cnt_3[03]        ;
//  assign  test_o[7:3] = {5{test_cnt_2[00]}}   ;
    assign  test_o[3]   = ccd_log_test_1        ;   
    assign  test_o[4]   = ccd_log_test_2        ;   
    assign  test_o[5]   = ccd_log_test_3        ;   
    assign  test_o[6]   = ccd_log_test_4        ;   
    assign  test_o[7]   = ccd_log_test_5        ;   
    `else
    assign  test_o      = 8'b00000000           ;
    `endif
    
    //************************************************************************************************
    // 5.Sub module instantiation
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 5.1 the clk generate module
    //------------------------------------------------------------------------------------------------    
    clk_gen_top clk_gen_inst(
        .clk                (clk                ),//01  In
        .rst_n              (rst_n              ),//01  In
        .div_2_clk          (div_2_clk          ),//01  Out
        .div_4_clk          (div_4_clk          ),//01  Out
        .clk_en             (clk_en             ),//01  In
        .clk_sel            (clk_sel            ),//01  In
        .sw_clk             (sw_clk             ),//01  In
        .gated_clk          (gated_clk          ) //01  Out
    );
    
    //------------------------------------------------------------------------------------------------
    // 5.2 the system auxiliary module
    //------------------------------------------------------------------------------------------------   
    sys_aux_module sys_aux_inst(
        .aux_clk            (clk                ),//01  In
        .aux_rst_n          (rst_n              ),//01  In
        .aux_data_i         (aux_data_i         ),//08  In
        .aux_data_o         (aux_data_o         ) //15  Out     
    );
    
    //------------------------------------------------------------------------------------------------
    // 5.3 the udp/ip stack module
    //------------------------------------------------------------------------------------------------
    
    `ifdef UDP
    udpip_stack_module udpip_stack_inst(
        .udp_clk            (sys_clk            ),//xx  I/O
        .clk_200mhz         (adc_refclk_s       ),//xx  I/O
        .clk_in_p           (clk_in_p           ),//xx  I/O
        .clk_in_p           (clk_in_p           ),//xx  I/O
        .udp_reset          (udp_reset          ),//xx  I/O
        .mgtclk_p           (mgtclk_p           ),//xx  I/O
        .phy_disable        (                   ) //xx  I/O 
    );  
    `endif
    
endmodule    
//****************************************************************************************************
//End of Mopdule
//****************************************************************************************************
    
    
    
   
