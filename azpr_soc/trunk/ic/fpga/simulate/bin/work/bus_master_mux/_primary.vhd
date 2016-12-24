library verilog;
use verilog.vl_types.all;
entity bus_master_mux is
    port(
        m0_addr         : in     vl_logic_vector(29 downto 0);
        m0_as_n         : in     vl_logic;
        m0_rw           : in     vl_logic;
        m0_wr_data      : in     vl_logic_vector(31 downto 0);
        m0_grant_n      : in     vl_logic;
        m1_addr         : in     vl_logic_vector(29 downto 0);
        m1_as_n         : in     vl_logic;
        m1_rw           : in     vl_logic;
        m1_wr_data      : in     vl_logic_vector(31 downto 0);
        m1_grant_n      : in     vl_logic;
        m2_addr         : in     vl_logic_vector(29 downto 0);
        m2_as_n         : in     vl_logic;
        m2_rw           : in     vl_logic;
        m2_wr_data      : in     vl_logic_vector(31 downto 0);
        m2_grant_n      : in     vl_logic;
        m3_addr         : in     vl_logic_vector(29 downto 0);
        m3_as_n         : in     vl_logic;
        m3_rw           : in     vl_logic;
        m3_wr_data      : in     vl_logic_vector(31 downto 0);
        m3_grant_n      : in     vl_logic;
        s_addr          : out    vl_logic_vector(29 downto 0);
        s_as_n          : out    vl_logic;
        s_rw            : out    vl_logic;
        s_wr_data       : out    vl_logic_vector(31 downto 0)
    );
end bus_master_mux;
