# ECE260B_FinalProject
Correct the out0 and out1 to be the normalizaiton result, previously they were assigned as the result before normalization.
Check core.v row 65.
It was     assign out = col_c ? pmem_combined_reg : pmem_out_16bit;
Now it becames     assign out = pmem_norm_out;
