// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sfp_row (clk, acc, div, sum_out, sum_in, sfp_in, sfp_out, reset, afifo_empty, rd_en);  //sum_in,fifo_ext_rd

  parameter col = 8;
  parameter bw = 4;
  parameter bw_psum = 2*bw+8;  //16

  input  clk, div, acc, reset;// fifo_ext_rd;
  input  [bw_psum+3:0] sum_in;
  input  [col*bw_psum-1:0] sfp_in;
  input afifo_empty;
  wire  [col*bw_psum-1:0] abs;
  reg    div_q;
  output [col*bw_psum-1:0] sfp_out;
  output [bw_psum+3:0] sum_out;
  output rd_en;
  wire [bw_psum+3:0] sum_this_core;
  reg [bw_psum+3:0] sum_q;  
  assign sum_out = sum_q;
  
  wire signed [bw_psum-1:0] sfp_in_sign0;
  wire signed [bw_psum-1:0] sfp_in_sign1;
  wire signed [bw_psum-1:0] sfp_in_sign2;
  wire signed [bw_psum-1:0] sfp_in_sign3;
  wire signed [bw_psum-1:0] sfp_in_sign4;
  wire signed [bw_psum-1:0] sfp_in_sign5;
  wire signed [bw_psum-1:0] sfp_in_sign6;
  wire signed [bw_psum-1:0] sfp_in_sign7;


  reg signed [bw_psum-1:0] sfp_out_sign0;
  reg signed [bw_psum-1:0] sfp_out_sign1;
  reg signed [bw_psum-1:0] sfp_out_sign2;
  reg signed [bw_psum-1:0] sfp_out_sign3;
  reg signed [bw_psum-1:0] sfp_out_sign4;
  reg signed [bw_psum-1:0] sfp_out_sign5;
  reg signed [bw_psum-1:0] sfp_out_sign6;
  reg signed [bw_psum-1:0] sfp_out_sign7;

 
  reg fifo_wr;

  assign sfp_in_sign0 =  sfp_in[bw_psum*1-1 : bw_psum*0];
  assign sfp_in_sign1 =  sfp_in[bw_psum*2-1 : bw_psum*1];
  assign sfp_in_sign2 =  sfp_in[bw_psum*3-1 : bw_psum*2];
  assign sfp_in_sign3 =  sfp_in[bw_psum*4-1 : bw_psum*3];
  assign sfp_in_sign4 =  sfp_in[bw_psum*5-1 : bw_psum*4];
  assign sfp_in_sign5 =  sfp_in[bw_psum*6-1 : bw_psum*5];
  assign sfp_in_sign6 =  sfp_in[bw_psum*7-1 : bw_psum*6];
  assign sfp_in_sign7 =  sfp_in[bw_psum*8-1 : bw_psum*7];


  assign sfp_out[bw_psum*1-1 : bw_psum*0] = sfp_out_sign0;
  assign sfp_out[bw_psum*2-1 : bw_psum*1] = sfp_out_sign1;
  assign sfp_out[bw_psum*3-1 : bw_psum*2] = sfp_out_sign2;
  assign sfp_out[bw_psum*4-1 : bw_psum*3] = sfp_out_sign3;
  assign sfp_out[bw_psum*5-1 : bw_psum*4] = sfp_out_sign4;
  assign sfp_out[bw_psum*6-1 : bw_psum*5] = sfp_out_sign5;
  assign sfp_out[bw_psum*7-1 : bw_psum*6] = sfp_out_sign6;
  assign sfp_out[bw_psum*8-1 : bw_psum*7] = sfp_out_sign7;

  wire [bw_psum+3:0] sum_2core;
  assign sum_2core = sum_this_core + sum_in;
// assign sum_2core = sum_this_core[bw_psum+3:7] + sum_in[bw_psum+3:7];
  
  assign abs[bw_psum*1-1 : bw_psum*0] = (sfp_in[bw_psum*1-1]) ?  (~sfp_in[bw_psum*1-1 : bw_psum*0] + 1)  :  sfp_in[bw_psum*1-1 : bw_psum*0];
  assign abs[bw_psum*2-1 : bw_psum*1] = (sfp_in[bw_psum*2-1]) ?  (~sfp_in[bw_psum*2-1 : bw_psum*1] + 1)  :  sfp_in[bw_psum*2-1 : bw_psum*1];
  assign abs[bw_psum*3-1 : bw_psum*2] = (sfp_in[bw_psum*3-1]) ?  (~sfp_in[bw_psum*3-1 : bw_psum*2] + 1)  :  sfp_in[bw_psum*3-1 : bw_psum*2];
  assign abs[bw_psum*4-1 : bw_psum*3] = (sfp_in[bw_psum*4-1]) ?  (~sfp_in[bw_psum*4-1 : bw_psum*3] + 1)  :  sfp_in[bw_psum*4-1 : bw_psum*3];
  assign abs[bw_psum*5-1 : bw_psum*4] = (sfp_in[bw_psum*5-1]) ?  (~sfp_in[bw_psum*5-1 : bw_psum*4] + 1)  :  sfp_in[bw_psum*5-1 : bw_psum*4];
  assign abs[bw_psum*6-1 : bw_psum*5] = (sfp_in[bw_psum*6-1]) ?  (~sfp_in[bw_psum*6-1 : bw_psum*5] + 1)  :  sfp_in[bw_psum*6-1 : bw_psum*5];
  assign abs[bw_psum*7-1 : bw_psum*6] = (sfp_in[bw_psum*7-1]) ?  (~sfp_in[bw_psum*7-1 : bw_psum*6] + 1)  :  sfp_in[bw_psum*7-1 : bw_psum*6];
  assign abs[bw_psum*8-1 : bw_psum*7] = (sfp_in[bw_psum*8-1]) ?  (~sfp_in[bw_psum*8-1 : bw_psum*7] + 1)  :  sfp_in[bw_psum*8-1 : bw_psum*7];

wire empty,rd_en;
assign rd_en = !afifo_empty && !empty;

  fifo_nodirectout #(.bw(bw_psum+4)) fifo_inst_int0 (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(sum_q),
     .out(sum_this_core), 
     .rd(rd_en), 
     .wr(div_q), 
     .o_full(),
     .o_empty(empty),
     .reset(reset)
  );

  reg [127:0] abs_reg;
  always@(posedge clk) begin
	if(reset) begin
		abs_reg <= 0;
	end
	else begin
		abs_reg <= abs;
	end
  end

  wire [127:0] abs_delay;
  assign abs_delay = abs_reg;

  wire [bw_psum*col-1:0] abs_this_core;

  fifo_nodirectout #(.bw(col*bw_psum)) fifo_inst_int1 (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(abs_delay),
     .out(abs_this_core), 
     .rd(rd_en), 
     .wr(div_q), 
     .reset(reset)
  );


  always @ (posedge clk) begin
    if (reset) begin
      fifo_wr <= 0;
    end
    else begin
       div_q <= div ;
       if (acc) begin     
         sum_q <= 
           {4'b0, abs[bw_psum*1-1 : bw_psum*0]} +
           {4'b0, abs[bw_psum*2-1 : bw_psum*1]} +
           {4'b0, abs[bw_psum*3-1 : bw_psum*2]} +
           {4'b0, abs[bw_psum*4-1 : bw_psum*3]} +
           {4'b0, abs[bw_psum*5-1 : bw_psum*4]} +
           {4'b0, abs[bw_psum*6-1 : bw_psum*5]} +
           {4'b0, abs[bw_psum*7-1 : bw_psum*6]} +
           {4'b0, abs[bw_psum*8-1 : bw_psum*7]} ;
         fifo_wr <= 1;
       end
       if (rd_en) begin       
           sfp_out_sign0 <= {abs_this_core[bw_psum*1-1 : bw_psum*0],12'b000000000000} / sum_2core;
           sfp_out_sign1 <= {abs_this_core[bw_psum*2-1 : bw_psum*1],12'b000000000000} / sum_2core;
           sfp_out_sign2 <= {abs_this_core[bw_psum*3-1 : bw_psum*2],12'b000000000000} / sum_2core;
           sfp_out_sign3 <= {abs_this_core[bw_psum*4-1 : bw_psum*3],12'b000000000000} / sum_2core;
           sfp_out_sign4 <= {abs_this_core[bw_psum*5-1 : bw_psum*4],12'b000000000000} / sum_2core;
           sfp_out_sign5 <= {abs_this_core[bw_psum*6-1 : bw_psum*5],12'b000000000000} / sum_2core;
           sfp_out_sign6 <= {abs_this_core[bw_psum*7-1 : bw_psum*6],12'b000000000000} / sum_2core;
           sfp_out_sign7 <= {abs_this_core[bw_psum*8-1 : bw_psum*7],12'b000000000000} / sum_2core;
       end
       else begin
         fifo_wr <= 0;
       end
   end
 end


endmodule

