library verilog;
use verilog.vl_types.all;
entity bus_addr_dec is
    port(
        s_addr          : in     vl_logic_vector(29 downto 0);
        s0_cs_n         : out    vl_logic;
        s1_cs_n         : out    vl_logic;
        s2_cs_n         : out    vl_logic;
        s3_cs_n         : out    vl_logic;
        s4_cs_n         : out    vl_logic;
        s5_cs_n         : out    vl_logic;
        s6_cs_n         : out    vl_logic;
        s7_cs_n         : out    vl_logic
    );
end bus_addr_dec;
