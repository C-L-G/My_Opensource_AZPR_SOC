library verilog;
use verilog.vl_types.all;
entity uart_tx is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        tx_start        : in     vl_logic;
        tx_data         : in     vl_logic_vector(7 downto 0);
        tx_busy         : out    vl_logic;
        tx_end          : out    vl_logic;
        tx              : out    vl_logic
    );
end uart_tx;
