library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE6 is
port (
    INPUT_PORT : in std_logic_vector (5 downto 0);
    OUTPUT_PORT : out std_logic_vector (15 downto 0)
  );
end entity SE6;

architecture SignedExtender of SE6 is
begin
  OUTPUT_PORT(5 downto 0) <= INPUT_PORT;
  process(INPUT_PORT)
  begin
  if INPUT_PORT(5) = '1' then
	OUTPUT_PORT(15 downto 6) <= (others=>'1');
  else
	OUTPUT_PORT(15 downto 6) <= (others=>'0');
end if;
end process;
end SignedExtender;
---------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE9 is
port (
    INPUT_PORT : in std_logic_vector (8 downto 0);
    OUTPUT_PORT : out std_logic_vector (15 downto 0)
  );
end entity SE9;

architecture SignedExtender of SE9 is
begin
  OUTPUT_PORT(8 downto 0) <= INPUT_PORT;
  process(INPUT_PORT)
  begin
  if INPUT_PORT(8) = '1' then
	OUTPUT_PORT(15 downto 9) <= (others=>'1');
  else
	OUTPUT_PORT(15 downto 9) <= (others=>'0');
end if;
end process;
end SignedExtender;
