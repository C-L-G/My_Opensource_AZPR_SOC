library verilog;
use verilog.vl_types.all;
entity bus_if is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        stall           : in     vl_logic;
        flush           : in     vl_logic;
        busy            : out    vl_logic;
        addr            : in     vl_logic_vector(29 downto 0);
        as_n            : in     vl_logic;
        rw              : in     vl_logic;
        wr_data         : in     vl_logic_vector(31 downto 0);
        rd_data         : out    vl_logic_vector(31 downto 0);
        spm_rd_data     : in     vl_logic_vector(31 downto 0);
        spm_addr        : out    vl_logic_vector(29 downto 0);
        spm_as_n        : out    vl_logic;
        spm_rw          : out    vl_logic;
        spm_wr_data     : out    vl_logic_vector(31 downto 0);
        bus_rd_data     : in     vl_logic_vector(31 downto 0);
        bus_rdy_n       : in     vl_logic;
        bus_grant_n     : in     vl_logic;
        bus_req_n       : out    vl_logic;
        bus_addr        : out    vl_logic_vector(29 downto 0);
        bus_as_n        : out    vl_logic;
        bus_rw          : out    vl_logic;
        bus_wr_data     : out    vl_logic_vector(31 downto 0)
    );
end bus_if;
