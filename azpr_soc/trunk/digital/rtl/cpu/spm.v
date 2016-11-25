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
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------

//File Include : system header file
`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

//File Include : module header file
`include "spm.h"

module spm (
    //1.clock and reset if
    input  wire                clk              ,//clock
    //2.port a if stage
    input  wire [`SpmAddrBus]  if_spm_addr      ,//address
    input  wire                if_spm_as_n      ,//address strobe
    input  wire                if_spm_rw        ,// �ǂ݁^����
    input  wire [`WordDataBus] if_spm_wr_data   ,   // �������݃f�[�^
    output wire [`WordDataBus] if_spm_rd_data   ,   // �ǂݏo���f�[�^
    /********** �|�[�gB : MEM�X�e�[�W **********/
    //3.port b mem stage
    input  wire [`SpmAddrBus]  mem_spm_addr     ,   // �A�h���X
    input  wire                mem_spm_as_n     ,       // �A�h���X�X�g���[�u
    input  wire                mem_spm_rw       ,       // �ǂ݁^����
    input  wire [`WordDataBus] mem_spm_wr_data  , // �������݃f�[�^
    output wire [`WordDataBus] mem_spm_rd_data  // �ǂݏo���f�[�^
);

    /********** �������ݗL���M�� **********/
    reg                        wea;         // �|�[�g A
    reg                        web;         // �|�[�g B

    /********** �������ݗL���M���̐��� **********/
    always @(*) begin
        /* �|�[�g A */
        if ((if_spm_as_ == `ENABLE_) && (if_spm_rw == `WRITE)) begin   
            wea = `MEM_ENABLE;  // �������ݗL��
        end else begin
            wea = `MEM_DISABLE; // �������ݖ���
        end
        /* �|�[�g B */
        if ((mem_spm_as_ == `ENABLE_) && (mem_spm_rw == `WRITE)) begin
            web = `MEM_ENABLE;  // �������ݗL��
        end else begin
            web = `MEM_DISABLE; // �������ݖ���
        end
    end

    /********** Xilinx FPGA Block RAM : �f���A���|�[�gRAM **********/
    x_s3e_dpram x_s3e_dpram (
        /********** �|�[�g A : IF�X�e�[�W **********/
        .clka  (clk),             // �N���b�N
        .addra (if_spm_addr),     // �A�h���X
        .dina  (if_spm_wr_data),  // �������݃f�[�^�i���ڑ��j
        .wea   (wea),             // �������ݗL���i�l�Q�[�g�j
        .douta (if_spm_rd_data),  // �ǂݏo���f�[�^
        /********** �|�[�g B : MEM�X�e�[�W **********/
        .clkb  (clk),             // �N���b�N
        .addrb (mem_spm_addr),    // �A�h���X
        .dinb  (mem_spm_wr_data), // �������݃f�[�^
        .web   (web),             // �������ݗL��
        .doutb (mem_spm_rd_data)  // �ǂݏo���f�[�^
    );
  
endmodule
