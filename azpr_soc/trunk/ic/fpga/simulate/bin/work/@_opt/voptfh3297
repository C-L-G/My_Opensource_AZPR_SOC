library verilog;
use verilog.vl_types.all;
entity cpu is
    port(
        clk             : in     vl_logic;
        clk_n           : in     vl_logic;
        reset           : in     vl_logic;
        if_bus_rd_data  : in     vl_logic_vector(31 downto 0);
        if_bus_rdy_n    : in     vl_logic;
        if_bus_grant_n  : in     vl_logic;
        if_bus_req_n    : out    vl_logic;
        if_bus_addr     : out    vl_logic_vector(29 downto 0);
        if_bus_as_n     : out    vl_logic;
        if_bus_rw       : out    vl_logic;
        if_bus_wr_data  : out    vl_logic_vector(31 downto 0);
        mem_bus_rd_data : in     vl_logic_vector(31 downto 0);
        mem_bus_rdy_n   : in     vl_logic;
        mem_bus_grant_n : in     vl_logic;
        mem_bus_req_n   : out    vl_logic;
        mem_bus_addr    : out    vl_logic_vector(29 downto 0);
        mem_bus_as_n    : out    vl_logic;
        mem_bus_rw      : out    vl_logic;
        mem_bus_wr_data : out    vl_logic_vector(31 downto 0);
        cpu_irq         : in     vl_logic_vector(7 downto 0)
    );
end cpu;
