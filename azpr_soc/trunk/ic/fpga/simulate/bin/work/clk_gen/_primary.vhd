library verilog;
use verilog.vl_types.all;
entity clk_gen is
    port(
        clk_ref         : in     vl_logic;
        reset_sw        : in     vl_logic;
        clk             : out    vl_logic;
        clk_n           : out    vl_logic;
        chip_reset      : out    vl_logic
    );
end clk_gen;
