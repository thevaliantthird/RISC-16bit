library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- This entity is for ALU
entity ALU is
    port(ao_p: in std_logic_vector(1 downto 0);
    alua: in std_logic_vector(15 downto 0);
    alub: in std_logic_vector(15 downto 0);
    aluc: out std_logic;
    aluz: out std_logic;
    aluou: out std_logic_vector(15 downto 0)
    );
end entity ALU;

-- architecture for ALU begins here
-- We had added the instructions for Add, NAND and ADL here, everything else is handled using these in the original
-- data path and control path files!
architecture ALU_arch of ALU is 
begin
    process(ao_p, alua, alub)
    variable alu_a, alu_b : std_logic_vector(16 downto 0);
    variable alu_o : std_logic_vector(16 downto 0);
    begin
        alu_a(15 downto 0) := alua;
        alu_a(16) := '0';
        alu_b(15 downto 0) := alub;
        alu_b(16) := '0';

        -- Addition instruction
        if ao_p = "00" then 
            alu_o := std_logic_vector(unsigned(alu_a) + unsigned(alu_b));
            
        elsif ao_p = "01" then 
            alu_o(15 downto 0) := std_logic_vector(unsigned(alu_a(15 downto 0)) - unsigned(alu_b(15 downto 0)));
            alu_o(16) := '0';
        
        -- NAND instruction
        elsif ao_p = "10" then
            alu_o(15 downto 0) := alu_a(15 downto 0) nand alu_b(15 downto 0);
            alu_o(16) := '0';
        
        -- adl
        elsif ao_p = "11" then
				alu_b := std_logic_vector(unsigned(alu_b) + unsigned(alu_b));
				alu_b(16) := '0';
            alu_o := std_logic_vector(unsigned(alu_a) + unsigned(alu_b));
        else
            alu_o(16 downto 0) := (others => '0');
        end if;

        -- Setting the output of the whole thing!
        aluou <= alu_o(15 downto 0);
        aluc <= alu_o(16);
        aluz <= not (alu_o(15) or alu_o(14) or alu_o(13) or alu_o(12) or alu_o(11) or alu_o(10) or alu_o(9) or alu_o(8) or alu_o(7) or alu_o(6) or alu_o(5) or alu_o(4) or alu_o(3) or alu_o(2) or alu_o(1) or alu_o(0));
    
    end process;
end architecture ALU_arch;



