
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "cpu.h"

module if_reg (
    input  wire                clk,        
    input  wire                reset,      
    input  wire [`WordDataBus] insn,       
    input  wire                stall,      
    input  wire                flush,      
    input  wire [`WordAddrBus] new_pc,     
    input  wire                br_taken,   
    input  wire [`WordAddrBus] br_addr,    
    output reg  [`WordAddrBus] if_pc,      
    output reg  [`WordDataBus] if_insn,    
    output reg                 if_en       
);

    always @(posedge clk or `RESET_EDGE reset) begin
        if (reset == `RESET_ENABLE) begin 
            if_pc   <= #1 `RESET_VECTOR;
            if_insn <= #1 `ISA_NOP;
            if_en   <= #1 `DISABLE;
        end else begin
            if (stall == `DISABLE) begin 
                if (flush == `ENABLE) begin             
                    if_pc   <= #1 new_pc;
                    if_insn <= #1 `ISA_NOP;
                    if_en   <= #1 `DISABLE;
                end else if (br_taken == `ENABLE) begin 
                    if_pc   <= #1 br_addr;
                    if_insn <= #1 insn;
                    if_en   <= #1 `ENABLE;
                end else begin                          
                    if_pc   <= #1 if_pc + 1'd1;
                    if_insn <= #1 insn;
                    if_en   <= #1 `ENABLE;
                end
            end
        end
    end

endmodule
