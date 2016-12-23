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
//File Name      : decoder.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/decoder.v
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
//2016.12.05 - lichangbeiju - Change the coding style.
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//**************************************************************************************************** 
//File Include : system header file
`include "../sys_include.h"

`include "isa.h"
`include "cpu.h"

module decoder (
    input  wire [`WordAddrBus]   if_pc          ,          
    input  wire [`WordDataBus]   if_insn        ,       
    input  wire                  if_en          ,        
    input  wire [`WordDataBus]   gpr_rd_data_0  , 
    input  wire [`WordDataBus]   gpr_rd_data_1  , 
    output wire [`RegAddrBus]    gpr_rd_addr_0  , 
    output wire [`RegAddrBus]    gpr_rd_addr_1  , 
    input  wire                  id_en          ,         
    input  wire [`RegAddrBus]    id_dst_addr    ,   
    input  wire                  id_gpr_we_n    ,    
    input  wire [`MemOpBus]      id_mem_op      ,     
    input  wire                  ex_en          ,         
    input  wire [`RegAddrBus]    ex_dst_addr    ,   
    input  wire                  ex_gpr_we_n    ,    
    input  wire [`WordDataBus]   ex_fwd_data    ,   
    input  wire [`WordDataBus]   mem_fwd_data   ,  
    input  wire [`CpuExeModeBus] exe_mode       ,      
    input  wire [`WordDataBus]   creg_rd_data   ,  
    output wire [`RegAddrBus]    creg_rd_addr   ,  
    output reg  [`AluOpBus]      alu_op         ,        
    output reg  [`WordDataBus]   alu_in_0       ,      
    output reg  [`WordDataBus]   alu_in_1       ,      
    output reg  [`WordAddrBus]   br_addr        ,       
    output reg                   br_taken       ,      
    output reg                   br_flag        ,       
    output reg  [`MemOpBus]      mem_op         ,        
    output wire [`WordDataBus]   mem_wr_data    ,   
    output reg  [`CtrlOpBus]     ctrl_op        ,       
    output reg  [`RegAddrBus]    dst_addr       ,      
    output reg                   gpr_we_n       ,       
    output reg  [`IsaExpBus]     exp_code       ,      
    output reg                   ld_hazard      
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
    reg         [`WordDataBus]  ra_data;                          
    reg         [`WordDataBus]  rb_data;                          
    //------------------------------------------------------------------------------------------------
    // 2.2 the internal reg
    //------------------------------------------------------------------------------------------------  
    
    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the pipeline register
    //------------------------------------------------------------------------------------------------

    wire [`IsaOpBus]    op      = if_insn[`IsaOpLoc];     
    wire [`RegAddrBus]  ra_addr = if_insn[`IsaRaAddrLoc]; 
    wire [`RegAddrBus]  rb_addr = if_insn[`IsaRbAddrLoc]; 
    wire [`RegAddrBus]  rc_addr = if_insn[`IsaRcAddrLoc]; 
    wire [`IsaImmBus]   imm     = if_insn[`IsaImmLoc];    
    wire [`WordDataBus] imm_s = {{`ISA_EXT_W{imm[`ISA_IMM_MSB]}}, imm};
    wire [`WordDataBus] imm_u = {{`ISA_EXT_W{1'b0}}, imm};
    assign gpr_rd_addr_0 = ra_addr; 
    assign gpr_rd_addr_1 = rb_addr;
    assign creg_rd_addr  = ra_addr; 
    wire signed [`WordDataBus]  s_ra_data = $signed(ra_data);     
    wire signed [`WordDataBus]  s_rb_data = $signed(rb_data);     
    assign mem_wr_data = rb_data; 
    wire [`WordAddrBus] ret_addr  = if_pc + 1'b1;                    
    wire [`WordAddrBus] br_target = if_pc + imm_s[`WORD_ADDR_MSB:0]; 
    wire [`WordAddrBus] jr_target = ra_data[`WordAddrLoc];         

    always @(*) begin
        if ((id_en == `ENABLE) && (id_gpr_we_n == `ENABLE_N) && 
            (id_dst_addr == ra_addr)) begin
            ra_data = ex_fwd_data;   
        end else if ((ex_en == `ENABLE) && (ex_gpr_we_n == `ENABLE_N) && 
                     (ex_dst_addr == ra_addr)) begin
            ra_data = mem_fwd_data;  
        end else begin
            ra_data = gpr_rd_data_0; 
        end
        if ((id_en == `ENABLE) && (id_gpr_we_n == `ENABLE_N) && 
            (id_dst_addr == rb_addr)) begin
            rb_data = ex_fwd_data;   
        end else if ((ex_en == `ENABLE) && (ex_gpr_we_n == `ENABLE_N) && 
                     (ex_dst_addr == rb_addr)) begin
            rb_data = mem_fwd_data;  
        end else begin
            rb_data = gpr_rd_data_1; 
        end
    end

    always @(*) begin
        if ((id_en == `ENABLE) && (id_mem_op == `MEM_OP_LDW) &&
            ((id_dst_addr == ra_addr) || (id_dst_addr == rb_addr))) begin
            ld_hazard = `ENABLE;  
        end else begin
            ld_hazard = `DISABLE; 
        end
    end

    always @(*) begin
        alu_op   = `ALU_OP_NOP;
        alu_in_0 = ra_data;
        alu_in_1 = rb_data;
        br_taken = `DISABLE;
        br_flag  = `DISABLE;
        br_addr  = {`WORD_ADDR_W{1'b0}};
        mem_op   = `MEM_OP_NOP;
        ctrl_op  = `CTRL_OP_NOP;
        dst_addr = rb_addr;
        gpr_we_n  = `DISABLE_N;
        exp_code = `ISA_EXP_NO_EXP;
        if (if_en == `ENABLE) begin
            case (op)
                `ISA_OP_ANDR  : begin 
                    alu_op   = `ALU_OP_AND;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_ANDI  : begin 
                    alu_op   = `ALU_OP_AND;
                    alu_in_1 = imm_u;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_ORR   : begin 
                    alu_op   = `ALU_OP_OR;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_ORI   : begin 
                    alu_op   = `ALU_OP_OR;
                    alu_in_1 = imm_u;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_XORR  : begin 
                    alu_op   = `ALU_OP_XOR;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_XORI  : begin 
                    alu_op   = `ALU_OP_XOR;
                    alu_in_1 = imm_u;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_ADDSR : begin 
                    alu_op   = `ALU_OP_ADDS;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_ADDSI : begin 
                    alu_op   = `ALU_OP_ADDS;
                    alu_in_1 = imm_s;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_ADDUR : begin 
                    alu_op   = `ALU_OP_ADDU;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_ADDUI : begin 
                    alu_op   = `ALU_OP_ADDU;
                    alu_in_1 = imm_s;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_SUBSR : begin 
                    alu_op   = `ALU_OP_SUBS;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_SUBUR : begin 
                    alu_op   = `ALU_OP_SUBU;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                /* ƒVƒtƒg–½—ß */
                `ISA_OP_SHRLR : begin 
                    alu_op   = `ALU_OP_SHRL;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_SHRLI : begin 
                    alu_op   = `ALU_OP_SHRL;
                    alu_in_1 = imm_u;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_SHLLR : begin 
                    alu_op   = `ALU_OP_SHLL;
                    dst_addr = rc_addr;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_SHLLI : begin 
                    alu_op   = `ALU_OP_SHLL;
                    alu_in_1 = imm_u;
                    gpr_we_n  = `ENABLE_N;
                end
                /* •ªŠò–½—ß */
                `ISA_OP_BE    : begin 
                    br_addr  = br_target;
                    br_taken = (ra_data == rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_BNE   : begin 
                    br_addr  = br_target;
                    br_taken = (ra_data != rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_BSGT  : begin 
                    br_addr  = br_target;
                    br_taken = (s_ra_data < s_rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_BUGT  : begin 
                    br_addr  = br_target;
                    br_taken = (ra_data < rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_JMP   : begin 
                    br_addr  = jr_target;
                    br_taken = `ENABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_CALL  : begin 
                    alu_in_0 = {ret_addr, {`BYTE_OFFSET_W{1'b0}}};
                    br_addr  = jr_target;
                    br_taken = `ENABLE;
                    br_flag  = `ENABLE;
                    dst_addr = `REG_ADDR_W'd31;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_LDW   : begin 
                    alu_op   = `ALU_OP_ADDU;
                    alu_in_1 = imm_s;
                    mem_op   = `MEM_OP_LDW;
                    gpr_we_n  = `ENABLE_N;
                end
                `ISA_OP_STW   : begin 
                    alu_op   = `ALU_OP_ADDU;
                    alu_in_1 = imm_s;
                    mem_op   = `MEM_OP_STW;
                end
                `ISA_OP_TRAP  : begin 
                    exp_code = `ISA_EXP_TRAP;
                end
                `ISA_OP_RDCR  : begin 
                    if (exe_mode == `CPU_KERNEL_MODE) begin
                        alu_in_0 = creg_rd_data;
                        gpr_we_n  = `ENABLE_N;
                    end else begin
                        exp_code = `ISA_EXP_PRV_VIO;
                    end
                end
                `ISA_OP_WRCR  : begin 
                    if (exe_mode == `CPU_KERNEL_MODE) begin
                        ctrl_op  = `CTRL_OP_WRCR;
                    end else begin
                        exp_code = `ISA_EXP_PRV_VIO;
                    end
                end
                `ISA_OP_EXRT  : begin 
                    if (exe_mode == `CPU_KERNEL_MODE) begin
                        ctrl_op  = `CTRL_OP_EXRT;
                    end else begin
                        exp_code = `ISA_EXP_PRV_VIO;
                    end
                end
                default       : begin 
                    exp_code = `ISA_EXP_UNDEF_INSN;
                end
            endcase
        end
    end

endmodule
//****************************************************************************************************
//End of Module
//****************************************************************************************************
