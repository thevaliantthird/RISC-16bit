library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity FSM is
	port(RST,CLK: in std_logic;
	instructreg: in std_logic_vector(15 downto 0);
	CARreg,zero_register: in std_logic;
	temp2: in std_logic_vector(15 downto 0);
	tempZ: in std_logic;
	temp4: in std_logic_vector(2 downto 0);
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

architecture Behave of FSM is

component control_signal is
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
end component;

component Next_state is 
	port( x : in std_logic_vector(39 downto 0); zz : out std_logic_vector(4 downto 0));
end component;

signal State: std_logic_vector(4 downto 0);
signal nState: std_logic_vector( 4 downto 0);

begin

-- Calls next state and Control signal to operate the overall machinery!
a: Next_state port map(x(39 downto 24)=>instructreg,x(23)=>CARreg,x(22)=>zero_register,x(21 downto 6)=>temp2,x(5)=>tempZ, x(4 downto 0)=>State, zz=>nState);
b: control_signal port map(X_INPUT(26)=>tempZ,X_INPUT(25 downto 23)=>temp4,X_INPUT(22 downto 18)=>State,X_INPUT(17 downto 2)=>instructreg, X_INPUT(1)=>CARreg,X_INPUT(0)=>zero_register,ao_p=>ao_p, alua_mux=>alua_mux, alub_mux=>alub_mux,registerfen=>registerfen,regwrimuxx=>regwrimuxx,regaddr1mux=>regaddr1mux,regaddr3mux=>regaddr3mux,regdest3mux=>regdest3mux,memwrbar=>memwrbar,memoryaddrmux=>memoryaddrmux,memorydestmux=>memorydestmux,encodet1=>encodet1,encodet2=>encodet2,encodet3=>encodet3,encodet4=>encodet4,pcencode=>pcencode,instregencode=>instregencode,tempZencode=>tempZencode,flagCencode=>flagCencode,flagZencode=>flagZencode,tem1multi=>tem1multi,tem2multi=>tem2multi,tem3multi=>tem3multi,progcountmulti=>progcountmulti);

-- State Transition function
process(nState,CLK,RST,State)
begin
if(CLK'event and CLK='1') then
	if(RST='1') then
		State<="00001";
	else
	 	State<=nState;
	end if;
end if;
end process;
end Behave;
