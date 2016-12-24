library verilog;
use verilog.vl_types.all;
entity spm is
    port(
        clk             : in     vl_logic;
        if_spm_addr     : in     vl_logic_vector(11 downto 0);
        if_spm_as_n     : in     vl_logic;
        if_spm_rw       : in     vl_logic;
        if_spm_wr_data  : in     vl_logic_vector(31 downto 0);
        if_spm_rd_data  : out    vl_logic_vector(31 downto 0);
        mem_spm_addr    : in     vl_logic_vector(11 downto 0);
        mem_spm_as_n    : in     vl_logic;
        mem_spm_rw      : in     vl_logic;
        mem_spm_wr_data : in     vl_logic_vector(31 downto 0);
        mem_spm_rd_data : out    vl_logic_vector(31 downto 0)
    );
end spm;
