library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        in_0            : in     vl_logic_vector(31 downto 0);
        in_1            : in     vl_logic_vector(31 downto 0);
        op              : in     vl_logic_vector(3 downto 0);
        \out\           : out    vl_logic_vector(31 downto 0);
        \of\            : out    vl_logic
    );
end alu;
