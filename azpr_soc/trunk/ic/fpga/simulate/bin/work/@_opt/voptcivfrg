library verilog;
use verilog.vl_types.all;
entity gpio is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        cs_n            : in     vl_logic;
        as_n            : in     vl_logic;
        rw              : in     vl_logic;
        addr            : in     vl_logic_vector(1 downto 0);
        wr_data         : in     vl_logic_vector(31 downto 0);
        rd_data         : out    vl_logic_vector(31 downto 0);
        rdy_n           : out    vl_logic;
        gpio_in         : in     vl_logic_vector(3 downto 0);
        gpio_out        : out    vl_logic_vector(17 downto 0);
        gpio_io         : inout  vl_logic_vector(15 downto 0)
    );
end gpio;
