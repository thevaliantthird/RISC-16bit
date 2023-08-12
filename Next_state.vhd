library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity decoder_1_ns is
	port(X_INPUT:in std_logic_vector(7 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
	end entity;

	architecture Behave of decoder_1_ns is
	begin
	process(X_INPUT)
	variable next_state_var: std_logic_vector(4 downto 0);
	begin

	if (X_INPUT(7 downto 4) = "0001" or X_INPUT(7 downto 4)="0010") then
		if(X_INPUT(3 downto 2) = "00") then
			next_state_var := "00011";
		elsif (X_INPUT(3 downto 2) = "01") then
			if(X_INPUT(0) = '1') then
				next_state_var := "00011";
			else
				next_state_var:= "00001";
			end if;
		elsif(X_INPUT(3 downto 2) = "10") then
			if(X_INPUT(1) = '1') then
				next_state_var := "00011";
			else
				next_state_var:= "00001";
			end if;
		elsif(X_INPUT(3 downto 2) = "11") then
			next_state_var := "00011";
		else
			next_state_var:="11111";
		end if;
	elsif (X_INPUT(7 downto 4) = "1111" or X_INPUT(7 downto 4) = "0101" or X_INPUT(7 downto 4) = "0111" ) then --ADI, LW, SW
		next_state_var := "00011";
	elsif (X_INPUT(7 downto 4) = "1101" or X_INPUT(7 downto 4) = "1100") then --LM SM
		next_state_var := "00110";
	elsif (X_INPUT(7 downto 4) = "0000") then --LHI
		next_state_var := "00100";
	elsif (X_INPUT(7 downto 4) = "1000") then --BEQ
		next_state_var := "01111";
	elsif (X_INPUT(7 downto 4) = "1001" or X_INPUT(7 downto 4) = "1010") then --JAL, JLR
		next_state_var := "10001";	
	elsif (X_INPUT(7 downto 4) = "1011") then --JRI
		next_state_var := "00011";
	else
		next_state_var:="11111";
	end if;

	Z_OUTPUT <= next_state_var;
	end process;
end architecture Behave;
-------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity decoder_2_ns is
	port(X_INPUT:in std_logic_vector(3 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end entity;

architecture Behave of decoder_2_ns is
	begin
	process(X_INPUT)
	variable next_state_var: std_logic_vector(4 downto 0);
	begin

	if(X_INPUT = "0001" or X_INPUT="0010" or X_INPUT="1111") then
		next_state_var:= "00100";
	elsif(X_INPUT = "0101") then --LW
		next_state_var:="00111";
	elsif(X_INPUT = "0111") then --SW
		next_state_var:="01001";
	elsif(X_INPUT = "1011") then --JRI
		next_state_var := "10100";
	else
		next_state_var:="11111";
	end if;

	Z_OUTPUT<= next_state_var;
	end process;
end architecture Behave;
-------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity decoder_3_ns is
	port(X_INPUT:in std_logic_vector(3 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end entity;

architecture Behave of decoder_3_ns is
	begin
	process(X_INPUT)
	variable next_state_var: std_logic_vector(4 downto 0);
	begin

	if(X_INPUT = "1101" ) then --LM
		next_state_var:= "01010";
	elsif(X_INPUT = "1100") then --SM
		next_state_var:="01100";
	elsif(X_INPUT = "0000") then --LHI
		next_state_var:="00100";
	elsif(X_INPUT = "1011") then --JRI
		next_state_var := "00011";
	else
		next_state_var:="11111";
	end if;

	Z_OUTPUT<= next_state_var;
	end process;
end architecture Behave;
-------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity decoder_4_ns is
	port(X_INPUT:in std_logic_vector(3 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end entity;

architecture Behave of decoder_4_ns is
	begin
	process(X_INPUT)
	variable next_state_var: std_logic_vector(4 downto 0);
	begin

	if(X_INPUT = "1001" ) then --JAL
		next_state_var:= "10010";
	elsif(X_INPUT = "1010") then -- JLR
		next_state_var:="10011";
	else
		next_state_var:="11111";
	end if;

	Z_OUTPUT<= next_state_var;
	end process;
end architecture Behave;
--------------------------------------

library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity decoder_5_ns is
	port(X_INPUT:in std_logic_vector(15 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end entity;

architecture Behave of decoder_5_ns is
	begin
	process(X_INPUT)
	variable next_state_var: std_logic_vector(4 downto 0);
	begin

	if(X_INPUT = "0000000000000000" ) then
		next_state_var:= "00001";
	else
		next_state_var:= "01010";
	end if;

	Z_OUTPUT<= next_state_var;
	end process;
end architecture Behave;
------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity decoder_6_ns is
	port(X_INPUT:in std_logic_vector(15 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end entity;

architecture Behave of decoder_6_ns is
	begin
	process(X_INPUT)
	variable next_state_var: std_logic_vector(4 downto 0);
	begin

	if(X_INPUT = "0000000000000000" ) then
		next_state_var:= "00001";
	else
		next_state_var:= "01100";
	end if;

	Z_OUTPUT<= next_state_var;
	end process;
end architecture Behave;


-----------------------------------------
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity Next_state is 
	port( x : in std_logic_vector(39 downto 0); zz : out std_logic_vector(4 downto 0));
end entity;

architecture Behave of Next_state is

component decoder_1_ns is
	port(X_INPUT:in std_logic_vector(7 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end component;

component decoder_2_ns is
	port(X_INPUT:in std_logic_vector(3 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end component;

component decoder_3_ns is
	port(X_INPUT:in std_logic_vector(3 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end component;

component decoder_4_ns is
	port(X_INPUT:in std_logic_vector(3 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end component;

component decoder_5_ns is
	port(X_INPUT:in std_logic_vector(15 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end component;

component decoder_6_ns is
	port(X_INPUT:in std_logic_vector(15 downto 0);
	Z_OUTPUT: out std_logic_vector( 4 downto 0));
end component;

signal sig1,sig2,sig3,sig4,sig5,sig6: std_logic_vector(4 downto 0);

begin
-------------------------------------
a: decoder_1_ns port map(X_INPUT(7 downto 4)=>x(39 downto 36),X_INPUT(3 downto 2)=>x(25 downto 24),X_INPUT(1 downto 0)=>x(23 downto 22),Z_OUTPUT=>sig1);
b: decoder_2_ns port map (X_INPUT(3 downto 0)=>x(39 downto 36),Z_OUTPUT=>sig2);
c: decoder_3_ns port map (X_INPUT(3 downto 0)=>x(39 downto 36),Z_OUTPUT=>sig3);
d: decoder_4_ns port map (X_INPUT(3 downto 0)=>x(39 downto 36),Z_OUTPUT=>sig4);
e: decoder_5_ns port map (X_INPUT(15 downto 0)=>x(21 downto 6),Z_OUTPUT=>sig5);
f: decoder_6_ns port map (X_INPUT(15 downto 0)=>x(21 downto 6),Z_OUTPUT=>sig6);
--------------------------------------

process(x,sig1,sig2,sig3,sig4,sig5,sig6)
begin
if(x(4 downto 0) = "00001") then
	zz<="00010";
elsif (x(4 downto 0) = "00010") then
	zz<=sig1;
elsif (x(4 downto 0) = "00011") then
	zz<=sig2;
elsif (x(4 downto 0) = "00100") then
	zz<="00001";
elsif (x(4 downto 0) = "00110" )then
	zz<=sig3;	
elsif (x(4 downto 0) = "00111") then
	zz<="01000";
elsif (x(4 downto 0) = "01000") then
	zz<="00001";	
elsif (x(4 downto 0) = "01001") then
	zz<="00001";		
elsif (x(4 downto 0) = "01010") then
	zz<="01011";	
elsif (x(4 downto 0) = "01011") then
	zz<=sig5;
elsif (x(4 downto 0) = "01100") then
	zz<="01101";	
elsif (x(4 downto 0) = "01101") then
	zz<="01110";	
elsif (x(4 downto 0) = "01110") then
	zz<=sig6;
elsif (x(4 downto 0) = "01111") then
	zz<="10000";	
elsif (x(4 downto 0) = "10000") then
	zz<="00001";		
elsif (x(4 downto 0) = "10001") then
	zz<=sig4;
elsif (x(4 downto 0) = "10010") then
	zz<="00001";	
elsif (x(4 downto 0) = "10011") then
	zz<="00001";	
elsif (x(4 downto 0) = "10100") then
	zz<="00001";
else
	zz<="11111";
end if;

end process;

end Behave;							