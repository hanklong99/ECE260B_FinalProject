module norm (clk, acc, div, sfp_in, sfp_out, reset, sum_out, sum_other_core);

  parameter col = 8;
  parameter bw = 4;
  parameter bw_psum = 2*bw+8;

  input  clk, div, acc,reset;
  input  [127:0] sfp_in;
  wire  [127:0] abs;
  reg    div_q;
  output [127:0] sfp_out;
  output [19:0] sum_out;
  
  reg [19:0] sum_q;
  reg fifo_wr;
  
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

  assign sfp_in_sign0 =  sfp_in[(bw_psum)*1-1 : (bw_psum)*0];
  assign sfp_in_sign1 =  sfp_in[(bw_psum)*2-1 : (bw_psum)*1];
  assign sfp_in_sign2 =  sfp_in[(bw_psum)*3-1 : (bw_psum)*2];
  assign sfp_in_sign3 =  sfp_in[(bw_psum)*4-1 : (bw_psum)*3];
  assign sfp_in_sign4 =  sfp_in[(bw_psum)*5-1 : (bw_psum)*4];
  assign sfp_in_sign5 =  sfp_in[(bw_psum)*6-1 : (bw_psum)*5];
  assign sfp_in_sign6 =  sfp_in[(bw_psum)*7-1 : (bw_psum)*6];
  assign sfp_in_sign7 =  sfp_in[(bw_psum)*8-1 : (bw_psum)*7];

  assign sfp_out[(bw_psum)*1-1 : (bw_psum)*0] = sfp_out_sign0;
  assign sfp_out[(bw_psum)*2-1 : (bw_psum)*1] = sfp_out_sign1;
  assign sfp_out[(bw_psum)*3-1 : (bw_psum)*2] = sfp_out_sign2;
  assign sfp_out[(bw_psum)*4-1 : (bw_psum)*3] = sfp_out_sign3;
  assign sfp_out[(bw_psum)*5-1 : (bw_psum)*4] = sfp_out_sign4;
  assign sfp_out[(bw_psum)*6-1 : (bw_psum)*5] = sfp_out_sign5;
  assign sfp_out[(bw_psum)*7-1 : (bw_psum)*6] = sfp_out_sign6;
  assign sfp_out[(bw_psum)*8-1 : (bw_psum)*7] = sfp_out_sign7;

  assign abs[bw_psum*1-1 : bw_psum*0] = (sfp_in[bw_psum*1-1]) ?  (~sfp_in[bw_psum*1-1 : bw_psum*0] + 1)  :  sfp_in[bw_psum*1-1 : bw_psum*0];
  assign abs[bw_psum*2-1 : bw_psum*1] = (sfp_in[bw_psum*2-1]) ?  (~sfp_in[bw_psum*2-1 : bw_psum*1] + 1)  :  sfp_in[bw_psum*2-1 : bw_psum*1];
  assign abs[bw_psum*3-1 : bw_psum*2] = (sfp_in[bw_psum*3-1]) ?  (~sfp_in[bw_psum*3-1 : bw_psum*2] + 1)  :  sfp_in[bw_psum*3-1 : bw_psum*2];
  assign abs[bw_psum*4-1 : bw_psum*3] = (sfp_in[bw_psum*4-1]) ?  (~sfp_in[bw_psum*4-1 : bw_psum*3] + 1)  :  sfp_in[bw_psum*4-1 : bw_psum*3];
  assign abs[bw_psum*5-1 : bw_psum*4] = (sfp_in[bw_psum*5-1]) ?  (~sfp_in[bw_psum*5-1 : bw_psum*4] + 1)  :  sfp_in[bw_psum*5-1 : bw_psum*4];
  assign abs[bw_psum*6-1 : bw_psum*5] = (sfp_in[bw_psum*6-1]) ?  (~sfp_in[bw_psum*6-1 : bw_psum*5] + 1)  :  sfp_in[bw_psum*6-1 : bw_psum*5];
  assign abs[bw_psum*7-1 : bw_psum*6] = (sfp_in[bw_psum*7-1]) ?  (~sfp_in[bw_psum*7-1 : bw_psum*6] + 1)  :  sfp_in[bw_psum*7-1 : bw_psum*6];
  assign abs[bw_psum*8-1 : bw_psum*7] = (sfp_in[bw_psum*8-1]) ?  (~sfp_in[bw_psum*8-1 : bw_psum*7] + 1)  :  sfp_in[bw_psum*8-1 : bw_psum*7];
/*
  fifo_depth16 #(.bw(bw_psum+4)) fifo_inst_int (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(sum_q),
     .out(sum_this_core), 
     .rd(div_q), 
     .wr(fifo_wr), 
     .reset(reset)
  );
*/

wire [19:0] sum_out;
wire [20:0] sum_2core;
wire [19:0] sum_other_core;
assign sum_out = sum_q;
assign sum_2core = sum_q + sum_other_core;

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
       else begin
         fifo_wr <= 0;
   
         if (div) begin
           sfp_out_sign0 <= {abs[bw_psum*1-1 : bw_psum*0],12'b000000000000} / sum_2core;
           sfp_out_sign1 <= {abs[bw_psum*2-1 : bw_psum*1],12'b000000000000} / sum_2core;
           sfp_out_sign2 <= {abs[bw_psum*3-1 : bw_psum*2],12'b000000000000} / sum_2core;
           sfp_out_sign3 <= {abs[bw_psum*4-1 : bw_psum*3],12'b000000000000} / sum_2core;
           sfp_out_sign4 <= {abs[bw_psum*5-1 : bw_psum*4],12'b000000000000} / sum_2core;
           sfp_out_sign5 <= {abs[bw_psum*6-1 : bw_psum*5],12'b000000000000} / sum_2core;
           sfp_out_sign6 <= {abs[bw_psum*7-1 : bw_psum*6],12'b000000000000} / sum_2core;
           sfp_out_sign7 <= {abs[bw_psum*8-1 : bw_psum*7],12'b000000000000} / sum_2core;



         end
       end
   end
 end
endmodule

