library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;


-- This entity defines the overall signals which we use in order to control what step to take
-- This has encoders, alumuxes, memory write muxes, register write muxes, Progam counter muxes, and encoders, temporary register muxes and everything
-- These are used in order to direct the overall program flow.
entity control_signal is
	port(X_INPUT: in std_logic_vector(26 downto 0);
	ao_p: out std_logic_vector(1 downto 0);
	alua_mux: out std_logic_vector( 1 downto 0);
	alub_mux: out std_logic_vector( 2 downto 0);
	registerfen: out std_logic;
	regwrimuxx: out std_logic_vector( 1 downto 0);
	regaddr1mux: out std_logic_vector( 1 downto 0);
	regaddr3mux: out std_logic_vector( 2 downto 0);
	regdest3mux: out std_logic_vector( 1 downto 0);
	memwrbar: out std_logic;
	memoryaddrmux: out std_logic_vector( 1 downto 0);
	memorydestmux: out std_logic;
	encodet1: out std_logic;
	encodet2: out std_logic;
	encodet3: out std_logic;
	encodet4: out std_logic;
	pcencode: out std_logic;
	instregencode: out std_logic;
	tempZencode: out std_logic;
	flagCencode:out std_logic;
	flagZencode: out std_logic;
	tem1multi: out std_logic_vector(1 downto 0);
	tem2multi: out std_logic_vector(1 downto 0);
	tem3multi: out std_logic;
	progcountmulti: out std_logic_vector(2 downto 0));
end entity;


-- This is behavioural code, this would actually translate to a cascade of muxes in the actual circuit.
-- This doesn't only guarantee that we would be able to do everything way more efficiently but also in a systematic way with proceese
-- With muxes we also need to do concurrent analysis to make sure no collisions happen.
architecture Behave of control_signal is
begin
process(X_INPUT)
begin
if(X_INPUT(22 downto 18)="00001") then
    ao_p<="00";
	alua_mux<="00";
	alub_mux<="001";
	registerfen<='0';
	regwrimuxx<="00";
	regaddr1mux<= "00";
	regaddr3mux<= "000";
	regdest3mux<= "00";
	memwrbar<='1';
	memoryaddrmux<="00";
	memorydestmux<='1';
	encodet1<= '0';
	encodet2<= '0';
	encodet3<= '0';
	encodet4<= '0';
	pcencode<= '1';
	instregencode<= '1';
	flagCencode<='0';
	flagZencode<= '0';
	tem1multi<= "00";
	tem2multi<= "00";
	tem3multi<='0';
	progcountmulti<= "000";
	tempZencode<='1';

--2nd State
elsif(X_INPUT(22 downto 18)="00010") then
	tempZencode<='1';
	ao_p<="00";
	alua_mux<="00";
	alub_mux<="001";
	regwrimuxx<="01";
	regaddr1mux<= "00";
	regaddr3mux<= "010"; 
	regdest3mux<= "00";
	memwrbar<='1';
	memoryaddrmux<="00";
	memorydestmux<='1';
	encodet3<= '0';
	encodet4<= '0';
	pcencode<= '0';
	instregencode<= '0';
	tem3multi<='0';
	progcountmulti<= "000";
	encodet1<= '1';
	encodet2<= '1';
	flagCencode<='0';
	flagZencode<= '0';
	tem1multi<= "00";
	tem2multi<= "00";
	if((X_INPUT(17 downto 14)="0001" or X_INPUT(17 downto 14)="0010" ) and X_INPUT(3 downto 1)="100" ) then --AD(D,C,Z_OUTPUT,L)  ND(U,C,Z_OUTPUT)
		registerfen<='1';
	elsif((X_INPUT(17 downto 14)="0001" or X_INPUT(17 downto 14)="0010" ) and X_INPUT(3 downto 2)="01" and X_INPUT(0) = '0') then --AD(D,C,Z_OUTPUT,L)  ND(U,C,Z_OUTPUT)
		registerfen<='1';
	else
		registerfen<='0';
	end if;
---3rd State
elsif(X_INPUT(22 downto 18)="00011") then
	tempZencode<='1';
	memwrbar<='1';
	memoryaddrmux<="00";
	memorydestmux<='1';
	encodet3<= '0';
	encodet4<= '0';
	pcencode<= '0';
	instregencode<= '0';
	tem3multi<='0';
	progcountmulti<= "000";
	registerfen<='0';
	regwrimuxx<="01";
	regaddr1mux<= "00";
	regaddr3mux<= "010";
	regdest3mux<= "00";
	if (X_INPUT(17 downto 14) = "0001" or X_INPUT(17 downto 14) = "0010") then 
		alua_mux<="01";
		alub_mux<="010";
		encodet1<= '1';
		encodet2<= '0';
		tem1multi<= "01";
		tem2multi<= "00";
		if(X_INPUT(17 downto 14) = "0001" and X_INPUT(3 downto 2) = "11") then 
			ao_p <= "11";
		elsif (X_INPUT(17 downto 14) = "0001" and X_INPUT(3 downto 2) /= "11") then 
			ao_p <= "00";
		else
			ao_p<="10";
		end if;

		if(X_INPUT(17 downto 14) = "0001") then 
			flagCencode<='1';
			flagZencode<= '1';
		else
			flagCencode<='0';
			flagZencode<= '1';
		end if;
		
	elsif(X_INPUT(17 downto 14) = "1111") then --ADI
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="100";
		encodet1<= '1';
		encodet2<= '0';
		flagCencode<='1';
		flagZencode<= '1';
		tem1multi<= "01";
		tem2multi<= "00";

	elsif(X_INPUT(17 downto 14) = "0101") then --LW
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		encodet1<= '1';
		encodet2<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "00";

	elsif(X_INPUT(17 downto 14)="0111") then --SW
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		encodet1<= '0';
		encodet2<= '1';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "00";
		tem2multi<= "01";

	elsif(X_INPUT(17 downto 14)="1011") then --JRI
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="101";
		encodet1<= '1';
		encodet2<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "00";


	else
		ao_p<="11";
		alua_mux<="10";
		alub_mux<="100";
		encodet1<= '0';
		encodet2<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "00";
		tem2multi<= "01";
	end if;
---4th State
elsif(X_INPUT(22 downto 18)="00100") then
	tempZencode<='1';
	ao_p<="00";
	alua_mux<="10";
	alub_mux<="100";
	memwrbar<='1';
	memoryaddrmux<="00";
	memorydestmux<='1';
	encodet1<= '0';
	encodet2<= '0';
	encodet3<= '0';
	encodet4<= '0';
	instregencode<= '0';
	flagCencode<='0';
	flagZencode<= '0';
	tem1multi<= "00";
	tem2multi<= "01";
	tem3multi<='0';

	if (X_INPUT(17 downto 14) = "0001" or X_INPUT(17 downto 14) = "0010") then 
		registerfen<='1';
		regaddr1mux<= "00";
		regaddr3mux<= "001";
		regdest3mux<= "00";
		progcountmulti<= "010";
		if(X_INPUT(7 downto 5)="111") then
		regwrimuxx<="00";
		else
		regwrimuxx<="01";
		end if;
		if(X_INPUT(7 downto 5) = "111") then
		pcencode<= '1';
		else
		pcencode<= '0';
		end if;
	elsif(X_INPUT(17 downto 14)="1111") then --The sections which deal with ADI
		registerfen<='1';
		regaddr1mux<= "00";
		regaddr3mux<= "011";
		regdest3mux<= "00";
		progcountmulti<= "010";
		if(X_INPUT(10 downto 8)="111") then
		regwrimuxx<="00";
		else
		regwrimuxx<="01";
		end if;
		if(X_INPUT(10 downto 8) = "111") then
		pcencode<= '1';
		else
		pcencode<= '0';
		end if;
	elsif(X_INPUT(17 downto 14)="0000") then --The sections which deal with LHI
		registerfen<='1';
		regaddr1mux<= "00";
		regaddr3mux<= "100";
		regdest3mux<= "01";
		progcountmulti<= "101";
		if(X_INPUT(13 downto 11)="111") then
		regwrimuxx<="00";
		else
		regwrimuxx<="01";
		end if;
		if(X_INPUT(13 downto 11) = "111") then
		pcencode<= '1';
		else
		pcencode<= '0';
		end if;
	else
		registerfen<='0';
		regaddr1mux<= "00";
		regaddr3mux<= "100";
		regdest3mux<= "01";
		progcountmulti<= "101";
		regwrimuxx<="00";
		pcencode<= '0';
	end if;

-- Sixth state
elsif(X_INPUT(22 downto 18) = "00110") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "00";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="00";
		memorydestmux<='1';
		encodet1<= '0';
		encodet2<= '1';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "00";
		tem2multi<= "10";
		tem3multi<='0';
		progcountmulti<= "000";
---7th State
elsif(X_INPUT(22 downto 18) = "00111") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "00";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='1';
		encodet1<= '1';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "10";
		tem2multi<= "10";
		tem3multi<='0';
		progcountmulti<= "000";
--Eighth state
elsif(X_INPUT(22 downto 18) = "01000") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="000";
		registerfen<='1';
		if(X_INPUT(13 downto 11)="111") then
		regwrimuxx<="00";
		else
		regwrimuxx<="01";
		end if;
		regaddr1mux<= "00";
		regaddr3mux<= "100";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="00";
		memorydestmux<='1';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '1';
		tem1multi<= "00";
		tem2multi<= "01";
		tem3multi<='0';
		progcountmulti<= "010";
		if(X_INPUT(13 downto 11) = "111") then
		pcencode<= '1';
		else
		pcencode<= '0';
		end if;
--Ninth state
elsif(X_INPUT(22 downto 18)="01001") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		registerfen<='1';
		regwrimuxx<="01";
		regaddr1mux<= "00";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='0';
		memoryaddrmux<="10";
		memorydestmux<='0';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "10";
		tem2multi<= "10";
		tem3multi<='0';
		progcountmulti<= "000";
--Tenth state
elsif(X_INPUT(22 downto 18)="01010") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "00";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='0';
		encodet1<= '0';
		encodet2<= '1';
		encodet3<= '1';
		encodet4<= '1';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "10";
		tem2multi<= "11";
		tem3multi<='0';
		progcountmulti<= "000";
--Eleventh state
elsif(X_INPUT(22 downto 18) = "01011") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="001";
		registerfen<='1';
		if(X_INPUT(25 downto 23)="111") then
		regwrimuxx<="00";
		else
		regwrimuxx<="01";
		end if;
		regaddr1mux<= "00";
		regaddr3mux<= "101";
		regdest3mux<= "10";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='0';
		encodet1<= '1';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		if(X_INPUT(25 downto 23) = "111") then
		pcencode<= '1';
		else
		pcencode<='0';
		end if;
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "11";
		tem3multi<='0';
		progcountmulti<= "100";
----Twelfth state
elsif(X_INPUT(22 downto 18) =  "01100") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "00";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='0';
		encodet1<= '0';
		encodet2<= '1';
		encodet3<= '0';
		encodet4<= '1';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "10";
		tem2multi<= "11";
		tem3multi<='0';
		progcountmulti<= "000";
---State thirteen
elsif(X_INPUT(22 downto 18) = "01101") then
	    tempZencode<='1';
		ao_p<="00";
		alua_mux<="10";
		alub_mux<="100";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "10";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='0';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '1';
		encodet4<= '0';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "10";
		tem2multi<= "11";
		tem3multi<='1';
		progcountmulti<= "000";
---state fourteen
elsif(X_INPUT(22 downto 18)="01110") then
		tempZencode<='1';
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="001";
		registerfen<='1';
		regwrimuxx<="01";
		regaddr1mux<= "00";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='0';
		memoryaddrmux<="01";
		memorydestmux<='1';
		encodet1<= '1';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "11";
		tem3multi<='0';
		progcountmulti<= "000";
---fifteenthstate
elsif(X_INPUT(22 downto 18)="01111") then
		tempZencode<='1';
		ao_p<="01";
		alua_mux<="01";
		alub_mux<="010";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "01";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='0';
		encodet1<= '1';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "00";
		tem2multi<= "11";
		tem3multi<='0';
		progcountmulti<= "000";
----sixteenth state
elsif(X_INPUT(22 downto 18)="10000") then
		tempZencode<='0';
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="101";
		registerfen<='1';
		if(X_INPUT(26) = '0')then
		regwrimuxx<="01";
		pcencode<= '0';
		else
		pcencode<= '1';
		regwrimuxx<="11";
		end if;
		regaddr1mux<= "01";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='0';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "00";
		tem2multi<= "11";
		tem3multi<='0';
		progcountmulti<= "000";
--seventeenth state
elsif(X_INPUT(22 downto 18)="10001") then
	    tempZencode<='1';
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="001";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "01";
		regaddr3mux<= "010";
		regdest3mux<= "00";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='1';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '1';
		encodet4<= '0';
		pcencode<= '0';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "11";
		tem3multi<='1';
		progcountmulti<= "000";
---Eighteenth state
elsif(X_INPUT(22 downto 18)="10010") then
	    tempZencode<='1';
		ao_p<="00";
		alua_mux<="11";
		alub_mux<="011";
		registerfen<='1';
		regwrimuxx<="11";
		regaddr1mux<= "01";
		regaddr3mux<= "100";
		regdest3mux<= "10";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='1';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '1';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "11";
		tem3multi<='1';
		progcountmulti<= "000";
--Ninteenth state
elsif(X_INPUT(22 downto 18)="10011") then
	    tempZencode<='1';
		ao_p<="00";
		alua_mux<="11";
		alub_mux<="011";
		registerfen<='1';
		regwrimuxx<="10";
		regaddr1mux<= "01";
		regaddr3mux<= "100";
		regdest3mux<= "10";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='1';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '1';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "11";
		tem3multi<='1';
		progcountmulti<= "011";

---Twentieth state
elsif(X_INPUT(22 downto 18)="10100") then
	   tempZencode<='1';
		ao_p<="00";
		alua_mux<="01";
		alub_mux<="010";
		registerfen<='0';
		regwrimuxx<="01";
		regaddr1mux<= "01";
		regaddr3mux<= "100";
		regdest3mux<= "10";
		memwrbar<='1';
		memoryaddrmux<="01";
		memorydestmux<='1';
		encodet1<= '0';
		encodet2<= '0';
		encodet3<= '0';
		encodet4<= '0';
		pcencode<= '1';
		instregencode<= '0';
		flagCencode<='0';
		flagZencode<= '0';
		tem1multi<= "01";
		tem2multi<= "11";
		tem3multi<='1';
		progcountmulti<= "010"; 

		
else
	tempZencode<='1';
	ao_p<="00";
	alua_mux<="11";
	alub_mux<="011";
	registerfen<='1';
	regwrimuxx<="10";
	regaddr1mux<= "01";
	regaddr3mux<= "100";
	regdest3mux<= "10";
	memwrbar<='1';
	memoryaddrmux<="01";
	memorydestmux<='1';
	encodet1<= '0';
	encodet2<= '0';
	encodet3<= '0';
	encodet4<= '0';
	pcencode<= '0';
	instregencode<= '0';
	flagCencode<='0';
	flagZencode<= '0';
	tem1multi<= "01";
	tem2multi<= "11";
	tem3multi<='1';
	progcountmulti<= "011";
end if;

end process;

end Behave;