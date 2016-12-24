library verilog;
use verilog.vl_types.all;
entity timer is
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
        irq             : out    vl_logic
    );
end timer;
