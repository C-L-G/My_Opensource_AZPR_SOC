library verilog;
use verilog.vl_types.all;
entity gpr is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        rd_addr_0       : in     vl_logic_vector(4 downto 0);
        rd_data_0       : out    vl_logic_vector(31 downto 0);
        rd_addr_1       : in     vl_logic_vector(4 downto 0);
        rd_data_1       : out    vl_logic_vector(31 downto 0);
        we_n            : in     vl_logic;
        wr_addr         : in     vl_logic_vector(29 downto 0);
        wr_data         : in     vl_logic_vector(31 downto 0)
    );
end gpr;
