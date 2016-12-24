library verilog;
use verilog.vl_types.all;
entity ex_stage is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        stall           : in     vl_logic;
        flush           : in     vl_logic;
        int_detect      : in     vl_logic;
        fwd_data        : out    vl_logic_vector(31 downto 0);
        id_pc           : in     vl_logic_vector(29 downto 0);
        id_en           : in     vl_logic;
        id_alu_op       : in     vl_logic_vector(3 downto 0);
        id_alu_in_0     : in     vl_logic_vector(31 downto 0);
        id_alu_in_1     : in     vl_logic_vector(31 downto 0);
        id_br_flag      : in     vl_logic;
        id_mem_op       : in     vl_logic_vector(1 downto 0);
        id_mem_wr_data  : in     vl_logic_vector(31 downto 0);
        id_ctrl_op      : in     vl_logic_vector(1 downto 0);
        id_dst_addr     : in     vl_logic_vector(4 downto 0);
        id_gpr_we_n     : in     vl_logic;
        id_exp_code     : in     vl_logic_vector(2 downto 0);
        ex_pc           : out    vl_logic_vector(29 downto 0);
        ex_en           : out    vl_logic;
        ex_br_flag      : out    vl_logic;
        ex_mem_op       : out    vl_logic_vector(1 downto 0);
        ex_mem_wr_data  : out    vl_logic_vector(31 downto 0);
        ex_ctrl_op      : out    vl_logic_vector(1 downto 0);
        ex_dst_addr     : out    vl_logic_vector(4 downto 0);
        ex_gpr_we_n     : out    vl_logic;
        ex_exp_code     : out    vl_logic_vector(2 downto 0);
        ex_out          : out    vl_logic_vector(31 downto 0)
    );
end ex_stage;
