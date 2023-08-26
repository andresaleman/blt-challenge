----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2023 08:54:57 PM
-- Design Name: 
-- Module Name: tb_ad9467_interface - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_ad9467_interface is
end tb_ad9467_interface;

architecture tb of tb_ad9467_interface is

    component ad9467_interface
        port (reset            : in std_logic;
              adc_clk          : in std_logic;
              adc_data         : in std_logic_vector (7 downto 0);
              out_of_range     : in std_logic;
              adc_data_out     : out std_logic_vector (15 downto 0);
              out_of_range_out : out std_logic);
    end component;
    
    component ad9467_emulator
    Port ( adc_data_p : out STD_LOGIC_VECTOR (7 downto 0);
           adc_clk_p : out STD_LOGIC;
           or_p : out STD_LOGIC;
           adc_data_n : out STD_LOGIC_VECTOR (7 downto 0);
           adc_clk_n : out STD_LOGIC;
           or_n : out STD_LOGIC);
    end component;

    signal reset            : std_logic;
    signal adc_clk          : std_logic;
    signal adc_data         : std_logic_vector (7 downto 0);
    signal out_of_range     : std_logic;
    signal adc_data_out     : std_logic_vector (15 downto 0);
    signal out_of_range_out : std_logic;
    
    constant TbPeriod : time := 17 ns; -- let's assume 60MHz Clock


begin

    dut : ad9467_interface
    port map (reset            => reset,
              adc_clk          => adc_clk,
              adc_data         => adc_data,
              out_of_range     => out_of_range,
              adc_data_out     => adc_data_out,
              out_of_range_out => out_of_range_out);
              
    emulator: ad9467_emulator
    port map ( adc_data_p => adc_data,
           adc_clk_p => adc_clk,
           or_p => out_of_range,
           adc_data_n => open,
           adc_clk_n => open,
           or_n => open);

    stimuli : process
    begin

        -- Reset generation
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        wait for 100 * TbPeriod;
        
        -- End simulation
        wait;
    end process;

end tb;

configuration cfg_tb_ad9467_interface of tb_ad9467_interface is
    for tb
    end for;
end cfg_tb_ad9467_interface;
