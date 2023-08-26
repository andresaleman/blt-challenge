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
library UNISIM;
use UNISIM.VComponents.all;

entity ad9467_interface is
    Port ( reset : in STD_LOGIC;
           adc_clk : in STD_LOGIC;
           adc_data : in STD_LOGIC_VECTOR (7 downto 0);
           out_of_range : in STD_LOGIC;
           adc_data_out : out STD_LOGIC_VECTOR (15 downto 0);
           out_of_range_out : out STD_LOGIC
           );
end ad9467_interface;

architecture Behavioral of ad9467_interface is

begin

--Let's assume no delay needed for input for now, so we will read D(X+1) on rising_edge and D(X) on falling_edge
IDDR_GEN : for i in 0 to 7 generate
IDDR_DATA : IDDR
generic map (
    DDR_CLK_EDGE => "SAME_EDGE_PIPELINED", -- "OPPOSITE_EDGE", "SAME_EDGE"
    -- or "SAME_EDGE_PIPELINED"
    INIT_Q1 => '0', -- Initial value of Q1: '0' or '1'
    INIT_Q2 => '0', -- Initial value of Q2: '0' or '1'
    SRTYPE => "ASYNC") -- Set/Reset type: "SYNC" or "ASYNC" --For ultrascale architecture this needs to be ASYNC
    port map (
    Q1 => adc_data_out((i*2)+1), -- 1-bit output for positive edge of clock
    Q2 => adc_data_out(i*2), -- 1-bit output for negative edge of clock
    C => adc_clk, -- 1-bit clock input
    CE => '1', -- 1-bit clock enable input
    D => adc_data(i), -- 1-bit DDR data input
    R => reset, -- 1-bit reset
    S => '0' -- 1-bit set
);
end generate IDDR_GEN;

-- delay the out_of_range signal by one clock cycle so it's alligned with data
process(adc_clk)
begin
    if(rising_edge(adc_clk)) then
        out_of_range_out <= out_of_range;
    end if;
end process;


end Behavioral;
