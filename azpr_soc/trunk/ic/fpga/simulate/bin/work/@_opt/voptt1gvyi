library verilog;
use verilog.vl_types.all;
entity if_reg is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        insn            : in     vl_logic_vector(31 downto 0);
        stall           : in     vl_logic;
        flush           : in     vl_logic;
        new_pc          : in     vl_logic_vector(29 downto 0);
        br_taken        : in     vl_logic;
        br_addr         : in     vl_logic_vector(29 downto 0);
        if_pc           : out    vl_logic_vector(29 downto 0);
        if_insn         : out    vl_logic_vector(31 downto 0);
        if_en           : out    vl_logic
    );
end if_reg;
