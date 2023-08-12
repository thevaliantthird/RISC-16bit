library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- The Entity for the datapath which contains whatever is to be transferred Data where it needs to be transferred and what is to be transferred
-- The data being passed depends on whether or not some mux values are set, which is why these are also passed as inputs here
-- Some other values, like what is to go in Temporary registers, flags etc, are what we set using our datapath.
entity datapath is
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
  end entity;



  architecture dp of datapath is
-- Getting the components we needed


-- priority encoders
component priority_encoder is
  port (
      INPUT_PORT : in std_logic_vector (7 downto 0);
      OUTPUT_ADDRESS : out std_logic_vector (2 downto 0);
      portforupdate : out std_logic_vector (7 downto 0)
    );
  end component priority_encoder;
--Register for 3 bit addresses
  component reg_3bit is
    port (
          ENCODER, RST, CLOCK: in std_logic;
          INPUT_PORT: in std_logic_vector(2 downto 0);
          OUTPUT_PORT: out std_logic_vector(2 downto 0));
  end component;
-- Register File
  component RegFile is
    port (
        CLOCK,RST: in std_logic;
        regfaddr1, regfaddr2, regfaddr3 : in std_logic_vector (2 downto 0);
        regfdaddr3 : in std_logic_vector(NUM_BITS - 1 downto 0);
        regfdaddr1, regfdaddr2 : out std_logic_vector(NUM_BITS - 1 downto 0);
        alu2regsev, t22regsev, progcount2regsev : in std_logic_vector (NUM_BITS - 1 downto 0);
        regfwrite: in std_logic;
        regwrimuxx : in std_logic_vector(1 downto 0)
      );
end component;
-- Flip Flop
  component flip_flop is
    port (ENCODER, RST, CLOCK: in std_logic;
          D: in std_logic;
          Q: out std_logic);
  end component;
-- Memory
  component memory is
    port(CLOC: in std_logic;
        memwrbar: in std_logic;
        addr: in std_logic_vector(15 downto 0);
        dinput: in std_logic_vector(15 downto 0);
        doutput: out std_logic_vector(15 downto 0));
  end component;
-- Sign Extension
  component SE6 is
  port (
      INPUT_PORT : in std_logic_vector (5 downto 0);
      OUTPUT_PORT : out std_logic_vector (15 downto 0));
  end component SE6;

  component SE9 is
  port (
      INPUT_PORT : in std_logic_vector (8 downto 0);
      OUTPUT_PORT : out std_logic_vector (15 downto 0));
  end component SE9;
--ALU
    component ALU is
      port(ao_p: in std_logic_vector(2 downto 1);
          alua: in std_logic_vector(15 downto 0);
          alub: in std_logic_vector(15 downto 0);
          aluc: out std_logic;
          aluz: out std_logic;
          aluou: out std_logic_vector(15 downto 0));
    end component;
-- Registers
    component reg is
    Generic (NUM_BITS : INTEGER := 16);
      port (ENCODER, RST, CLOCK: in std_logic;
            INPUT_PORT: in std_logic_vector(NUM_BITS-1 downto 0);
            OUTPUT_PORT: out std_logic_vector(NUM_BITS-1 downto 0)
    		  );
    end component;


    signal t1_INPUT_PORT,t1_OUTPUT_PORT, t2_INPUT_PORT, t2_OUTPUT_PORT, t3_INPUT_PORT, t3_OUTPUT_PORT : std_logic_vector(15 downto 0);
    signal t4_INPUT_PORT, t4_OUTPUT_PORT: std_logic_vector(2 downto 0);
    signal mem_d, ir_OUTPUT_PORT: std_logic_vector(15 downto 0);
    signal pc_in, pc_out: std_logic_vector(15 downto 0);
    signal alua, alub, aluou : std_logic_vector(15 downto 0);
	 signal aluz, aluc: std_logic;
    signal regfaddr1, regfaddr2, regfaddr3 : std_logic_vector(2 downto 0);
    signal regfdaddr1, regfdaddr2, regfdaddr3, r7_OUTPUT_PORT : std_logic_vector(15 downto 0);
	 signal t2_portforupdate : std_logic_vector(15 downto 0):=(others=>'0');
    signal mem_addr, mem_d_in, mem_d_out : std_logic_vector(15 downto 0);
    signal se9ir08_out, se6ir05_out : std_logic_vector (15 downto 0);

    begin
	 temp4op<= t4_OUTPUT_PORT;
	 instructOP <= ir_OUTPUT_PORT;
	 temp2op <= t2_OUTPUT_PORT;
-- Instantiating registers
      T1: reg port map(ENCODER=>encodet1, RST=>RST, CLOCK=>CLOCK, INPUT_PORT=>t1_INPUT_PORT, OUTPUT_PORT=>t1_OUTPUT_PORT);
      temp2: reg port map(ENCODER=>encodet2, RST=>RST, CLOCK=>CLOCK, INPUT_PORT=>t2_INPUT_PORT, OUTPUT_PORT=>t2_OUTPUT_PORT);
      T3: reg port map(ENCODER=>encodet3, RST=>RST, CLOCK=>CLOCK, INPUT_PORT=>t3_INPUT_PORT, OUTPUT_PORT=>t3_OUTPUT_PORT);
      temp4: reg_3bit port map(ENCODER=>encodet4, RST=>RST, CLOCK=>CLOCK, INPUT_PORT=>t4_INPUT_PORT, OUTPUT_PORT=>t4_OUTPUT_PORT);

      instructreg: reg port map(ENCODER=>instregencode, RST=>RST, CLOCK=>CLOCK, INPUT_PORT=>mem_d_out, OUTPUT_PORT=>ir_OUTPUT_PORT);
      PC: reg port map(ENCODER=>pcencode, RST=>RST, CLOCK=>CLOCK, INPUT_PORT=>pc_in, OUTPUT_PORT=>pc_out);

      ALU_datapath: ALU port map(ao_p=>ao_pr, alua=>alua, alub=>alub, aluc=>aluc, aluz=>aluz, aluou=>aluou);
      C_flag: flip_flop port map(ENCODER=>flagCencode, RST=>RST, CLOCK=>CLOCK, D=>aluc, Q=>CARRYFlag);
      Z_OUTPUT_flag: flip_flop port map(ENCODER=>flagZencode, RST=>RST, CLOCK=>CLOCK, D=>aluz, Q=>ZEROFlag);
      temp_Z_OUTPUT: flip_flop port map(ENCODER=>tempZencode, RST=>RST, CLOCK=>CLOCK, D=>aluz, Q=>tempZERO);
      PE: priority_encoder port map(INPUT_PORT=>t2_OUTPUT_PORT(7 downto 0), OUTPUT_ADDRESS=>t4_INPUT_PORT, portforupdate=>t2_portforupdate(7 downto 0));

      RF: RegFile port map(
      CLOCK=>CLOCK,
		RST => RST,
      regfaddr1=>regfaddr1,
      regfaddr2=>ir_OUTPUT_PORT(8 downto 6),
      regfaddr3=>regfaddr3,
      regfdaddr1=>regfdaddr1,
      regfdaddr2=>regfdaddr2,
      regfdaddr3=>regfdaddr3,
      alu2regsev=>aluou,
      t22regsev=>t2_OUTPUT_PORT,
      progcount2regsev=>pc_out,
      regfwrite=>registerfen,
      regwrimuxx=>regwrimuxx
      );

      mem: memory port map (CLOC=>CLOCK, memwrbar=>memwrbar, addr=>mem_addr, dinput=>mem_d_in, doutput=>mem_d_out);

      SE9_ir_0_8 : SE9 port map (INPUT_PORT=> ir_OUTPUT_PORT(8 downto 0), OUTPUT_PORT=>se9ir08_out);
      SE6_ir_0_5 : SE6 port map (INPUT_PORT=>ir_OUTPUT_PORT(5 downto 0) , OUTPUT_PORT=>se6ir05_out);
-- Starting processes
	process(CLOCK,
	ao_pr, alua_mux, alub_mux,
	registerfen,
	regwrimuxx, regaddr1mux, regaddr3mux, regdest3mux,
	memwrbar, memoryaddrmux, memorydestmux,
	encodet1, encodet2, encodet3, encodet4 ,
	pcencode,
	instregencode,
	flagCencode, flagZencode,
	tem1multi, tem2multi, tem3multi,
	progcountmulti,
	tempZencode,
	pc_out, ir_OUTPUT_PORT,
	t1_OUTPUT_PORT, t2_OUTPUT_PORT, t3_OUTPUT_PORT, t4_OUTPUT_PORT,
	se9ir08_out, se6ir05_out,
	mem_d_out, regfdaddr1, regfdaddr2,
	t2_portforupdate, aluou
  )
  begin
      case(alua_mux) is
        when "00"=>
          alua <= pc_out;
        when "01"=>
          alua <= t1_OUTPUT_PORT;
        when "10"=>
          alua <= t2_OUTPUT_PORT;
        when "11"=>
          alua <= se9ir08_out;
			when others =>
				alua <= (others => '0');
      end case;

      case(alub_mux) is
        when "000"=>
          alub(15 downto 0)<=(others=>'0');
        when "001"=>
          alub(15 downto 1) <= (others=>'0');
          alub(0) <= '1';
        when "010"=>
          alub <= t2_OUTPUT_PORT;
        when "011"=>
          alub <= t3_OUTPUT_PORT;
        when "100"=>
          alub <= se6ir05_out;
        when "101"=>
            alub <= se9ir08_out;
        when others =>
          alub(15 downto 0) <= (others=>'0');
      end case;

      case(regaddr1mux) is
        when "00"=>
          regfaddr1 <= ir_OUTPUT_PORT(11 downto 9);
        when "01"=>
          regfaddr1 <= "111";
        when "10"=>
          regfaddr1 <= t4_OUTPUT_PORT;
			when others =>
				regfaddr1 <= (others => '0');
      end case;

      case(regaddr3mux) is
        when "001"=>
          regfaddr3 <= ir_OUTPUT_PORT(5 downto 3);
        when "010"=>
          regfaddr3 <= "111";
        when "011"=>
          regfaddr3 <= ir_OUTPUT_PORT(8 downto 6);
        when "100"=>
          regfaddr3 <= ir_OUTPUT_PORT(11 downto 9);
        when "101"=>
          regfaddr3 <= t4_OUTPUT_PORT;
        when others =>
          regfaddr3 <= "111";
      end case;

      case(regdest3mux) is
        when "00"=>
          regfdaddr3 <= t1_OUTPUT_PORT;
        when "01"=>
          regfdaddr3(15 downto 7) <= ir_OUTPUT_PORT(8 downto 0);
          regfdaddr3(6 downto 0) <= (others=>'0');
        when "10"=>
          regfdaddr3 <= t3_OUTPUT_PORT;
        when others =>
          regfdaddr3 <= (others => '0');
      end case;

      case(memoryaddrmux) is
        when "00"=>
          mem_addr <= pc_out;
        when "01"=>
          mem_addr <= t1_OUTPUT_PORT;
        when "10"=>
          mem_addr <= t2_OUTPUT_PORT;
			when others =>
				mem_addr <= (others => '0');
      end case;

      case(memorydestmux) is
        when '0'=>
          mem_d_in <= t1_OUTPUT_PORT;
        when '1'=>
          mem_d_in <= t3_OUTPUT_PORT;
			when others =>
				mem_d_in <= (others => '0');
      end case;

      case(tem1multi) is
        when "00"=>
          t1_INPUT_PORT <= regfdaddr1;
        when "01"=>
          t1_INPUT_PORT <= aluou;
        when "10"=>
          t1_INPUT_PORT <= mem_d_out;
			when others =>
				t1_INPUT_PORT <= (others => '0');
      end case;

      case(tem2multi) is
        when "00"=>
          t2_INPUT_PORT <= regfdaddr2;
        when "01"=>
          t2_INPUT_PORT <= aluou;
        when "10"=>
          t2_INPUT_PORT <= se9ir08_out;
        when "11"=>
          t2_INPUT_PORT <= t2_portforupdate;
			when others =>
				t2_INPUT_PORT <= (others => '0');
      end case;

      case(tem3multi) is
        when '0'=>
          t3_INPUT_PORT <= mem_d_out;
        when '1'=>
          t3_INPUT_PORT <= regfdaddr1;
			when others =>
				t3_INPUT_PORT <= (others => '0');			 
      end case;

    case(progcountmulti) is
      when "000"=>
        pc_in <= aluou;
      when "001"=>
        pc_in <= regfdaddr1;
      when "010"=>
        pc_in <= t1_OUTPUT_PORT;
      when "011"=>
        pc_in <= t2_OUTPUT_PORT;
      when "100"=>
        pc_in <= t3_OUTPUT_PORT;
      when "101"=>
        pc_in(15 downto 7) <= ir_OUTPUT_PORT(8 downto 0);
        pc_in(6 downto 0) <= (others=>'0');
      when others =>
        pc_in <= (others => '0');
    end case;
  end process;
end architecture;
