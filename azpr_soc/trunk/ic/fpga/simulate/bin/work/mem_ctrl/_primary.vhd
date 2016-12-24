library verilog;
use verilog.vl_types.all;
entity mem_ctrl is
    port(
        ex_en           : in     vl_logic;
        ex_mem_op       : in     vl_logic_vector(1 downto 0);
        ex_mem_wr_data  : in     vl_logic_vector(31 downto 0);
        ex_out          : in     vl_logic_vector(31 downto 0);
        rd_data         : in     vl_logic_vector(31 downto 0);
        addr            : out    vl_logic_vector(29 downto 0);
        as_n            : out    vl_logic;
        rw              : out    vl_logic;
        wr_data         : out    vl_logic_vector(31 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0);
        miss_align      : out    vl_logic
    );
end mem_ctrl;
