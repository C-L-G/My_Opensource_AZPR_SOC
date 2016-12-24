library verilog;
use verilog.vl_types.all;
entity ctrl is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        creg_rd_addr    : in     vl_logic_vector(4 downto 0);
        creg_rd_data    : out    vl_logic_vector(31 downto 0);
        exe_mode        : out    vl_logic_vector(0 downto 0);
        irq             : in     vl_logic_vector(7 downto 0);
        int_detect      : out    vl_logic;
        id_pc           : in     vl_logic_vector(29 downto 0);
        mem_pc          : in     vl_logic_vector(29 downto 0);
        mem_en          : in     vl_logic;
        mem_br_flag     : in     vl_logic;
        mem_ctrl_op     : in     vl_logic_vector(1 downto 0);
        mem_dst_addr    : in     vl_logic_vector(4 downto 0);
        mem_exp_code    : in     vl_logic_vector(2 downto 0);
        mem_out         : in     vl_logic_vector(31 downto 0);
        if_busy         : in     vl_logic;
        ld_hazard       : in     vl_logic;
        mem_busy        : in     vl_logic;
        if_stall        : out    vl_logic;
        id_stall        : out    vl_logic;
        ex_stall        : out    vl_logic;
        mem_stall       : out    vl_logic;
        if_flush        : out    vl_logic;
        id_flush        : out    vl_logic;
        ex_flush        : out    vl_logic;
        mem_flush       : out    vl_logic;
        new_pc          : out    vl_logic_vector(29 downto 0)
    );
end ctrl;
