// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module core (clk, sum_out, sum_in, mem_in, out, inst, reset);


parameter col = 8;
parameter bw = 4;
parameter bw_psum = 2*bw+4; //12
parameter pr = 8;  

output [bw_psum+7:0] sum_out;
input [bw_psum+7:0] sum_in;
output [(bw_psum+4)*col-1:0] out;
wire   [bw_psum*col-1:0] pmem_out;
input  [pr*bw*2-1:0] mem_in;
input  clk;
input  [26:0] inst; 
input  reset;

wire  [pr*bw*2-1:0] mac_in;
wire  [pr*bw*2-1:0] nmem_out;
wire  [pr*bw*2-1:0] vmem_out;
wire  [bw_psum*col-1:0] pmem_in;
wire  [bw_psum*col-1:0] fifo_out;
wire  [bw_psum*col-1:0] sfp_out;
wire  [bw_psum*col-1:0] array_out;
wire  [(bw_psum+4)*col-1:0] norm_in;
wire  [(bw_psum+4)*col-1:0] norm_out;

wire  [col-1:0] fifo_wr;
wire  ofifo_rd;
wire [3:0] vnmem_add;
wire [3:0] pmem_add;
wire [3:0] norm_add;

wire  vmem_rd;
wire  vmem_wr; 
wire  nmem_rd;
wire  nmem_wr; 
wire  pmem_rd;
wire  pmem_wr; 

assign norm_add = inst[26:23] ;
assign norm_wr = inst[22] ;
assign norm_rd= inst[21] ;
assign norm = inst[20];
assign div = inst[19];
assign acc = inst[18];
assign col_c = inst[17];
assign ofifo_rd = inst[16];
assign vnmem_add = inst[15:12];
assign pmem_add = inst[11:8];

assign vmem_rd = inst[5];
assign vmem_wr = inst[4];
assign nmem_rd = inst[3];
assign nmem_wr = inst[2];
assign pmem_rd = inst[1];
assign pmem_wr = inst[0];

assign mac_in  = inst[6] ? nmem_out : vmem_out;
assign pmem_in = fifo_out;
//assign out = pmem_out;
//assign out = col_c ? pmem_combined_reg : pmem_out_16bit;
assign out = pmem_norm_out;
/*
always@(posedge clk) begin
	if(reset)begin
		sum_out <= 0;
        end
	else begin
		sum_out <= pmem_out[bw_psum*1-1:0]         + pmem_out[bw_psum*2-1:bw_psum*1] 
		          +pmem_out[bw_psum*3-1:bw_psum*2] + pmem_out[bw_psum*4-1:bw_psum*3] 
			  +pmem_out[bw_psum*5-1:bw_psum*4] + pmem_out[bw_psum*6-1:bw_psum*5] 
		          +pmem_out[bw_psum*7-1:bw_psum*6] + pmem_out[bw_psum*8-1:bw_psum*7];
        end
end
*/
mac_array #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) mac_array_instance (
        .in(mac_in), 
        .clk(clk), 
        .reset(reset), 
        .inst(inst[7:6]),     
        .fifo_wr(fifo_wr),     
	.out(array_out)
);

ofifo #(.bw(bw_psum), .col(col))  ofifo_inst (
        .reset(reset),
        .clk(clk),
        .in(array_out),
        .wr(fifo_wr),      
        .rd(ofifo_rd),    
        .o_valid(fifo_valid),   
        .out(fifo_out)     
);                          

sram_w16 #(.sram_bit(pr*bw*2)) vmem_instance (
        .CLK(clk),
        .D(mem_in),
        .Q(vmem_out),
        .CEN(!(vmem_rd||vmem_wr)),
        .WEN(!vmem_wr), 
        .A(vnmem_add)
);

sram_w16 #(.sram_bit(pr*bw*2)) nmem_instance (
        .CLK(clk),
        .D(mem_in),
        .Q(nmem_out),
        .CEN(!(nmem_rd||nmem_wr)),
        .WEN(!nmem_wr), 
        .A(vnmem_add)
);

sram_160b_w16 #(.sram_bit(col*bw_psum)) psum_mem_instance (
        .CLK(clk),
        .D(pmem_in),
        .Q(pmem_out),
        .CEN(!(pmem_rd||pmem_wr)),
        .WEN(!pmem_wr), 
        .A(pmem_add)
);

reg [63:0] pmem_combined_reg;
reg col_c_reg = 0;

always@(posedge clk) begin
	if(reset) begin
		pmem_combined_reg <= 0;
	end
	else if (pmem_rd && col_c) begin
		col_c_reg <= col_c;
		if(col_c_reg)begin
		pmem_combined_reg[15:0] <= {pmem_out[23:12], 4'b0000} 
		                            + {{4{pmem_out[11]}},pmem_out[11:0]};
		pmem_combined_reg[31:16] <= {pmem_out[47:36], 4'b0000} 
		                            + {{4{pmem_out[35]}},pmem_out[35:24]};
		pmem_combined_reg[47:32] <= {pmem_out[71:60], 4'b0000} 
		                            + {{4{pmem_out[59]}},pmem_out[59:48]};
		pmem_combined_reg[63:48] <= {pmem_out[95:84], 4'b0000} 
		                            + {{4{pmem_out[83]}},pmem_out[83:72]};
		end
	end
end

wire [127:0] pmem_out_16bit;     //make each psum after 4*4 into 16bit, total 8*16 = 128bit
assign pmem_out_16bit = {{4{pmem_out[95]}},pmem_out[95:84],
			{4{pmem_out[83]}},pmem_out[83:72],
			{4{pmem_out[71]}},pmem_out[71:60],
			{4{pmem_out[59]}},pmem_out[59:48],
			{4{pmem_out[47]}},pmem_out[47:36],
			{4{pmem_out[35]}},pmem_out[35:24],
			{4{pmem_out[23]}},pmem_out[23:12],
			{4{pmem_out[11]}},pmem_out[11:0]};

wire [127:0] pmem_norm_in;     //select by col_c
assign pmem_norm_in = col_c ? pmem_combined_reg : pmem_out_16bit;
wire [127:0] pmem_norm_out; 

sfp_row #(.bw_psum(bw_psum+4)) sfp_instance (
        .clk(clk),
        .sfp_in(pmem_norm_in), 
        .sfp_out(pmem_norm_out), 
        .div(div),
        .acc(acc), 
        .reset(reset),
	.sum_out(sum_out),
	.sum_in(sum_in)
);
assign norm_in = pmem_norm_out;
sram_160b_w16 #(.sram_bit(col*(bw_psum+4))) psum_norm_mem_instance (
        .CLK(clk),
        .D(norm_in),
        .Q(norm_out),
        .CEN(!(norm_rd||norm_wr)),
        .WEN(!norm_wr), 
        .A(norm_add)
);


  //////////// For printing purpose ////////////
  always @(posedge clk) begin
      if(pmem_wr)
         $display("Memory write to PSUM mem add %x %x ", pmem_add, pmem_in); 
  end
/*

  always @(posedge clk) begin
      if(pmem_rd& !col_c)
         $display("PSUM mem out from sram  %x ", pmem_out); 
  end

  always @(posedge clk) begin
      if(pmem_combined_reg)
         $display("PSUM mem combined for 8b  %x ", pmem_combined_reg); 
  end

  always @(posedge clk) begin
      if(norm_in)
         $display("NORM result write to sram  %x ", norm_in); 
  end
*/

endmodule
