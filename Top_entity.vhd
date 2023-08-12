library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;

entity RISC_IITB is
	port(RST,CLK:in std_logic);
end entity;

architecture Behave of RISC_IITB is

component FSM is
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

end component;

component datapath is
Generic (NUM_BITS : INTEGER := 16);
  port(
  CLOCK,RST: in std_logic;
  ao_pr: in std_logic_vector(1 downto 0);
	alua_mux: in std_logic_vector( 1 downto 0);
	alub_mux: in std_logic_vector( 2 downto 0);
	registerfen: in std_logic;
	regwrimuxx: in std_logic_vector( 1 downto 0);
	regaddr1mux: in std_logic_vector( 1 downto 0);
	regaddr3mux: in std_logic_vector( 2 downto 0);
	regdest3mux: in std_logic_vector( 1 downto 0);
	memwrbar: in std_logic;
	memoryaddrmux: in std_logic_vector( 1 downto 0);
	memorydestmux: in std_logic;
	encodet1, encodet2, encodet3, encodet4 : in std_logic;
	pcencode: in std_logic;
	instregencode: in std_logic;
	flagCencode:in std_logic;
	flagZencode: in std_logic;
	tem1multi: in std_logic_vector(1 downto 0);
	tem2multi: in std_logic_vector(1 downto 0);
	tem3multi: in std_logic;
	progcountmulti: in std_logic_vector(2 downto 0);
  tempZencode: in std_logic;
  CARRYFlag, ZEROFlag: out std_logic;
  temp4op: out std_logic_vector(2 downto 0);
  temp2op: out std_logic_vector(15 downto 0);
  instructOP: out std_logic_vector(15 downto 0);
  tempZERO: out std_logic
  );
  end component;
signal ir_sig: std_logic_vector(15 downto 0);
signal	CARreg_sig,zero_register_sig: std_logic;
signal	temp2_sig: std_logic_vector(15 downto 0);
signal	tempZ_sig: std_logic;
signal	temp4_sig: std_logic_vector(2 downto 0);
signal	ao_p_sig: std_logic_vector(1 downto 0);
signal	alua_mux_sig: std_logic_vector( 1 downto 0);
signal	alub_mux_sig: std_logic_vector( 2 downto 0);
signal	registerfen_sig: std_logic;
signal	regwrimuxx_sig: std_logic_vector( 1 downto 0);
signal	regaddr1mux_sig: std_logic_vector( 1 downto 0);
signal	regaddr3mux_sig: std_logic_vector( 2 downto 0);
signal	regdest3mux_sig: std_logic_vector( 1 downto 0);
signal	memwrbar_sig: std_logic;
signal	memoryaddrmux_sig: std_logic_vector( 1 downto 0);
signal	memorydestmux_sig: std_logic;
signal	encodet1_sig: std_logic;
signal	encodet2_sig: std_logic;
signal	encodet3_sig: std_logic;
signal	encodet4_sig: std_logic;
signal	pcencode_sig: std_logic;
signal	instregencode_sig: std_logic;
signal	tempZencode_sig: std_logic;
signal	flagCencode_sig: std_logic;
signal	flagZencode_sig: std_logic;
signal	tem1multi_sig: std_logic_vector(1 downto 0);
signal	tem2multi_sig: std_logic_vector(1 downto 0);
signal	tem3multi_sig: std_logic;
signal	progcountmulti_sig: std_logic_vector(2 downto 0);

  begin
-- Mapping to start the FSM, this would further make use of the control path as well
  a: FSM port map(CLK=>CLK,RST=>RST,instructreg=>ir_sig,CARreg=>CARreg_sig,zero_register=>zero_register_sig,temp2=>temp2_sig,tempZ=>tempZ_sig,temp4=>temp4_sig, ao_p=>ao_p_sig, alua_mux=>alua_mux_sig, alub_mux=>alub_mux_sig,registerfen=>registerfen_sig,regwrimuxx=>regwrimuxx_sig,regaddr1mux=>regaddr1mux_sig,regaddr3mux=>regaddr3mux_sig,regdest3mux=>regdest3mux_sig,memwrbar=>memwrbar_sig,memoryaddrmux=>memoryaddrmux_sig,memorydestmux=>memorydestmux_sig,encodet1=>encodet1_sig,encodet2=>encodet2_sig,encodet3=>encodet3_sig,encodet4=>encodet4_sig,pcencode=>pcencode_sig,instregencode=>instregencode_sig,tempZencode=>tempZencode_sig,flagCencode=>flagCencode_sig,flagZencode=>flagZencode_sig,tem1multi=>tem1multi_sig,tem2multi=>tem2multi_sig,tem3multi=>tem3multi_sig,progcountmulti=>progcountmulti_sig);
-- Mapping to start the data path and get things going
  b: datapath port map(CLOCK=>CLK,RST=>RST,ao_pr=>ao_p_sig, alua_mux=>alua_mux_sig, alub_mux=>alub_mux_sig,registerfen=>registerfen_sig,regwrimuxx=>regwrimuxx_sig,regaddr1mux=>regaddr1mux_sig,regaddr3mux=>regaddr3mux_sig,regdest3mux=>regdest3mux_sig,memwrbar=>memwrbar_sig,memoryaddrmux=>memoryaddrmux_sig,memorydestmux=>memorydestmux_sig,encodet1=>encodet1_sig,encodet2=>encodet2_sig,encodet3=>encodet3_sig,encodet4=>encodet4_sig,pcencode=>pcencode_sig,instregencode=>instregencode_sig,tempZencode=>tempZencode_sig,flagCencode=>flagCencode_sig,flagZencode=>flagZencode_sig,tem1multi=>tem1multi_sig,tem2multi=>tem2multi_sig,tem3multi=>tem3multi_sig,progcountmulti=>progcountmulti_sig,instructOP=>ir_sig,CARRYFlag=>CARreg_sig,ZEROFlag=>zero_register_sig,temp2op=>temp2_sig,tempZERO=>tempZ_sig,temp4op=>temp4_sig);
  end Behave;

