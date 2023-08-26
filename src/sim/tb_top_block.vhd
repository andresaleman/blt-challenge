----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/26/2023 09:18:53 PM
-- Design Name: 
-- Module Name: tb_top_block - Behavioral
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

entity tb_top_block is
--  Port ( );
end tb_top_block;

architecture tb of tb_top_block is

    component top_block
        port (reset         : in std_logic;
              clk_125_n     : in std_logic;
              clk_125_p     : in std_logic;
              uart_txd      : in std_logic;
              uart_rxd      : out std_logic;
              up_status     : out std_logic_vector (7 downto 0);
              adc_clk_in_p  : in std_logic;
              adc_clk_in_n  : in std_logic;
              adc_data_or_p : in std_logic;
              adc_data_or_n : in std_logic;
              adc_data_in_p : in std_logic_vector (7 downto 0);
              adc_data_in_n : in std_logic_vector (7 downto 0);
              ad9517_csn    : out std_logic;
              spi_csn       : out std_logic;
              spi_clk       : out std_logic;
              spi_sdio      : inout std_logic);
    end component;
    
    component ad9467_emulator
    Port ( adc_data_p : out STD_LOGIC_VECTOR (7 downto 0);
           adc_clk_p : out STD_LOGIC;
           or_p : out STD_LOGIC;
           adc_data_n : out STD_LOGIC_VECTOR (7 downto 0);
           adc_clk_n : out STD_LOGIC;
           or_n : out STD_LOGIC);
    end component;

    signal reset         : std_logic;
    signal clk_125_n     : std_logic;
    signal clk_125_p     : std_logic;
    signal uart_txd      : std_logic;
    signal uart_rxd      : std_logic;
    signal up_status     : std_logic_vector (7 downto 0);
    signal adc_clk_in_p  : std_logic;
    signal adc_clk_in_n  : std_logic;
    signal adc_data_or_p : std_logic;
    signal adc_data_or_n : std_logic;
    signal adc_data_in_p : std_logic_vector (7 downto 0);
    signal adc_data_in_n : std_logic_vector (7 downto 0);
    signal ad9517_csn    : std_logic;
    signal spi_csn       : std_logic;
    signal spi_clk       : std_logic;
    signal spi_sdio      : std_logic;

    constant TbPeriod : time := 8 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : top_block
    port map (reset         => reset,
              clk_125_n     => clk_125_n,
              clk_125_p     => clk_125_p,
              uart_txd      => uart_txd,
              uart_rxd      => uart_rxd,
              up_status     => up_status,
              adc_clk_in_p  => adc_clk_in_p,
              adc_clk_in_n  => adc_clk_in_n,
              adc_data_or_p => adc_data_or_p,
              adc_data_or_n => adc_data_or_n,
              adc_data_in_p => adc_data_in_p,
              adc_data_in_n => adc_data_in_n,
              ad9517_csn    => ad9517_csn,
              spi_csn       => spi_csn,
              spi_clk       => spi_clk,
              spi_sdio      => spi_sdio);
              
    emulator: ad9467_emulator
    port map ( adc_data_p => adc_data_in_p,
           adc_clk_p => adc_clk_in_p,
           or_p => adc_data_or_p,
           adc_data_n => adc_data_in_n,
           adc_clk_n => adc_clk_in_n,
           or_n => adc_data_or_n);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk_125_p <= TbClock;
    clk_125_n <= not TbClock;

    stimuli : process
    begin
        uart_txd <= '0';

        -- Reset generation
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait for 100 ns;

        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_top_block of tb_top_block is
    for tb
    end for;
end cfg_tb_top_block;
