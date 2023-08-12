library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  port(CLOC: in std_logic;
      memwrbar: in std_logic;
      addr: in std_logic_vector(15 downto 0);
      dinput: in std_logic_vector(15 downto 0);
      doutput: out std_logic_vector(15 downto 0));
end entity;

architecture mem of memory is
  type RAM_array is array (0 to 2**4-1) of std_logic_vector (15 downto 0);
	signal RAM : RAM_array:= (X"0115",X"02C7",X"1053",X"1098",others=>X"0000");
begin
  process(CLOC, memwrbar, dinput, addr, RAM)
    begin
    if rising_edge(CLOC) then
      if(memwrbar = '0') then
        RAM(to_integer(unsigned(addr)))<= dinput;
      end if;
    end if;
      doutput <= RAM(to_integer(unsigned(addr)));
  end process;
end architecture mem;
