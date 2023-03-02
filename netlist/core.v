// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module core (clk, sum_out, mem_in, out, inst, reset);


parameter col = 8;
parameter bw = 4;
parameter bw_psum = 2*bw+4;
parameter pr = 8;  

output reg [bw_psum+3:0] sum_out;
output [bw_psum*col-1:0] out;
wire   [bw_psum*col-1:0] pmem_out;
input  [pr*bw*2-1:0] mem_in;
input  clk;
input  [17:0] inst; 
input  reset;

wire  [pr*bw*2-1:0] mac_in;
wire  [pr*bw*2-1:0] nmem_out;
wire  [pr*bw*2-1:0] vmem_out;
wire  [bw_psum*col-1:0] pmem_in;
wire  [bw_psum*col-1:0] fifo_out;
wire  [bw_psum*col-1:0] sfp_out;
wire  [bw_psum*col-1:0] array_out;
wire  [col-1:0] fifo_wr;
wire  ofifo_rd;
wire [3:0] vnmem_add;
wire [3:0] pmem_add;

wire  vmem_rd;
wire  vmem_wr; 
wire  nmem_rd;
wire  nmem_wr; 
wire  pmem_rd;
wire  pmem_wr; 

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
assign out = pmem_out;

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

mac_array #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) mac_array_instance (
        .in(mac_in), 
        .clk(clk), 
        .reset(reset), 
        .inst(inst[7:6]),     
        .fifo_wr(fifo_wr),     
	.out(array_out),
	.col_c(inst[17])
);

ofifo #(.bw(bw_psum), .col(col))  ofifo_inst (
        .reset(reset),
        .clk(clk),
        .in(array_out),
        .wr(fifo_wr),      //8bit fifo_wr defined in mac_array and mac_col
        .rd(ofifo_rd),     //1bit fifo_wr defined in mac_col (2cyc late than i_inst
        .o_valid(fifo_valid),   //1bit fifo_wr means col by col mac(20bit) is done and psum can b output
        .out(fifo_out)          //8bit fifo_wr means col(Q) by array(K) is done(160bit) and out can b output                                          to ofifo, the bit width of ofifo is 8*20=160
);                              //only 8 col by array result, so fifo only need 8 depth


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



  //////////// For printing purpose ////////////
  always @(posedge clk) begin
      if(pmem_wr)
         $display("Memory write to PSUM mem add %x %x ", pmem_add, pmem_in); 
  end

  always @(posedge clk) begin
      if(pmem_rd)
         $display("PSUM mem out from sram  %x ", pmem_out); 
  end


endmodule
