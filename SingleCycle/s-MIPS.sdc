create_clock -name CLOCK_50 -period 20.000 [get_ports {CLK}]
derive_pll_clocks
derive_clock_uncertainty