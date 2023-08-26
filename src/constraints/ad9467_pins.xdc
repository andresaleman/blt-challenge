#Reset button on ZCU106
set_property -dict { PACKAGE_PIN G13 IOSTANDARD LVCMOS18 DIRECTION IN} [get_ports { reset }];

#CLK125 on board
set_property -dict { PACKAGE_PIN G9 IOSTANDARD DIFF_SSTL15 DIRECTION IN} [get_ports { clk_125_n }];
set_property -dict { PACKAGE_PIN H9 IOSTANDARD DIFF_SSTL15 DIRECTION IN} [get_ports { clk_125_p }];

#PL UART2 Connections
set_property -dict { PACKAGE_PIN AH17 IOSTANDARD LVCMOS12 DIRECTION IN}  [get_ports { uart_txd }];
set_property -dict { PACKAGE_PIN AL17 IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { uart_rxd }];

#LEDs
set_property -dict { PACKAGE_PIN AL11 IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[0] }];
set_property -dict { PACKAGE_PIN AL13 IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[1] }];
set_property -dict { PACKAGE_PIN AK13 IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[2] }];
set_property -dict { PACKAGE_PIN AE15 IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[3] }];
set_property -dict { PACKAGE_PIN AM8  IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[4] }];
set_property -dict { PACKAGE_PIN AM9  IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[5] }];
set_property -dict { PACKAGE_PIN AM10 IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[6] }];
set_property -dict { PACKAGE_PIN AM11 IOSTANDARD LVCMOS12 DIRECTION OUT} [get_ports { up_status[7] }];

set_property -dict {  PACKAGE_PIN E15 DIFF_TERM TRUE IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_clk_in_p     }];
set_property -dict {  PACKAGE_PIN E14 DIFF_TERM TRUE IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_clk_in_n     }];
set_property -dict {  PACKAGE_PIN E18  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_or_p    }];
set_property -dict {  PACKAGE_PIN E17  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_or_n    }];
set_property -dict {  PACKAGE_PIN F17  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[0] }];
set_property -dict {  PACKAGE_PIN F16  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[0] }];
set_property -dict {  PACKAGE_PIN H18  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[1] }];
set_property -dict {  PACKAGE_PIN H17  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[1] }];
set_property -dict {  PACKAGE_PIN L20  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[2] }];
set_property -dict {  PACKAGE_PIN K20  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[2] }];
set_property -dict {  PACKAGE_PIN K19  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[3] }];
set_property -dict {  PACKAGE_PIN K18  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[3] }];
set_property -dict {  PACKAGE_PIN L17  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[4] }];
set_property -dict {  PACKAGE_PIN L16  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[4] }];
set_property -dict {  PACKAGE_PIN K17  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[5] }];
set_property -dict {  PACKAGE_PIN J17  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[5] }];
set_property -dict {  PACKAGE_PIN H19  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[6] }];
set_property -dict {  PACKAGE_PIN G19  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[6] }];
set_property -dict {  PACKAGE_PIN J16  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_p[7] }];
set_property -dict {  PACKAGE_PIN J15  DIFF_TERM TRUE  IOSTANDARD LVDS DIRECTION IN} [ get_ports { adc_data_in_n[7] }];


set_property -dict { PACKAGE_PIN C9  IOSTANDARD LVCMOS18 DIRECTION OUT  } [ get_ports { ad9517_csn }];
set_property -dict { PACKAGE_PIN C8  IOSTANDARD LVCMOS18 DIRECTION OUT  } [ get_ports { spi_csn    }];
set_property -dict { PACKAGE_PIN E8  IOSTANDARD LVCMOS18 DIRECTION OUT  } [ get_ports { spi_clk    }];
set_property -dict { PACKAGE_PIN F8  IOSTANDARD LVCMOS18 DIRECTION INOUT} [ get_ports { spi_sdio   }];

#Let's assume a 60MHz clock for ADC
create_clock -name adc_clk -period 17.00 [get_ports adc_clk_in_p]
create_clock -name clk_125 -period 8.00 [get_ports clk_125_p]
