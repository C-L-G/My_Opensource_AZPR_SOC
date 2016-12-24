library verilog;
use verilog.vl_types.all;
entity chip_top is
    port(
        clk_ref         : in     vl_logic;
        reset_sw        : in     vl_logic;
        uart_rx         : in     vl_logic;
        uart_tx         : out    vl_logic;
        gpio_in         : in     vl_logic_vector(3 downto 0);
        gpio_out        : out    vl_logic_vector(17 downto 0);
        gpio_io         : inout  vl_logic_vector(15 downto 0)
    );
end chip_top;
