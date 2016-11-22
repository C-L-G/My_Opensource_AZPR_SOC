`ifndef __ISA_HEADER__
    `define __ISA_HEADER__
    
    `define ISA_NOP             32'h0
    `define ISA_OP_W            6
    `define IsaOpBus            5:0
    `define IsaOpLoc            31:26
    //Register Logic
    `define ISA_OP_ANDR         6'h00   
    `define ISA_OP_ANDI         6'h01
    `define ISA_OP_ORR          6'h02
    `define ISA_OP_ORI          6'h03
    `define ISA_OP_XORR         6'h04
    `define ISA_OP_XORI         6'h05
    `define ISA_OP_ADDSR        6'h06
    `define ISA_OP_ADDSI        6'h07
    `define ISA_OP_ADDUR        6'h08
    `define ISA_OP_ADDUI        6'h09
    `define ISA_OP_SUBSR        6'h0a
    `define ISA_OP_SUBUR        6'h0b
    `define ISA_OP_SHRLR        6'h0c
    `define ISA_OP_SHRLI        6'h0d
    `define ISA_OP_SHLLR        6'h0e
    `define ISA_OP_SHLLI        6'h0f
    `define ISA_OP_BE           6'h10
    `define ISA_OP_BNE          6'h11
    `define ISA_OP_BSGT         6'h12
    `define ISA_OP_BUGT         6'h13
    `define ISA_OP_JMP          6'h14
    `define ISA_OP_CALL         6'h15
    `define ISA_OP_LDW          6'h16
    `define ISA_OP_STW          6'h17
    `define ISA_OP_TRAP         6'h18
    `define ISA_OP_RDCR         6'h19
    `define ISA_OP_WRCR         6'h1a
    `define ISA_OP_EXRT         6'h1b
    //ISA REG
    `define ISA_REG_ADDR_W      5
    `define IsaRegAddrBus       4:0
    `define IsaRaAddrLoc        25:21
    `define IsaRbAddrLoc        20:16
    `define IsaRcAddrLoc        15:11
    //ISA 
    `define ISA_IMM_W           16
    `define ISA_EXT_W           15
    `define ISA_IMM_MSB         15
    `define IsaImmBus           15:0
    `define IsaImmLoc           15:0
    //ISA EXP
    `define ISA_EXP_W           3
    `define IsaExpBus           2:0
    `define ISA_EXP_NO_EXP      3'h0
    `define ISA_EXP_EXT_INT     3'h1
    `define ISA_EXP_UNDEF_INSN  3'h2
    `define ISA_EXP_OVERFLOW    3'h3
    `define ISA_EXP_MISS_ALIGN  3'h4
    `define ISA_EXP_TRAP        3'h5
    `define ISA_EXP_PRV_VIO     3'h6

`endif
