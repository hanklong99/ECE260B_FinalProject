# Clock tree synthesis 
set_ccopt_property -update_io_latency false
set ccopdir "/home/linux/ieng6/ee260bwi23/helong/w4/q1/run0"
create_ccopt_clock_tree_spec -file $ccopdir/constraints/$design.ccopt
ccopt_design

# Use actual clock network
set_propagated_clock [all_clocks]

# Post-CTS timing optimization
optDesign -postCTS -hold
saveDesign cts.enc
