# blt-challenge
AD9467 Interface using ZCU106

# Vivado Version
2019.1

# Project build instructions
1. Clone repo: git clone https://github.com/andresaleman/blt-challenge.git
2. From blt-challenge directory run the following command: vivado -source build-project.tcl

# Notes
This project has not been tested in Hardware yet. Some details to test:
1. Make sure ADC data is in sync with clock. If that's not the case, then few options are available:
  - Add a phase shift to the clock using the clock resources (clock wizard)
  - Use IODelay resources to apply some delay to the adc_data_in_p and adc_data_in_n signals

2. Use ILA to make sure data is good
  - ADC Data
  - ADC Out Of Range

3. Use LEDs to debug the design
  - LED0 - Always ON
  - LED1 - Out Of Range Flag
  - LED2 - ADC CLK
  - LED3 - ADC_DATA_TVALID
  - LED7-LED4 - LSBs of ADC Data
