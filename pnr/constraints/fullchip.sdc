set clock_cycle 1.2 
set io_delay 0.2 

set clock_port clk

create_clock -name clk -period $clock_cycle [get_ports $clock_port]

# set_multicycle_path -setup 2 -from core_instance1/inst_reg[*] -to core_instance1/sfp_instance/sum_q_reg[*]
# set_multicycle_path -hold 1 -from core_instance1/inst_reg[*] -to core_instance1/sfp_instance/sum_q_reg[*]
# set_multicycle_path -setup 2 -from core_instance0/inst_reg[*] -to core_instance0/sfp_instance/sum_q_reg[*]
# set_multicycle_path -hold 1 -from core_instance0/inst_reg[*] -to core_instance0/sfp_instance/sum_q_reg[*]

set_input_delay  $io_delay -clock $clock_port [all_inputs] 
set_output_delay $io_delay -clock $clock_port [all_outputs]