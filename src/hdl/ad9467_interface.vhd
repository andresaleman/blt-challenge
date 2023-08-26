----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2023 06:31:40 PM
-- Design Name: 
-- Module Name: ad9467_interface - Behavioral
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

entity ad9467_interface is
    Port ( adc_clk : in STD_LOGIC;
           adc_data : in STD_LOGIC_VECTOR (7 downto 0);
           out_of_range : in STD_LOGIC;
           adc_data_out : out STD_LOGIC_VECTOR (15 downto 0);
           out_of_range_out : out STD_LOGIC
           );
end ad9467_interface;

architecture Behavioral of ad9467_interface is

begin

end Behavioral;
