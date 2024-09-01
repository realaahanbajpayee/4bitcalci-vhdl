library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calci_tb is
end calci_tb;

architecture Behavioral of calci_tb is
    component calci is
        Port (input1: in std_logic_vector(3 downto 0);
              input2: in std_logic_vector(3 downto 0);
              choicevec: in std_logic_vector(1 downto 0);
              output1: out std_logic_vector(3 downto 0);
              output2: out std_logic_vector(3 downto 0));
    end component;
    
    signal input1_sig, input2_sig: std_logic_vector(3 downto 0) := (others=>'0');
    signal choicevec_sig: std_logic_vector(1 downto 0) := (others => '0');
    signal output1_sig, output2_sig: std_logic_vector(3 downto 0);
    
begin
    dut: calci port map (input1 => input1_sig,
                          input2 => input2_sig,
                          choicevec => choicevec_sig,
                          output1 => output1_sig,
                          output2 => output2_sig);
    
    stimulus: process
    begin
        input1_sig <= "0000"; -- Set input 1
        input2_sig <= "0000"; -- Set input 2
        choicevec_sig <= "00"; -- Set choice vector
        
        -- Add delay to simulate clock cycles
        wait for 10 ns;
        
        input1_sig <= "0100"; -- Set new input 1
        input2_sig <= "0001"; -- Set new input 2
        choicevec_sig <= "01"; -- Set new choice vector
        
        wait for 10 ns;

	input1_sig <= "0100"; -- Set new input 1
        input2_sig <= "0010"; -- Set new input 2
        choicevec_sig <= "10"; -- Set new choice vector
        
        wait for 10 ns;
	input1_sig <= "0100"; -- Set new input 1
        input2_sig <= "0010"; -- Set new input 2
        choicevec_sig <= "11"; -- Set new choice vector
        
        wait for 10 ns;
        input1_sig <= "0001"; -- Set input 1
        input2_sig <= "0100"; -- Set input 2
        choicevec_sig <= "00"; -- Set choice vector
        
        -- Add delay to simulate clock cycles
        wait for 10 ns;
        
        input1_sig <= "1100"; -- Set new input 1
        input2_sig <= "0011"; -- Set new input 2
        choicevec_sig <= "01"; -- Set new choice vector
        
        wait for 10 ns;

	input1_sig <= "0101"; -- Set new input 1
        input2_sig <= "0010"; -- Set new input 2
        choicevec_sig <= "10"; -- Set new choice vector
        
        wait for 10 ns;
	input1_sig <= "1000"; -- Set new input 1
        input2_sig <= "0010"; -- Set new input 2
        choicevec_sig <= "11"; -- Set new choice vector
        
        -- Add more test cases as needed
        
        wait;
    end process;
    
    -- Add assertion statements to check the output values if needed
    
end Behavioral;