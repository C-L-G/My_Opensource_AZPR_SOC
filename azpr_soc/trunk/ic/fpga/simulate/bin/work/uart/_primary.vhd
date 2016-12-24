library verilog;
use verilog.vl_types.all;
entity uart is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        cs_n            : in     vl_logic;
        as_n            : in     vl_logic;
        rw              : in     vl_logic;
        addr            : in     vl_logic_vector(0 downto 0);
        wr_data         : in     vl_logic_vector(31 downto 0);
        rd_data         : out    vl_logic_vector(31 downto 0);
        rdy_n           : out    vl_logic;
        irq_rx          : out    vl_logic;
        irq_tx          : out    vl_logic;
        rx              : in     vl_logic;
        tx              : out    vl_logic
    );
end uart;
