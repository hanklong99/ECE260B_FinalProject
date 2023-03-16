// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk0, clk1, mem_in, mem_in1, inst, inst1, reset, reset1, out);

parameter col = 8;
parameter bw = 4;
parameter bw_psum = 2*bw+4;
parameter pr = 8;

input  clk0, clk1; 
input  [pr*bw*2-1:0] mem_in, mem_in1; 
input  [27:0] inst, inst1; 
input  reset, reset1;

output [(bw_psum+4)*col-1:0] out;

wire  [bw_psum+7:0] sum_out0;
wire  [bw_psum+7:0] sum_out1;
wire  [bw_psum+7:0] sum_out0_to1;
wire  [bw_psum+7:0] sum_out1_to0;
wire  [(bw_psum+4)*col-1:0] out0;
wire  [(bw_psum+4)*col-1:0] out1;
wire  [(bw_psum+4)*col-1:0] out0_final;
wire  [(bw_psum+4)*col-1:0] out1_final;

assign out = out1_final + out0_final;

wire wr_en_final0, wr_en_final1;
wire rd_en_final;
wire empty0_final, empty1_final;
wire full_final, o_full_final;
assign wr_en_final0 = (|out0 && !o_full_final) ? 1:0;
assign wr_en_final1 = (|out1 && !full_final) ? 1:0;
assign rd_en_final = !empty0_final && !empty1_final;

fifo_nodirectout #(.bw(col*(bw_psum+4))) fifo_inst_final (
     .rd_clk(clk0), 
     .wr_clk(clk0), 
     .in(out0),
     .out(out0_final), 
     .rd(rd_en_final), 
     .wr(wr_en_final0),
     .o_full(o_full_final),
     .o_empty(empty0_final),
     .reset(reset)
);

asyn_fifo_128bit #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) afifo_final(
	.wr_clk(clk1),  
	.rd_clk(clk0),      
	.reset(reset1),
	.wr_en(wr_en_final1),
	.wr_data(out1),
	.rd_en(rd_en_final),
	.rd_data(out1_final),
	.full(full_final),
	.empty(empty1_final)
);

wire afifo_empty0;
wire afifo_empty1;
wire rd_en0;
wire rd_en1;

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance0 (
      .reset(reset), 
      .clk(clk0), 
      .mem_in(mem_in), 
      .inst(inst),
      .out(out0),
      .sum_out(sum_out0),
      .sum_in(sum_out1_to0),
      .afifo_empty(afifo_empty1),
      .rd_en(rd_en1)
);
wire wr_en0, full0;
//assign wr_en0 = sum_out0 ? 1:0;
assign wr_en0 = (|sum_out0 && !full0) ? 1:0;

asyn_fifo #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) afifo_instance0(
	.wr_clk(clk0),  
	.rd_clk(clk1),      
	.reset(reset),
	.wr_en(wr_en0),
	.wr_data(sum_out0),
	.rd_en(rd_en0),
	.rd_data(sum_out0_to1),
	.full(full0),
	.empty(afifo_empty0)
);
core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance1 (
      .reset(reset1), 
      .clk(clk1), 
      .mem_in(mem_in1), 
      .inst(inst1),
      .out(out1),
      .sum_out(sum_out1),
      .sum_in(sum_out0_to1),
      .afifo_empty(afifo_empty0),
      .rd_en(rd_en0)
);
wire wr_en1, full1;
//assign wr_en1 = sum_out1 ? 1:0;
assign wr_en1 = (|sum_out1 && !full1) ? 1:0;
asyn_fifo #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) afifo_instance1(
	.wr_clk(clk1),   
	.rd_clk(clk0),     
	.reset(reset1),
	.wr_en(wr_en1),
	.wr_data(sum_out1),
	.rd_en(rd_en1),
	.rd_data(sum_out1_to0),
	.full(full1),
	.empty(afifo_empty1)
);

always @(posedge clk0) begin
      if(|out)
         $display("Out %x ", out ); 
  end

endmodule
