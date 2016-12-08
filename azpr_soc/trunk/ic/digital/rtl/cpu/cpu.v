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
//2016.12.08 - lichangbeiju - Change the include.
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//**************************************************************************************************** 
`include "../sys_include.h"

`include "isa.h"
`include "cpu.h"
`include "bus.h"
`include "spm.h"

module cpu (
    input  wire                   clk,             
    input  wire                   clk_n,            
    input  wire                   reset,           
    input  wire [`WordDataBus]    if_bus_rd_data,  
    input  wire                   if_bus_rdy_n,     
    input  wire                   if_bus_grant_n,    
    output wire                   if_bus_req_n,     
    output wire [`WordAddrBus]    if_bus_addr,     
    output wire                   if_bus_as_n,      
    output wire                   if_bus_rw,       
    output wire [`WordDataBus]    if_bus_wr_data,  
    input  wire [`WordDataBus]    mem_bus_rd_data, 
    input  wire                   mem_bus_rdy_n,    
    input  wire                   mem_bus_grant_n,   
    output wire                   mem_bus_req_n,    
    output wire [`WordAddrBus]    mem_bus_addr,    
    output wire                   mem_bus_as_n,     
    output wire                   mem_bus_rw,      
    output wire [`WordDataBus]    mem_bus_wr_data, 
    input  wire [`CPU_IRQ_CH-1:0] cpu_irq          
);

    wire [`WordAddrBus]          if_pc;          
    wire [`WordDataBus]          if_insn;        
    wire                         if_en;          
    wire [`WordAddrBus]          id_pc;          
    wire                         id_en;          
    wire [`AluOpBus]             id_alu_op;      
    wire [`WordDataBus]          id_alu_in_0;    
    wire [`WordDataBus]          id_alu_in_1;    
    wire                         id_br_flag;     
    wire [`MemOpBus]             id_mem_op;      
    wire [`WordDataBus]          id_mem_wr_data; 
    wire [`CtrlOpBus]            id_ctrl_op;     
    wire [`RegAddrBus]           id_dst_addr;    
    wire                         id_gpr_we_n;     
    wire [`IsaExpBus]            id_exp_code;    
    wire [`WordAddrBus]          ex_pc;          
    wire                         ex_en;          
    wire                         ex_br_flag;     
    wire [`MemOpBus]             ex_mem_op;      
    wire [`WordDataBus]          ex_mem_wr_data; 
    wire [`CtrlOpBus]            ex_ctrl_op;     
    wire [`RegAddrBus]           ex_dst_addr;    
    wire                         ex_gpr_we_n;     
    wire [`IsaExpBus]            ex_exp_code;    
    wire [`WordDataBus]          ex_out;         
    wire [`WordAddrBus]          mem_pc;         
    wire                         mem_en;         
    wire                         mem_br_flag;    
    wire [`CtrlOpBus]            mem_ctrl_op;    
    wire [`RegAddrBus]           mem_dst_addr;   
    wire                         mem_gpr_we_n;    
    wire [`IsaExpBus]            mem_exp_code;   
    wire [`WordDataBus]          mem_out;           
    wire                         if_stall;       
    wire                         id_stall;       
    wire                         ex_stall;       
    wire                         mem_stall;      
    wire                         if_flush;       
    wire                         id_flush;       
    wire                         ex_flush;       
    wire                         mem_flush;      
    wire                         if_busy;        
    wire                         mem_busy;       
    wire [`WordAddrBus]          new_pc;         
    wire [`WordAddrBus]          br_addr;        
    wire                         br_taken;       
    wire                         ld_hazard;      
    wire [`WordDataBus]          gpr_rd_data_0;  
    wire [`WordDataBus]          gpr_rd_data_1;  
    wire [`RegAddrBus]           gpr_rd_addr_0;  
    wire [`RegAddrBus]           gpr_rd_addr_1;  
    wire [`CpuExeModeBus]        exe_mode;       
    wire [`WordDataBus]          creg_rd_data;   
    wire [`RegAddrBus]           creg_rd_addr;   
    wire                         int_detect;      
        
    wire [`WordDataBus]          if_spm_rd_data;  
    wire [`WordAddrBus]          if_spm_addr;     
    wire                         if_spm_as_n;      
    wire                         if_spm_rw;       
    wire [`WordDataBus]          if_spm_wr_data;  
    wire [`WordDataBus]          mem_spm_rd_data; 
    wire [`WordAddrBus]          mem_spm_addr;    
    wire                         mem_spm_as_n;     
    wire                         mem_spm_rw;      
    wire [`WordDataBus]          mem_spm_wr_data; 
    wire [`WordDataBus]          ex_fwd_data;     
    wire [`WordDataBus]          mem_fwd_data;    

        if_stage if_stage (
        .clk            (clk),              
        .reset          (reset),            
        .spm_rd_data    (if_spm_rd_data),   
        .spm_addr       (if_spm_addr),      
        .spm_as_n        (if_spm_as_n),       
        .spm_rw         (if_spm_rw),        
        .spm_wr_data    (if_spm_wr_data),   
        .bus_rd_data    (if_bus_rd_data),   
        .bus_rdy_n       (if_bus_rdy_n),      
        .bus_grant_n      (if_bus_grant_n),     
        .bus_req_n       (if_bus_req_n),      
        .bus_addr       (if_bus_addr),      
        .bus_as_n        (if_bus_as_n),       
        .bus_rw         (if_bus_rw),        
        .bus_wr_data    (if_bus_wr_data),   
        .stall          (if_stall),         
        .flush          (if_flush),         
        .new_pc         (new_pc),           
        .br_taken       (br_taken),         
        .br_addr        (br_addr),          
        .busy           (if_busy),          
        .if_pc          (if_pc),            
        .if_insn        (if_insn),          
        .if_en          (if_en)             
    );

        id_stage id_stage (
        .clk            (clk),              
        .reset          (reset),            
        .gpr_rd_data_0  (gpr_rd_data_0),    
        .gpr_rd_data_1  (gpr_rd_data_1),    
        .gpr_rd_addr_0  (gpr_rd_addr_0),    
        .gpr_rd_addr_1  (gpr_rd_addr_1),                    
        .ex_en          (ex_en),            
        .ex_fwd_data    (ex_fwd_data),      
        .ex_dst_addr    (ex_dst_addr),      
        .ex_gpr_we_n     (ex_gpr_we_n),       
        .mem_fwd_data   (mem_fwd_data),     
        .exe_mode       (exe_mode),         
        .creg_rd_data   (creg_rd_data),     
        .creg_rd_addr   (creg_rd_addr),     
        .stall         (id_stall),         
        .flush          (id_flush),         
        .br_addr        (br_addr),          
        .br_taken       (br_taken),         
        .ld_hazard      (ld_hazard),        
        .if_pc          (if_pc),            
        .if_insn        (if_insn),          
        .if_en          (if_en),            
        .id_pc          (id_pc),            
        .id_en          (id_en),            
        .id_alu_op      (id_alu_op),        
        .id_alu_in_0    (id_alu_in_0),      
        .id_alu_in_1    (id_alu_in_1),      
        .id_br_flag     (id_br_flag),       
        .id_mem_op      (id_mem_op),        
        .id_mem_wr_data (id_mem_wr_data),   
        .id_ctrl_op     (id_ctrl_op),       
        .id_dst_addr    (id_dst_addr),      
        .id_gpr_we_n     (id_gpr_we_n),       
        .id_exp_code    (id_exp_code)       
    );

        ex_stage ex_stage (
        .clk            (clk),              
        .reset          (reset),            
        .stall          (ex_stall),         
        .flush          (ex_flush),         
        .int_detect     (int_detect),       
        .fwd_data       (ex_fwd_data),      
        .id_pc          (id_pc),            
        .id_en          (id_en),            
        .id_alu_op      (id_alu_op),        
        .id_alu_in_0    (id_alu_in_0),      
        .id_alu_in_1    (id_alu_in_1),      
        .id_br_flag     (id_br_flag),       
        .id_mem_op      (id_mem_op),        
        .id_mem_wr_data (id_mem_wr_data),   
        .id_ctrl_op     (id_ctrl_op),       
        .id_dst_addr    (id_dst_addr),      
        .id_gpr_we_n     (id_gpr_we_n),       
        .id_exp_code    (id_exp_code),      
        .ex_pc          (ex_pc),            
        .ex_en          (ex_en),            
        .ex_br_flag     (ex_br_flag),       
        .ex_mem_op      (ex_mem_op),        
        .ex_mem_wr_data (ex_mem_wr_data),   
        .ex_ctrl_op     (ex_ctrl_op),       
        .ex_dst_addr    (ex_dst_addr),      
        .ex_gpr_we_n     (ex_gpr_we_n),       
        .ex_exp_code    (ex_exp_code),      
        .ex_out         (ex_out)            
    );

        mem_stage mem_stage (
        .clk            (clk),              
        .reset          (reset),            
        .stall          (mem_stall),        
        .flush          (mem_flush),        
        .busy           (mem_busy),         
        .fwd_data       (mem_fwd_data),     
        .spm_rd_data    (mem_spm_rd_data),  
        .spm_addr       (mem_spm_addr),     
        .spm_as_n        (mem_spm_as_n),      
        .spm_rw         (mem_spm_rw),       
        .spm_wr_data    (mem_spm_wr_data),  
        .bus_rd_data    (mem_bus_rd_data),  
        .bus_rdy_n       (mem_bus_rdy_n),     
        .bus_grant_n      (mem_bus_grant_n),    
        .bus_req_n       (mem_bus_req_n),     
        .bus_addr       (mem_bus_addr),     
        .bus_as_n        (mem_bus_as_n),      
        .bus_rw         (mem_bus_rw),       
        .bus_wr_data    (mem_bus_wr_data),  
        .ex_pc          (ex_pc),            
        .ex_en          (ex_en),            
        .ex_br_flag     (ex_br_flag),       
        .ex_mem_op      (ex_mem_op),        
        .ex_mem_wr_data (ex_mem_wr_data),   
        .ex_ctrl_op     (ex_ctrl_op),       
        .ex_dst_addr    (ex_dst_addr),      
        .ex_gpr_we_n     (ex_gpr_we_n),       
        .ex_exp_code    (ex_exp_code),      
        .ex_out         (ex_out),           
        .mem_pc         (mem_pc),           
        .mem_en         (mem_en),           
        .mem_br_flag    (mem_br_flag),      
        .mem_ctrl_op    (mem_ctrl_op),      
        .mem_dst_addr   (mem_dst_addr),     
        .mem_gpr_we_n    (mem_gpr_we_n),      
        .mem_exp_code   (mem_exp_code),     
        .mem_out        (mem_out)           
    );

        ctrl ctrl (
        .clk            (clk),              
        .reset          (reset),            
        .creg_rd_addr   (creg_rd_addr),     
        .creg_rd_data   (creg_rd_data),     
        .exe_mode       (exe_mode),         
        .irq            (cpu_irq),          
        .int_detect     (int_detect),       
        .id_pc          (id_pc),            
        .mem_pc         (mem_pc),           
        .mem_en         (mem_en),           
        .mem_br_flag    (mem_br_flag),      
        .mem_ctrl_op    (mem_ctrl_op),      
        .mem_dst_addr   (mem_dst_addr),     
        .mem_exp_code   (mem_exp_code),     
        .mem_out        (mem_out),          
        .if_busy        (if_busy),          
        .ld_hazard      (ld_hazard),        
        .mem_busy       (mem_busy),         
        .if_stall       (if_stall),         
        .id_stall       (id_stall),         
        .ex_stall       (ex_stall),         
        .mem_stall      (mem_stall),        
        .if_flush       (if_flush),         
        .id_flush       (id_flush),         
        .ex_flush       (ex_flush),         
        .mem_flush      (mem_flush),        
        .new_pc         (new_pc)            
    );

        gpr gpr (
        .clk       (clk),                   
        .reset     (reset),                 
        .rd_addr_0 (gpr_rd_addr_0),         
        .rd_data_0 (gpr_rd_data_0),         
        .rd_addr_1 (gpr_rd_addr_1),         
        .rd_data_1 (gpr_rd_data_1),         
        .we_n       (mem_gpr_we_n),           
        .wr_addr   (mem_dst_addr),          
        .wr_data   (mem_out)                
    );

        spm spm (
        .clk             (clk_n),                      
        .if_spm_addr     (if_spm_addr[`SpmAddrLoc]),  
        .if_spm_as_n      (if_spm_as_n),                
        .if_spm_rw       (if_spm_rw),                 
        .if_spm_wr_data  (if_spm_wr_data),            
        .if_spm_rd_data  (if_spm_rd_data),            
        .mem_spm_addr    (mem_spm_addr[`SpmAddrLoc]), 
        .mem_spm_as_n     (mem_spm_as_n),               
        .mem_spm_rw      (mem_spm_rw),                
        .mem_spm_wr_data (mem_spm_wr_data),           
        .mem_spm_rd_data (mem_spm_rd_data)            
    );

endmodule
//****************************************************************************************************
//End of Module
//****************************************************************************************************
