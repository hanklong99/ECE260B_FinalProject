// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk0, clk1, mem_in, mem_in1, inst, inst1, reset, reset1, out, sum_out_2core,);

parameter col = 8;
parameter bw = 4;
parameter bw_psum = 2*bw+4;
parameter pr = 8;

input  clk0, clk1; 
input  [pr*bw*2-1:0] mem_in, mem_in1; 
input  [26:0] inst, inst1; 
input  reset, reset1;
output [(bw_psum+4)*col*2-1:0] out;
//output [bw_psum+3:0] sum_out_2core;
output [bw_psum+7:0] sum_out_2core;
wire  [bw_psum+7:0] sum_out0;
wire  [bw_psum+7:0] sum_out1;
wire  [bw_psum+7:0] sum_out0_to1;
wire  [bw_psum+7:0] sum_out1_to0;
wire  [(bw_psum+4)*col-1:0] out0;
wire  [(bw_psum+4)*col-1:0] out1;

assign div = inst[19];
assign div1 = inst1[19];


assign sum_out_2core = sum_out0 + sum_out1;
assign out = {out1, out0};

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance0 (
      .reset(reset), 
      .clk(clk0), 
      .mem_in(mem_in), 
      .inst(inst),
      .out(out0),
      .sum_out(sum_out0),
      .sum_in(sum_out1_to0)
);
wire wr_en0;
assign wr_en0 = sum_out0 ? 1:0;
asyn_fifo #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) afifo_instance0(
	.wr_clk(clk0),   //clock of core0
	.rd_clk(clk1),      //clock of core1
	.reset(reset),
	.wr_en(wr_en0),
	.wr_data(sum_out0),
	.rd_en(div),
	.rd_data(sum_out0_to1),
	.full(),
	.empty()
);
core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance1 (
      .reset(reset1), 
      .clk(clk1), 
      .mem_in(mem_in1), 
      .inst(inst1),
      .out(out1),
      .sum_out(sum_out1),
      .sum_in(sum_out0_to1)

);
wire wr_en1;
assign wr_en1 = sum_out1 ? 1:0;
asyn_fifo #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) afifo_instance1(
	.wr_clk(clk1),   //clock of core0
	.rd_clk(clk0),      //clock of core1
	.reset(reset1),
	.wr_en(wr_en1),
	.wr_data(sum_out1),
	.rd_en(div1),
	.rd_data(sum_out1_to0),
	.full(),
	.empty()
);


endmodule
