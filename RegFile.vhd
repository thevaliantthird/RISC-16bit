library ieee;
use ieee.std_logic_1164.all;

entity reg is
Generic (NUM_BITS : INTEGER := 16);
  port (ENCODER, RST, CLOCK: in std_logic;
        INPUT_PORT: in std_logic_vector(NUM_BITS-1 downto 0);
        OUTPUT_PORT: out std_logic_vector(NUM_BITS-1 downto 0)
		  );
end entity;

architecture reg_arch of reg is
begin
reg1 : process(CLOCK, ENCODER, INPUT_PORT)
begin
  if CLOCK'event and CLOCK = '1' then
    if RST = '1' then
      OUTPUT_PORT(NUM_BITS-1 downto 0) <= (others=>'0');
    elsif ENCODER = '1' then
      OUTPUT_PORT <= INPUT_PORT;
    end if;
  end if;
end process;

end reg_arch;
-------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reg_3bit is
  port (ENCODER, RST, CLOCK: in std_logic;
        INPUT_PORT: in std_logic_vector(2 downto 0);
        OUTPUT_PORT: out std_logic_vector(2 downto 0)
		  );
end entity;

architecture reg3_arch of reg_3bit is
begin
reg1 : process(CLOCK, RST, ENCODER, INPUT_PORT)
begin
  if CLOCK'event and CLOCK = '1' then
  if RST = '1' then
    OUTPUT_PORT(2 downto 0) <= (others=>'0');
  elsif ENCODER = '1' then
      OUTPUT_PORT <= INPUT_PORT;
    end if;
  end if;
end process;

end reg3_arch;

-----------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity RegFile is
Generic (NUM_BITS : INTEGER := 16);
port (
    CLOCK ,RST: in std_logic;
    regfaddr1, regfaddr2, regfaddr3 : in std_logic_vector (2 downto 0);
    regfdaddr3 : in std_logic_vector(NUM_BITS - 1 downto 0);
    regfdaddr1, regfdaddr2 : out std_logic_vector(NUM_BITS - 1 downto 0);
    alu2regsev, t22regsev, progcount2regsev : in std_logic_vector (NUM_BITS - 1 downto 0);
    regfwrite: in std_logic;
    regwrimuxx : in std_logic_vector(1 downto 0)
  );
end entity RegFile;

architecture Register_file of RegFile is

component reg is
Generic (NUM_BITS : INTEGER := 16);
  port (ENCODER, RST, CLOCK: in std_logic;
        INPUT_PORT: in std_logic_vector(NUM_BITS-1 downto 0);
        OUTPUT_PORT: out std_logic_vector(NUM_BITS-1 downto 0)
		  );
end component;


type rin is array(0 to 7) of std_logic_vector(NUM_BITS - 1 downto 0);
signal reg_in,reg_out : rin;
signal wr_enable,wr_enable_final: std_logic_vector(7 downto 0);

begin

regfdaddr1 <= reg_out(to_integer(unsigned(regfaddr1)));
regfdaddr2 <= reg_out(to_integer(unsigned(regfaddr2)));

with regfaddr3 select
 wr_enable <= 	"10000001" when "000",
					"10000010" when "001",
					"10000100" when "010",
					"10001000" when "011",
					"10010000" when "100",
					"10100000" when "101",
					"11000000" when "110",
					"10000000" when "111",
					"00000000" when others;

  reg_in(0) <= regfdaddr3;
  reg_in(1) <= regfdaddr3;
  reg_in(2) <= regfdaddr3;
  reg_in(3) <= regfdaddr3;
  reg_in(4) <= regfdaddr3;
  reg_in(5) <= regfdaddr3;
  reg_in(6) <= regfdaddr3;
with regwrimuxx select reg_in(7) <=
        regfdaddr3 when "00",
        progcount2regsev when "01",
        t22regsev when "10",
        alu2regsev when "11",
		  (others => '0') when others;

wr_enable_final(0) <= wr_enable(0) and regfwrite;
wr_enable_final(1) <= wr_enable(1) and regfwrite;
wr_enable_final(2) <= wr_enable(2) and regfwrite;
wr_enable_final(3) <= wr_enable(3) and regfwrite;
wr_enable_final(4) <= wr_enable(4) and regfwrite;
wr_enable_final(5) <= wr_enable(5) and regfwrite;
wr_enable_final(6) <= wr_enable(6) and regfwrite;
wr_enable_final(7) <= wr_enable(7) and regfwrite; 

  R : for n in 0 to 7 generate
      Rn: reg port map(ENCODER =>wr_enable_final(n),RST => RST,CLOCK => CLOCK,INPUT_PORT=>reg_in(n),OUTPUT_PORT=>reg_out(n));
  end generate R;

end Register_file;

