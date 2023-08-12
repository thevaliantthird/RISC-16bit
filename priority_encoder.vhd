library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priority_encoder is
-- Generic (CLOCK_BITS : INTEGER := 11)
port (
    INPUT_PORT : in std_logic_vector (7 downto 0);
    OUTPUT_ADDRESS : out std_logic_vector (2 downto 0);
    portforupdate : out std_logic_vector (7 downto 0)
  );
end entity priority_encoder;

architecture PriorityEncoder of priority_encoder is
begin
process(INPUT_PORT)
	begin
  if INPUT_PORT(0) = '1' then
    OUTPUT_ADDRESS <= "000";
    portforupdate(7 downto 1) <= INPUT_PORT(7 downto 1);
    portforupdate(0) <= '0';
  elsif INPUT_PORT(1) = '1' then
    OUTPUT_ADDRESS <= "001";
    portforupdate(7 downto 2) <= INPUT_PORT(7 downto  2);
    portforupdate(1 downto 0) <= "00";
  elsif INPUT_PORT(2) = '1' then
    OUTPUT_ADDRESS <= "010";
    portforupdate(7 downto 3) <= INPUT_PORT(7 downto 3);
    portforupdate(2 downto 0) <= "000";
  elsif INPUT_PORT(3) = '1' then
    OUTPUT_ADDRESS <= "011";
    portforupdate(7 downto 4) <= INPUT_PORT(7 downto 4);
    portforupdate(3 downto 0) <= "0000";
  elsif INPUT_PORT(4) = '1' then
    OUTPUT_ADDRESS <= "100";
    portforupdate(7 downto 5) <= INPUT_PORT(7 downto 5);
    portforupdate(4 downto 0) <= "00000";
  elsif INPUT_PORT(5) = '1' then
    OUTPUT_ADDRESS <= "101";
    portforupdate(7 downto 6) <= INPUT_PORT(7 downto 6);
    portforupdate(5 downto 0) <= "000000";
  elsif INPUT_PORT(6) = '1' then
    OUTPUT_ADDRESS <= "110";
    portforupdate(7) <= INPUT_PORT(7);
    portforupdate(6 downto 0) <= "0000000";
  elsif INPUT_PORT(7) = '1' then
    OUTPUT_ADDRESS <= "111";
    portforupdate <= "00000000";
  else
	 OUTPUT_ADDRESS <= (others => '0');
	 portforupdate <= (others => '0');
  end if;
end process;
end PriorityEncoder;
