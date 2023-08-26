----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2023 05:35:23 PM
-- Design Name: 
-- Module Name: top_block - Behavioral
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

entity top_block is
    Port ( reset : in STD_LOGIC;
           clk_125_n : in STD_LOGIC;
           clk_125_p : in STD_LOGIC;
           uart_txd : in STD_LOGIC;
           uart_rxd : out STD_LOGIC;
           up_status : out STD_LOGIC_VECTOR (7 downto 0);
           adc_clk_in_p : in STD_LOGIC;
           adc_clk_in_n : in STD_LOGIC;
           adc_data_or_p : in STD_LOGIC;
           adc_data_or_n : in STD_LOGIC;
           adc_data_in_p : in STD_LOGIC_VECTOR (7 downto 0);
           adc_data_in_n : in STD_LOGIC_VECTOR (7 downto 0);
           ad9517_csn : out STD_LOGIC;
           spi_csn : out STD_LOGIC;
           spi_clk : out STD_LOGIC;
           spi_sdio : inout STD_LOGIC);
end top_block;

architecture Behavioral of top_block is

begin


end Behavioral;
