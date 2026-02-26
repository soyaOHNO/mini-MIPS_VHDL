set_global_assignment -entity "P_CLK" -library "lib_P_CLK" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "P_CLK" -library "lib_P_CLK" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "P_CLK" -library "lib_P_CLK" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_P_CLK" -name SPD_FILE [file join $::quartus(sip_path) "P_CLK.spd"]

set_global_assignment -library "lib_P_CLK" -name MISC_FILE [file join $::quartus(sip_path) "P_CLK_sim/P_CLK.vho"]
