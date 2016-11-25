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
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//*---------------------------------------------------------------------------------------------------

`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "cpu.h"

module decoder (
    input  wire [`WordAddrBus]   if_pc,          // �v���O�����J�E���^
    input  wire [`WordDataBus]   if_insn,        // ����
    input  wire                  if_en,          // �p�C�v���C���f�[�^�̗L��
    input  wire [`WordDataBus]   gpr_rd_data_0, // �ǂݏo���f�[�^ 0
    input  wire [`WordDataBus]   gpr_rd_data_1, // �ǂݏo���f�[�^ 1
    output wire [`RegAddrBus]    gpr_rd_addr_0, // �ǂݏo���A�h���X 0
    output wire [`RegAddrBus]    gpr_rd_addr_1, // �ǂݏo���A�h���X 1
    input  wire                  id_en,         // �p�C�v���C���f�[�^�̗L��
    input  wire [`RegAddrBus]    id_dst_addr,   // �������݃A�h���X
    input  wire                  id_gpr_we_,    // �������ݗL��
    input  wire [`MemOpBus]      id_mem_op,     // �������I�y���[�V����
    input  wire                  ex_en,         // �p�C�v���C���f�[�^�̗L��
    input  wire [`RegAddrBus]    ex_dst_addr,   // �������݃A�h���X
    input  wire                  ex_gpr_we_,    // �������ݗL��
    input  wire [`WordDataBus]   ex_fwd_data,   // �t�H���[�f�B���O�f�[�^
    input  wire [`WordDataBus]   mem_fwd_data,  // �t�H���[�f�B���O�f�[�^
    input  wire [`CpuExeModeBus] exe_mode,      // ���s���[�h
    input  wire [`WordDataBus]   creg_rd_data,  // �ǂݏo���f�[�^
    output wire [`RegAddrBus]    creg_rd_addr,  // �ǂݏo���A�h���X
    output reg  [`AluOpBus]      alu_op,        // ALU�I�y���[�V����
    output reg  [`WordDataBus]   alu_in_0,      // ALU���� 0
    output reg  [`WordDataBus]   alu_in_1,      // ALU���� 1
    output reg  [`WordAddrBus]   br_addr,       // ����A�h���X
    output reg                   br_taken,      // ����̐���
    output reg                   br_flag,       // ����t���O
    output reg  [`MemOpBus]      mem_op,        // �������I�y���[�V����
    output wire [`WordDataBus]   mem_wr_data,   // �������������݃f�[�^
    output reg  [`CtrlOpBus]     ctrl_op,       // ����I�y���[�V����
    output reg  [`RegAddrBus]    dst_addr,      // �ėp���W�X�^�������݃A�h���X
    output reg                   gpr_we_,       // �ėp���W�X�^�������ݗL��
    output reg  [`IsaExpBus]     exp_code,      // ��O�R�[�h
    output reg                   ld_hazard      // ���[�h�n�U�[�h
);

    wire [`IsaOpBus]    op      = if_insn[`IsaOpLoc];     // �I�y�R�[�h
    wire [`RegAddrBus]  ra_addr = if_insn[`IsaRaAddrLoc]; // Ra�A�h���X
    wire [`RegAddrBus]  rb_addr = if_insn[`IsaRbAddrLoc]; // Rb�A�h���X
    wire [`RegAddrBus]  rc_addr = if_insn[`IsaRcAddrLoc]; // Rc�A�h���X
    wire [`IsaImmBus]   imm     = if_insn[`IsaImmLoc];    // ���l
    wire [`WordDataBus] imm_s = {{`ISA_EXT_W{imm[`ISA_IMM_MSB]}}, imm};
    wire [`WordDataBus] imm_u = {{`ISA_EXT_W{1'b0}}, imm};
    assign gpr_rd_addr_0 = ra_addr; // �ėp���W�X�^�ǂݏo���A�h���X 0
    assign gpr_rd_addr_1 = rb_addr; // �ėp���W�X�^�ǂݏo���A�h���X 1
    assign creg_rd_addr  = ra_addr; // ���䃌�W�X�^�ǂݏo���A�h���X
    reg         [`WordDataBus]  ra_data;                          // �����Ȃ�Ra
    wire signed [`WordDataBus]  s_ra_data = $signed(ra_data);     // �����t��Ra
    reg         [`WordDataBus]  rb_data;                          // �����Ȃ�Rb
    wire signed [`WordDataBus]  s_rb_data = $signed(rb_data);     // �����t��Rb
    assign mem_wr_data = rb_data; // �������������݃f�[�^
    wire [`WordAddrBus] ret_addr  = if_pc + 1'b1;                    // �߂�Ԓn
    wire [`WordAddrBus] br_target = if_pc + imm_s[`WORD_ADDR_MSB:0]; // �����
    wire [`WordAddrBus] jr_target = ra_data[`WordAddrLoc];         // �W�����v��

    always @(*) begin
        if ((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_) && 
            (id_dst_addr == ra_addr)) begin
            ra_data = ex_fwd_data;   // EX�X�e�[�W����̃t�H���[�f�B���O
        end else if ((ex_en == `ENABLE) && (ex_gpr_we_ == `ENABLE_) && 
                     (ex_dst_addr == ra_addr)) begin
            ra_data = mem_fwd_data;  // MEM�X�e�[�W����̃t�H���[�f�B���O
        end else begin
            ra_data = gpr_rd_data_0; // ���W�X�^�t�@�C������̓ǂݏo��
        end
        if ((id_en == `ENABLE) && (id_gpr_we_ == `ENABLE_) && 
            (id_dst_addr == rb_addr)) begin
            rb_data = ex_fwd_data;   // EX�X�e�[�W����̃t�H���[�f�B���O
        end else if ((ex_en == `ENABLE) && (ex_gpr_we_ == `ENABLE_) && 
                     (ex_dst_addr == rb_addr)) begin
            rb_data = mem_fwd_data;  // MEM�X�e�[�W����̃t�H���[�f�B���O
        end else begin
            rb_data = gpr_rd_data_1; // ���W�X�^�t�@�C������̓ǂݏo��
        end
    end

    always @(*) begin
        if ((id_en == `ENABLE) && (id_mem_op == `MEM_OP_LDW) &&
            ((id_dst_addr == ra_addr) || (id_dst_addr == rb_addr))) begin
            ld_hazard = `ENABLE;  // ���[�h�n�U�[�h
        end else begin
            ld_hazard = `DISABLE; // �n�U�[�h�Ȃ�
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
        gpr_we_  = `DISABLE_;
        exp_code = `ISA_EXP_NO_EXP;
        if (if_en == `ENABLE) begin
            case (op)
                `ISA_OP_ANDR  : begin // ���W�X�^���m�̘_����
                    alu_op   = `ALU_OP_AND;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_ANDI  : begin // ���W�X�^�Ƒ��l�̘_����
                    alu_op   = `ALU_OP_AND;
                    alu_in_1 = imm_u;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_ORR   : begin // ���W�X�^���m�̘_���a
                    alu_op   = `ALU_OP_OR;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_ORI   : begin // ���W�X�^�Ƒ��l�̘_���a
                    alu_op   = `ALU_OP_OR;
                    alu_in_1 = imm_u;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_XORR  : begin // ���W�X�^���m�̔r���I�_���a
                    alu_op   = `ALU_OP_XOR;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_XORI  : begin // ���W�X�^�Ƒ��l�̔r���I�_���a
                    alu_op   = `ALU_OP_XOR;
                    alu_in_1 = imm_u;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_ADDSR : begin // ���W�X�^���m�̕����t�����Z
                    alu_op   = `ALU_OP_ADDS;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_ADDSI : begin // ���W�X�^�Ƒ��l�̕����t�����Z
                    alu_op   = `ALU_OP_ADDS;
                    alu_in_1 = imm_s;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_ADDUR : begin // ���W�X�^���m�̕����Ȃ����Z
                    alu_op   = `ALU_OP_ADDU;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_ADDUI : begin // ���W�X�^�Ƒ��l�̕����Ȃ����Z
                    alu_op   = `ALU_OP_ADDU;
                    alu_in_1 = imm_s;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_SUBSR : begin // ���W�X�^���m�̕����t�����Z
                    alu_op   = `ALU_OP_SUBS;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_SUBUR : begin // ���W�X�^���m�̕����Ȃ����Z
                    alu_op   = `ALU_OP_SUBU;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                /* �V�t�g���� */
                `ISA_OP_SHRLR : begin // ���W�X�^���m�̘_���E�V�t�g
                    alu_op   = `ALU_OP_SHRL;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_SHRLI : begin // ���W�X�^�Ƒ��l�̘_���E�V�t�g
                    alu_op   = `ALU_OP_SHRL;
                    alu_in_1 = imm_u;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_SHLLR : begin // ���W�X�^���m�̘_�����V�t�g
                    alu_op   = `ALU_OP_SHLL;
                    dst_addr = rc_addr;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_SHLLI : begin // ���W�X�^�Ƒ��l�̘_�����V�t�g
                    alu_op   = `ALU_OP_SHLL;
                    alu_in_1 = imm_u;
                    gpr_we_  = `ENABLE_;
                end
                /* ���򖽗� */
                `ISA_OP_BE    : begin // ���W�X�^���m�̕����t����r�iRa == Rb�j
                    br_addr  = br_target;
                    br_taken = (ra_data == rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_BNE   : begin // ���W�X�^���m�̕����t����r�iRa != Rb�j
                    br_addr  = br_target;
                    br_taken = (ra_data != rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_BSGT  : begin // ���W�X�^���m�̕����t����r�iRa < Rb�j
                    br_addr  = br_target;
                    br_taken = (s_ra_data < s_rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_BUGT  : begin // ���W�X�^���m�̕����Ȃ���r�iRa < Rb�j
                    br_addr  = br_target;
                    br_taken = (ra_data < rb_data) ? `ENABLE : `DISABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_JMP   : begin // ����������
                    br_addr  = jr_target;
                    br_taken = `ENABLE;
                    br_flag  = `ENABLE;
                end
                `ISA_OP_CALL  : begin // �R�[��
                    alu_in_0 = {ret_addr, {`BYTE_OFFSET_W{1'b0}}};
                    br_addr  = jr_target;
                    br_taken = `ENABLE;
                    br_flag  = `ENABLE;
                    dst_addr = `REG_ADDR_W'd31;
                    gpr_we_  = `ENABLE_;
                end
                /* �������A�N�Z�X���� */
                `ISA_OP_LDW   : begin // ���[�h�ǂݏo��
                    alu_op   = `ALU_OP_ADDU;
                    alu_in_1 = imm_s;
                    mem_op   = `MEM_OP_LDW;
                    gpr_we_  = `ENABLE_;
                end
                `ISA_OP_STW   : begin // ���[�h��������
                    alu_op   = `ALU_OP_ADDU;
                    alu_in_1 = imm_s;
                    mem_op   = `MEM_OP_STW;
                end
                `ISA_OP_TRAP  : begin // �g���b�v
                    exp_code = `ISA_EXP_TRAP;
                end
                `ISA_OP_RDCR  : begin // ���䃌�W�X�^�̓ǂݏo��
                    if (exe_mode == `CPU_KERNEL_MODE) begin
                        alu_in_0 = creg_rd_data;
                        gpr_we_  = `ENABLE_;
                    end else begin
                        exp_code = `ISA_EXP_PRV_VIO;
                    end
                end
                `ISA_OP_WRCR  : begin // ���䃌�W�X�^�ւ̏�������
                    if (exe_mode == `CPU_KERNEL_MODE) begin
                        ctrl_op  = `CTRL_OP_WRCR;
                    end else begin
                        exp_code = `ISA_EXP_PRV_VIO;
                    end
                end
                `ISA_OP_EXRT  : begin // ��O����̕��A
                    if (exe_mode == `CPU_KERNEL_MODE) begin
                        ctrl_op  = `CTRL_OP_EXRT;
                    end else begin
                        exp_code = `ISA_EXP_PRV_VIO;
                    end
                end
                default       : begin // ����`����
                    exp_code = `ISA_EXP_UNDEF_INSN;
                end
            endcase
        end
    end

endmodule
