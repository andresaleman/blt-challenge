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
use IEEE.NUMERIC_STD.ALL;

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

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END component;

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

-- memory
signal mem_adc_data_output : std_logic_vector(15 downto 0);
signal mem_addr : std_logic_vector(9 downto 0);

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
adc_mem : blk_mem_gen_0
port map (
    clka => clk_125,
    ena => '1', -- let's keep the enable high always, wea will be in charge of controlling when to write but we always want to see what's in the memory
    wea(0) => adc_data_125_tvalid, -- everytime there's data that we want to write tvalid will be set to '1'
    addra => mem_addr,
    dina => adc_data_125_tdata,
    douta => mem_adc_data_output
  );

-- Now we need a process to handle mem_addr, basically a counter to know where in memory we are going to write
process (clk_125)
begin
    if(rising_edge(clk_125)) then
        if(reset = '1') then
            mem_addr <= (others=>'0');
        elsif(adc_data_125_tvalid = '1') then
            mem_addr <= std_logic_vector(unsigned(mem_addr) + 1); -- this memory is exactly 2^10=1024 in size, so this number will just wrap automatically
        end if;
    end if;
end process;


-- LEDs
process (clk_125)
begin
    if(rising_edge(clk_125)) then
        -- just make sure we are running the FPGA image, so always ON
        up_status(0) <= '1';
        -- allow to visualize out of range with LED
        up_status(1) <= out_of_range_delayed;
        -- make sure adc_clk is running 
        up_status(2) <= adc_clk_in;
        -- make sure we are writing to memory or at least wre is being toggled
        up_status(3) <= adc_data_125_tvalid;
        
        -- show the 4 LSBs of the ADC data in the LEDs to make sure data is flowing
        up_status(4) <= adc_data_125_tdata(0);
        up_status(5) <= adc_data_125_tdata(1);
        up_status(6) <= adc_data_125_tdata(2);
        up_status(7) <= adc_data_125_tdata(3);
        
        
    end if;
end process;

end Behavioral;
