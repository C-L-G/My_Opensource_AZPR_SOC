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
//File Name      : Driver.sv 
//Project Name   : azpr_soc_tb
//Description    : the testbench scoreboard : compare the result between dut and ref.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/fpga/simulate/tb/Driver.sv
//License        : Apache-2.0
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2016-12-01 09:00
//First Author   : lichangbeiju
//Last Modify    : 2016-12-01 14:20
//Last Author    : lichangbeiju
//Version Number : 12 commits 
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.12.02 - lichangbeiju - The first version.
//*---------------------------------------------------------------------------------------------------
//File Include : system header file
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

//File Include : testbench include


`ifndef INC_DRIVER_SV
`define INC_DRIVER_SV
//************************************************************************************************
// 1.Class
//************************************************************************************************

class Driver;
    //------------------------------------------------------------------------------------------------
    //1.1 Interface define
    //------------------------------------------------------------------------------------------------
    virtual ee_if.iic   iic_if          ; 
    virtual ee_if.uart  uart_if         ; 
    
    //------------------------------------------------------------------------------------------------
    //1.2 Class and varialbe define
    //------------------------------------------------------------------------------------------------   
    static int          count = 0   ; 
    int                 id          ;
    bit                 uart_clk    ;

    //------------------------------------------------------------------------------------------------
    //1.3 mailbox define
    //------------------------------------------------------------------------------------------------  
    mailbox             g2d         ;
    mailbox             d2m         ;

     

    //------------------------------------------------------------------------------------------------
    //1.4 uart function and task define
    //------------------------------------------------------------------------------------------------  

    extern function uart_baud_set(input bit [15:00] baud_val,output bit uart_clk);
    extern function uart_byte_send(input bit [07:00] data);
    extern function uart_byte_receive(output bit [07:00] data);

    //------------------------------------------------------------------------------------------------
    //1.5 iic function and task define
    //------------------------------------------------------------------------------------------------  
    
    
    
    
    
    extern function new(virtual ee_if.iic iic_if,mailbox g2d_i,d2m_i);
    extern task set_dev_addr_iic(input bit [02:00] dev_addr);
    extern task send_start_iic();
    extern task send_error_start_iic();
    extern task send_stop_iic();
    extern task send_error_stop_iic();
    extern task send_byte_iic(input bit [07:00] data,input bit [02:00] len);
    extern task send_ack_iic(input bit ack_bit);
    extern task check_ack_iic(input bit ack_bit);
    extern task iic_ucmd_polling(output bit ack_bit);
    extern task iic_compare_byte_read(input bit [07:00] cmd,input bit [15:00] addr,input bit [07:00] data);
    extern task iic_compare_byte_curr_read(input bit [07:00] cmd,input bit [07:00] data);
    extern task iic_send_addr(input bit pr_en,input bit [15:00] addr);

    extern task iic_random_read(input bit read_pr_en,input bit [15:00] addr_start,input bit [15:00] len);
    extern task iic_curr_read(input bit [15:00] len,input bit [07:00] recv_data);

    extern task iic_page_write(input bit write_pr_en,input bit [15:00] addr_start,input bit [15:00] len);


    //test mode command
    extern task enter_testmode();
    extern task exit_testmode();
    extern task iic_tcmd_page_write(input bit [07:00] cmd,input bit [15:00] addr_start,input bit [15:00] len);
    extern task iic_tcmd_read_curr(input bit [07:00] cmd,input bit [07:00] curr_bit);
    extern task iic_tcmd_curr_read(input bit [07:00] cmd,input bit [15:00] len);
    extern task iic_tcmd_dummy_write(input bit [07:00] cmd,input bit [15:00] addr_start);

endclass : Driver

//************************************************************************************************
//2.Task and function
//************************************************************************************************
function Driver::new(virtual ee_if.iic iic_if_i,mailbox g2d_i,d2m_i);
    id       = count++;
    iic_if   = iic_if_i;
    this.g2d = g2d_i;
    this.d2m = d2m_i;
    $display("id = %d.",id);
endfunction

function Driver::uart_baud_set(input bit [15:00] baud_val,output bit uart_clk);
    logic   [15:00]     baud_div    ;    
    logic   [15:00]     baud_period ;
    logic               uart_en     ;
    uart_en     = 1'b1;
    baud_period = 1_000_000_000/baud_val;
    while(uart_en) begin
        for(int i=0;i<baud_period;i++)
            if((i == baud_period/2-1) | (i == baud_period - 1))
                uart_clk = ~uart_clk;
            else
                uart_clk = uart_clk;
    end
endfunction

function Driver::uart_byte_send(input bit [07:00] data);
    for(int i = 8;i > 0;i--)
        @(posedge uart_clk)
            uart_if.uart_tx = data[i-1];
endfunction

function Driver::uart_byte_receive(output bit [07:00] data);
    for(int i = 8;i > 0;i--)
        @(posedge uart_clk)
            data[i-1] = uart_if.uart_rx;
endfunction







//------------------------------------------------------------------------------------------------
//2.1 new function
//------------------------------------------------------------------------------------------------

task Driver::set_dev_addr_iic(input bit [02:00] dev_addr);
    $display("set the iic slave device address = %b.",dev_addr);
    iic_if.a0 = dev_addr[0];
    iic_if.a1 = dev_addr[1];
    iic_if.a2 = dev_addr[2];
endtask


task Driver::send_start_iic();
    iic_if.sdo = 1;
    @(posedge iic_if.scl)
        #`tSU_STA iic_if.sdo = 0;
endtask

task Driver::send_error_start_iic();
    iic_if.sdo = 1;
    @(posedge iic_if.scl)
        #`tSU_STA iic_if.sdo = 0;
    #200;
        iic_if.sdo = 1;
endtask

task Driver::send_ack_iic(input bit ack_bit);
    @(negedge iic_if.scl)
        #tHD_DAT iic_if.sdo = ack_bit;
    @(negedge iic_if.scl)
        #tHD_DAT iic_if.sdo = 1'b1;
endtask

task Driver::iic_page_write(input bit write_pr_en,input bit [15:00] addr_start,input bit [15:00] len);
    logic [07:00]   send_data;
    send_start_iic();
    send_byte_iic(8'ha0,7);
    check_ack_iic(`ACK);
    iic_send_addr(write_pr_en,addr_start);
    for(int i=0;i<len;i++) begin
        g2d.get(send_data);
        $display("send data = %x @ %d.",send_data,$realtime);
        send_byte_iic(send_data,7);
        check_ack_iic(`ACK);
    end
    send_stop_iic();
endtask



task Driver::recv_byte_iic(input logic mailbox_en,output logic [07:00] recv_data);
    for(int i=7;i>=0;i--)
        begin
            @(posedge iic_if.scl)
                recv_data[i] = iic_if.sdi;
        end
    if(mailbox_en)
        begin
            d2m.put(recv_data);
            $display("d2m num = %d.",d2m.num());
        end
endtask

//------------------------------------------------------------------------------------------------
// 2.2 the send data generator
//------------------------------------------------------------------------------------------------    
task Driver::comp_run();
    logic   [07:00]     m2s_recv    ;
    logic   [07:00]     g2s_recv    ;
    logic               comp_fail   ;
    int                 m2s_num     ;
    int                 g2s_num     ;

    m2s_num     = m2s.num();
    g2s_num     = g2s.num();
    comp_fail   = 0;
    $display("");
    $display("");
    if(m2s_num == g2s_num)
        begin
            for(int i=0;i<g2s_num;i++) begin
                m2s.get(m2s_recv);
                g2s.get(g2s_recv);
                if(g2s_recv == m2s_recv)
                    begin
                        $display("mailbox %0dth data is same : m2s %h = g2s %h.",i,m2s_recv,g2s_recv);
                    end
                else
                    begin
                        comp_fail = 1;
                        $display("mailbox %0dth data is different : the expect data = %h,the read data = %h.",g2s_recv,m2s_recv);
                    end
            end
            if(~comp_fail)
                begin
                    $display("//**************************************************************************//");
                    $display("                            Compare success                                   ");
                    $display("//**************************************************************************//");
                end
            else
                begin
                    $display("//**************************************************************************//");
                    $display("                            Compare Fail                                      ");
                    $display("//**************************************************************************//");
                end
        end
    else
        begin
            $display("//**************************************************************************//");
            $display("                            Compare Fail                                      ");
            $display("****The number is different!!!****");
            $display("//**************************************************************************//");

        end
endtask

//------------------------------------------------------------------------------------------------
// 2.3 the write and read data compare
//------------------------------------------------------------------------------------------------    
task Driver::write_read_comp(input bit [07:00] wdata,input bit [07:00] rdata);
    logic           error   ;
    if(wdata != rdata)
        error = 1;
endtask


`endif
//****************************************************************************************************
//End of Class
//****************************************************************************************************
