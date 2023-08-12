library ieee;
use ieee.std_logic_1164.all;

entity flip_flop is
  port (D, ENCODER, RST, CLOCK: in std_logic;
  Q: out std_logic);
end entity;

architecture flip of flip_flop is
begin

   process(CLOCK, ENCODER, D)
   begin

  if CLOCK'event and (CLOCK = '1') then
    if RST = '1' then
      Q <= '0';
    elsif(ENCODER='1') then
        Q <= D;
    end if;
	 end if;
   end process;

end flip;
