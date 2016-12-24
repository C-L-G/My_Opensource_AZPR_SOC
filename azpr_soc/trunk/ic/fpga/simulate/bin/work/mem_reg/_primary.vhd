library verilog;
use verilog.vl_types.all;
entity mem_reg is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        \out\           : in     vl_logic_vector(31 downto 0);
        miss_align      : in     vl_logic;
        stall           : in     vl_logic;
        flush           : in     vl_logic;
        ex_pc           : in     vl_logic_vector(29 downto 0);
        ex_en           : in     vl_logic;
        ex_br_flag      : in     vl_logic;
        ex_ctrl_op      : in     vl_logic_vector(1 downto 0);
        ex_dst_addr     : in     vl_logic_vector(4 downto 0);
        ex_gpr_we_n     : in     vl_logic;
        ex_exp_code     : in     vl_logic_vector(2 downto 0);
        mem_pc          : out    vl_logic_vector(29 downto 0);
        mem_en          : out    vl_logic;
        mem_br_flag     : out    vl_logic;
        mem_ctrl_op     : out    vl_logic_vector(1 downto 0);
        mem_dst_addr    : out    vl_logic_vector(4 downto 0);
        mem_gpr_we_n    : out    vl_logic;
        mem_exp_code    : out    vl_logic_vector(2 downto 0);
        mem_out         : out    vl_logic_vector(31 downto 0)
    );
end mem_reg;
