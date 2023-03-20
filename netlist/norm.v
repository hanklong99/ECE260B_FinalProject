module norm (clk, acc, div, sfp_in, sfp_out,reset);

  parameter col = 8;
  parameter bw = 4;
  parameter bw_psum = 2*bw+8;

  input  clk, div, acc;
  input  [127:0] sfp_in;
  wire  [127:0] abs;
  reg    div_q;
  output [127:0] sfp_out;
  wire [19:0] sum;
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

  fifo_depth16 #(.bw(bw_psum+4)) fifo_inst_int (
     .rd_clk(clk), 
     .wr_clk(clk), 
     .in(sum_q),
     .out(sum_this_core), 
     .rd(div_q), 
     .wr(fifo_wr), 
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
       else begin
         fifo_wr <= 0;
   
         if (div) begin
           sfp_out_sign0 <= sfp_in_sign0 / sum_this_core;
           sfp_out_sign1 <= sfp_in_sign1 / sum_this_core;
           sfp_out_sign2 <= sfp_in_sign2 / sum_this_core;
           sfp_out_sign3 <= sfp_in_sign3 / sum_this_core;
           sfp_out_sign4 <= sfp_in_sign4 / sum_this_core;
           sfp_out_sign5 <= sfp_in_sign5 / sum_this_core;
           sfp_out_sign6 <= sfp_in_sign6 / sum_this_core;
           sfp_out_sign7 <= sfp_in_sign7 / sum_this_core;



         end
       end
   end
 end

