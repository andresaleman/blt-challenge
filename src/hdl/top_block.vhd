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
library UNISIM;
use UNISIM.VComponents.all;

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

-- components 
component ad9467_interface is
    Port ( reset : in STD_LOGIC;
           adc_clk : in STD_LOGIC;
           adc_data : in STD_LOGIC_VECTOR (7 downto 0);
           out_of_range : in STD_LOGIC;
           adc_data_out : out STD_LOGIC_VECTOR (15 downto 0);
           out_of_range_out : out STD_LOGIC);
end component;

component axis_data_fifo_0 is
Port (
  s_axis_aresetn : in STD_LOGIC;
  s_axis_aclk : in STD_LOGIC;
  s_axis_tvalid : in STD_LOGIC;
  s_axis_tready : out STD_LOGIC;
  s_axis_tdata : in STD_LOGIC_VECTOR(15 downto 0);
  m_axis_aclk : in STD_LOGIC;
  m_axis_tvalid : out STD_LOGIC;
  m_axis_tready : in STD_LOGIC;
  m_axis_tdata : out STD_LOGIC_VECTOR(15 downto 0));
end component;

-- signals
signal resetn : std_logic;

-- single-ended inputs
signal clk_125 : std_logic;
signal adc_clk_in : std_logic;
signal out_of_range : std_logic;
signal adc_data_in : std_logic_vector (7 downto 0);

-- ad9467 data and out_of_range delayed
signal adc_data : std_logic_vector (15 downto 0);
signal out_of_range_delayed : std_logic;

-- adc data at 125MHz
signal adc_data_125_tdata : std_logic_vector(15 downto 0);
signal adc_data_125_tvalid : std_logic;

--

begin

-- let's have a resetn signal available
resetn <= not reset;

-- First, let's convert all the differential pairs to single-ended

-- Out of Range signal
IBUFDS_DATA_OUT_OF_RANGE : IBUFDS 
generic map(
    DIFF_TERM => FALSE, -- Differential Termination, board is already using this according to constraint
    IBUF_LOW_PWR => TRUE, -- Low power="TRUE", Highest perforrmance="FALSE"
    IOSTANDARD => "DEFAULT" -- Specify the input I/O standard
)
port map (
    O => out_of_range, -- Buffer output
    I => adc_data_or_p, -- Diff_p buffer input (connect directly to top-level port)
    IB => adc_data_or_n -- Diff_n buffer input (connect directly to top-level port)
);

-- ADC Data
IBUFDS_DATA_GEN : for i in 0 to 7 generate
IBUFDS_DATA : IBUFDS
generic map(
    DIFF_TERM => FALSE, -- Differential Termination
    IBUF_LOW_PWR => TRUE, -- Low power="TRUE", Highest perforrmance="FALSE"
    IOSTANDARD => "DEFAULT" -- Specify the input I/O standard
)
port map (
    O => adc_data_in(i), -- Buffer output
    I => adc_data_in_p(i), -- Diff_p buffer input (connect directly to top-level port)
    IB => adc_data_in_n(i) -- Diff_n buffer input (connect directly to top-level port)
);
end generate IBUFDS_DATA_GEN;

-- ADC Clock
IBUFDS_DATA_CLOCK : IBUFGDS 
generic map(
    DIFF_TERM => FALSE, -- Differential Termination, board is already using this according to constraint
    IBUF_LOW_PWR => TRUE, -- Low power="TRUE", Highest perforrmance="FALSE"
    IOSTANDARD => "DEFAULT" -- Specify the input I/O standard
)
port map (
    O => adc_clk_in, -- Buffer output
    I => adc_clk_in_p, -- Diff_p buffer input (connect directly to top-level port)
    IB => adc_clk_in_n -- Diff_n buffer input (connect directly to top-level port)
);

-- processing clk
IBUFDS_CLOCK : IBUFGDS 
generic map(
    DIFF_TERM => FALSE, -- Differential Termination, board is already using this according to constraint
    IBUF_LOW_PWR => TRUE, -- Low power="TRUE", Highest perforrmance="FALSE"
    IOSTANDARD => "DEFAULT" -- Specify the input I/O standard
)
port map (
    O => clk_125, -- Buffer output
    I => clk_125_p, -- Diff_p buffer input (connect directly to top-level port)
    IB => clk_125_n -- Diff_n buffer input (connect directly to top-level port)
);

-- use ad9467 interface here: basically we have a data clock (clk_125 and 8 data lanes with bits on rising_edge and falling edges)
-- the output of this block is the 16 bits of the adc each clock cycle.
ad9467 : ad9467_interface
    port map ( reset => reset,
           adc_clk => adc_clk_in,
           adc_data => adc_data_in,
           out_of_range => out_of_range,
           adc_data_out => adc_data,
           out_of_range_out => out_of_range_delayed);

-- Now we need to get the data of the ADC, which is being clocked by ad_clk_in and send it to a memory using the processing clk (clk_125)
-- Let's use a FIFO to go from adc_clk_in to clk_125
adc_clk_to_125 : axis_data_fifo_0
port map (
  s_axis_aresetn => (resetn),
  s_axis_aclk => adc_clk_in,
  s_axis_tvalid => '1', --let's assume data from adc is always there when there's a rising edge
  s_axis_tready => open, --let's always write, it's fine to start writing for some time if this fifo take some cycles to be ready
  s_axis_tdata => adc_data,
  m_axis_aclk => clk_125,
  m_axis_tvalid => adc_data_125_tvalid,
  m_axis_tready => '1', -- the memory is always ready to receive the samples since it will share the 125MHz clock
  m_axis_tdata => adc_data_125_tdata);
  
-- Now adc_data_125_tdata has the data in the 125MHz processing clk whenever adc_data_125_tvalid is set to 1


end Behavioral;
