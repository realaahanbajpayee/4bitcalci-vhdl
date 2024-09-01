----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.04.2024 21:27:40
-- Design Name: 
-- Module Name: calci - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calci is
    Port (input1: in std_logic_vector(3 downto 0);
          input2: in std_logic_vector(3 downto 0);
          choicevec: in std_logic_vector(1 downto 0);
          output1: out std_logic_vector(3 downto 0);
          output2: out std_logic_vector(3 downto 0));
end calci;

architecture Behavioral of calci is
    component addsub is
    Port(A1,A2: in std_logic_vector(3 downto 0);
         K: in std_logic;
         S,C: out std_logic_vector(3 downto 0));
    end component;
    component Multiplier_VHDL is
    Port(Nibble1, Nibble2: in std_logic_vector(3 downto 0);
        Result1,Result2: out std_logic_vector(3 downto 0));
    end component;
    component divider is
      port ( 
        A: in std_logic_vector(3 downto 0);
        B: in std_logic_vector(3 downto 0);
        Q: out std_logic_vector(3 downto 0);
        R: out std_logic_vector(3 downto 0));
    end component;
    component mux_shift_vector is
        Port ( input0 : in STD_LOGIC_VECTOR(3 downto 0);
           input1 : in STD_LOGIC_VECTOR(3 downto 0);
           input2 : in STD_LOGIC_VECTOR(3 downto 0);
           input3 : in STD_LOGIC_VECTOR(3 downto 0);
           sel : in STD_LOGIC_VECTOR(1 downto 0);
           output : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    component demux_shift_vector is
    Port ( input : in STD_LOGIC_VECTOR(3 downto 0);
           sel : in STD_LOGIC_VECTOR(1 downto 0);
           output0 : out STD_LOGIC_VECTOR(3 downto 0);
           output1 : out STD_LOGIC_VECTOR(3 downto 0);
           output2 : out STD_LOGIC_VECTOR(3 downto 0);
           output3 : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    signal T0,T1,T2,T3,T4,T5,T6,T7,Q0,Q1,Q2,Q3,Q4,Q5,Q6,Q7: std_logic_vector(3 downto 0):= (others => '0');
begin
    DM1: demux_shift_vector port map(input=>input1, sel=>choicevec, output0=>T0, output1=>T1, output2=>T2, output3=>T3);
    DM2: demux_shift_vector port map(input=>input2, sel=>choicevec, output0=>T4, output1=>T5, output2=>T6, output3=>T7);
    A1: addsub port map(A1=>T0,A2=>T4,K=>'0',S=>Q0,C=>Q4);
    A2: addsub port map(A1=>T1,A2=>T5,K=>'1',S=>Q1,C=>Q5);
    M1: Multiplier_VHDL port map(Nibble1=>T2,Nibble2=>T6,Result1=>Q2,Result2=>Q6);
    D1: divider port map(A=>T3,B=>T7,Q=>Q3,R=>Q7);
    MX1: mux_shift_vector port map(input0=>Q0,input1=>Q1,input2=>Q2,input3=>Q3,sel=>choicevec,output=>output1);
    MX2: mux_shift_vector port map(input0=>Q4,input1=>Q5,input2=>Q6,input3=>Q7,sel=>choicevec,output=>output2);
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addsub is
    Port(A1,A2: in std_logic_vector(3 downto 0);
         K: in std_logic;
         S,C: out std_logic_vector(3 downto 0));
end addsub;

architecture archaddsub of addsub is
    component full_adder is
        Port ( A, B, Cin: in  std_logic;
               Sum, Cout: out  std_logic);
    end component;
    signal X,Y: std_logic_vector(3 downto 0);
begin
    X(0) <= K xor A2(0);
    X(1) <= K xor A2(1);
    X(2) <= K xor A2(2);
    X(3) <= K xor A2(3);
    C <= "0000";
    F0: full_adder port map (A=>A1(0),B=>X(0),Cin=>K,Sum=>S(0),Cout=>Y(0));
    F1: full_adder port map (A=>A1(1),B=>X(1),Cin=>Y(0),Sum=>S(1),Cout=>Y(1));
    F2: full_adder port map (A=>A1(2),B=>X(2),Cin=>Y(1),Sum=>S(2),Cout=>Y(2));
    F3: full_adder port map (A=>A1(3),B=>X(3),Cin=>Y(2),Sum=>S(3),Cout=>C(0));
end archaddsub;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( A, B, Cin: in  std_logic;
           Sum, Cout: out  std_logic );
end full_adder;

architecture Behavadd of full_adder is
begin
    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (Cin and (A xor B));
end Behavadd;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplier_VHDL is
   port(Nibble1, Nibble2: in std_logic_vector(3 downto 0);
        Result1, Result2: out std_logic_vector(3 downto 0)
   );
end Multiplier_VHDL;

architecture Behavmul of Multiplier_VHDL is
	signal Result : std_logic_vector(7 downto 0);
begin
   Result <= std_logic_vector(unsigned(Nibble1) * unsigned(Nibble2));
   Result2 <= Result(7 downto 4);  -- Upper 4 bits
   Result1 <= Result(3 downto 0);   -- Lower 4 bits
end Behavmul;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider is
  port ( 
    A: in std_logic_vector(3 downto 0);
    B: in std_logic_vector(3 downto 0);
    Q: out std_logic_vector(3 downto 0);
    R: out std_logic_vector(3 downto 0));
end entity;

architecture direct of divider is 
  signal Auns, Buns, Quns, Runs: unsigned(3 downto 0);
begin 
    Auns <= unsigned(A);
    Buns <= unsigned(B);
    process(Auns, Buns)
    begin
        if Buns = 0 then
            Quns <= (others => 'X'); 
            Runs <= (others => 'X'); 
        else
            Quns <= Auns/Buns;
            Runs <= Auns rem Buns;
        end if;
    end process;
    Q <= std_logic_vector(Quns);
    R <= std_logic_vector(Runs);  
end direct;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux_shift_vector is
    Port ( input : in STD_LOGIC_VECTOR(3 downto 0);
           sel : in STD_LOGIC_VECTOR(1 downto 0);
           output0 : out STD_LOGIC_VECTOR(3 downto 0);
           output1 : out STD_LOGIC_VECTOR(3 downto 0);
           output2 : out STD_LOGIC_VECTOR(3 downto 0);
           output3 : out STD_LOGIC_VECTOR(3 downto 0));
end demux_shift_vector;

architecture Behavioral of demux_shift_vector is
begin
    process (input, sel)
    begin
        case sel is
            when "00" =>
                output0 <= input;
                output1 <= (others => '0');
                output2 <= (others => '0');
                output3 <= (others => '0');
            when "01" =>
                output0 <= (others => '0');
                output1 <= input;
                output2 <= (others => '0');
                output3 <= (others => '0');
            when "10" =>
                output0 <= (others => '0');
                output1 <= (others => '0');
                output2 <= input;
                output3 <= (others => '0');
            when "11" =>
                output0 <= (others => '0');
                output1 <= (others => '0');
                output2 <= (others => '0');
                output3 <= input;
            when others =>
                output0 <= (others => '0');
                output1 <= (others => '0');
                output2 <= (others => '0');
                output3 <= (others => '0');
        end case;
    end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_shift_vector is
    Port ( input0 : in STD_LOGIC_VECTOR(3 downto 0);
           input1 : in STD_LOGIC_VECTOR(3 downto 0);
           input2 : in STD_LOGIC_VECTOR(3 downto 0);
           input3 : in STD_LOGIC_VECTOR(3 downto 0);
           sel : in STD_LOGIC_VECTOR(1 downto 0);
           output : out STD_LOGIC_VECTOR(3 downto 0));
end mux_shift_vector;

architecture Behavioral of mux_shift_vector is
begin
    process (input0, input1, input2, input3, sel)
    begin
        case sel is
            when "00" =>
                output <= input0;
            when "01" =>
                output <= input1;
            when "10" =>
                output <= input2;
            when "11" =>
                output <= input3;
            when others =>
                output <= (others => '0'); -- Default output if select is invalid
        end case;
    end process;
end Behavioral;


