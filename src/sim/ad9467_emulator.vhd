----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2023 08:36:37 PM
-- Design Name: 
-- Module Name: ad9467_emulator - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ad9467_emulator is
    Port ( adc_data_p : out STD_LOGIC_VECTOR (7 downto 0);
           adc_clk_p : out STD_LOGIC;
           or_p : out STD_LOGIC;
           adc_data_n : out STD_LOGIC_VECTOR (7 downto 0);
           adc_clk_n : out STD_LOGIC;
           or_n : out STD_LOGIC);
end ad9467_emulator;

architecture Behavioral of ad9467_emulator is

    signal clk : std_logic;

    constant TbPeriod : time := 17 ns; -- let's assume 60MHz Clock
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    
    signal data : std_logic_vector (15 downto 0) := x"0000";
    
    signal adc_data_p_s : std_logic_vector(7 downto 0);

begin

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;
    
    --generate the adc clock out
    adc_clk_p <= clk;
    adc_clk_n <= not clk;
    
    -- now let's handle the data, let's just always send the same data out
    --data <= x"AB12";
    process (clk)
    begin
        if rising_edge(clk) then
            data <= std_logic_vector(unsigned(data)+1);
        end if;
    end process;
    
    process (clk)
    begin
    if(falling_edge(clk)) then -- on simulation, let's revert the edges, since we need data to be ready before the edge, which is achieved by reversing them
    
        for i in 0 to 7 loop
                adc_data_p_s(i) <= data(i*2+1);
        end loop;
    
    elsif(rising_edge(clk)) then
        for i in 0 to 7 loop
                adc_data_p_s(i) <= data(i*2);
        end loop;
    end if;
    end process;
    
    adc_data_p <= adc_data_p_s;
    adc_data_n <= not adc_data_p_s;
    
    or_p <= '0';
    or_n <= '1';
    

end Behavioral;
