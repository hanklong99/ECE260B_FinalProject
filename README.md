# ECE260B_FinalProject

1. Connect asyn fifo0's empty to the fifo for sum in sfp of core1, to generate a rd_en == !afifo_empty && !empty;.
2. This rd_en is for the 2 fifo mentioned above, to make the output of this 2 fifo together, to wait for the late sum in the sfp for dividing.
3. Correct the tb for the norm result mem.
4. Make two fifo in the fullchip for final out0 and final out1 to wait for the later out. Use clk0 as final output clk, so async fifo for out1 from clk1.

