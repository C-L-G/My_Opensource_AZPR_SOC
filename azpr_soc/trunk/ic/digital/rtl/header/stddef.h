`ifndef __STDDEF_HEADER__
    `define __STDDEF_HEADER__
    `define HIGH                1'b1
    `define LOW                 1'b0
    `define ENABLE              1'b1
    `define DISABLE             1'b0
    `define ENABLE_N            1'b0
    `define DISABLE_N           1'b1
    `define READ                1'b1
    `define WRITE               1'b0
    `define LSB                 1'b0
    `define BYTE_DATA_W         8
    `define BYTE_MSB            7
    `define ByteDataBus         7:0
    `define WORD_DATA_W         32
    `define WORD_MSB            31
    `define WordDataBus         31:0
    `define WORD_ADDR_W         30
    `define WORD_ADDR_MSB       29
    `define WordAddrBus         29:0
    `define BYTE_OFFSET_W       2
    `define ByteOffsetBus       1:0
    `define WordAddrLoc         31:2
    `define ByteOffsetLoc       1:0
    `define BYTE_OFFSET_WORD    2'b00    

`endif

