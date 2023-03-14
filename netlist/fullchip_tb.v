// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 

`timescale 1ns/1ps

module fullchip_tb;


parameter total_cycle = 8;   // how many streamed Q vectors will be processed
parameter bw = 4;            // Q & K vector bit precision
parameter bw_psum = 2*bw+4;  // partial sum bit precision
parameter pr = 8;           // how many products added in each dot product 
parameter col = 8;           // how many dot product units are equipped

integer vn_file ; // file handler
integer vn_scan_file ; // file handler

reg [7:0] data_bin;
integer  captured_data;
//integer  weight [col*pr-1:0];
integer weight ;    //for dec2bin of N data(255~0)
`define NULL 0



integer  N_8b[col -1:0][pr-1:0];
integer  N[col-1:0][pr-1:0];
integer  V[total_cycle-1:0][pr-1:0];
integer  V_abs[total_cycle-1:0][pr-1:0];

integer  result[total_cycle-1:0][col-1:0];
integer  result_abs[total_cycle-1:0][col-1:0];
integer  sum[total_cycle-1:0];

integer i,j,k,t,p,q,s,u, m;


//core0
reg reset = 1;
reg clk = 0;
reg [pr*bw*2-1:0] mem_in;     
reg norm_rd = 0;
reg norm_wr = 0;
reg norm =0;
reg div = 0;
reg acc = 0;
reg col_c = 0;              
reg ofifo_rd = 0;           
wire [27:0] inst; 
reg vmem_rd = 0;
reg vmem_wr = 0; 
reg nmem_rd = 0; 
reg nmem_wr = 0;
reg pmem_rd = 0; 
reg pmem_wr = 0; 
reg execute = 0;
reg load = 0;
reg [3:0] vnmem_add = 0;
reg [3:0] pmem_add = 0;
reg [3:0] norm_add = 0;
reg unsign = 1;

assign inst[27] = unsign;
assign inst[26:23] = norm_add;
assign inst[22] = norm_wr;
assign inst[21] = norm_rd;
assign inst[20] = norm;
assign inst[19] = div;
assign inst[18] = acc;
assign inst[17] = col_c;
assign inst[16] = ofifo_rd;
assign inst[15:12] = vnmem_add;
assign inst[11:8]  = pmem_add;
assign inst[7] = execute;
assign inst[6] = load;
assign inst[5] = vmem_rd;
assign inst[4] = vmem_wr;
assign inst[3] = nmem_rd;
assign inst[2] = nmem_wr;
assign inst[1] = pmem_rd;
assign inst[0] = pmem_wr;

reg [bw_psum-1:0] temp5b;
reg [bw_psum-1:0] temp5b_abs;

reg [bw_psum+3:0] temp_sum;
reg [bw_psum*col-1:0] temp16b;
reg [bw_psum*col-1:0] temp16b_abs;

reg [bw_psum+3:0] psum_result;
reg [(bw_psum+4)*4-1:0] cycle_result;
reg [bw_psum+3:0] psum_abs;
reg [(bw_psum+4)*4-1:0] cycle_abs;
reg [bw_psum+7:0]	sum_core0_8est;
reg [(bw_psum+4)*4-1:0]	out_core0_8est;


//core1

integer vn_file1 ; // file handler
integer vn_scan_file1 ; // file handler

reg [7:0] data_bin1;
integer  captured_data1;

integer  N_8b1[col -1:0][pr-1:0];
integer  N1[col-1:0][pr-1:0];
integer  V1[total_cycle-1:0][pr-1:0];
integer  V1_abs[total_cycle-1:0][pr-1:0];
integer  result1[total_cycle-1:0][col-1:0];
integer  result1_abs[total_cycle-1:0][col-1:0];
integer  sum1[total_cycle-1:0];

reg reset1 = 1;
reg clk1 =1;
reg [pr*bw*2-1:0] mem_in1;     
reg norm_rd1 = 0;
reg norm_wr1 = 0;
reg norm1 =0;
reg div1 = 0;
reg acc1 = 0;
reg col_c1 = 0;              
reg ofifo_rd1 = 0;           
wire [27:0] inst1; 
reg vmem_rd1 = 0;
reg vmem_wr1 = 0; 
reg nmem_rd1 = 0; 
reg nmem_wr1 = 0;
reg pmem_rd1 = 0; 
reg pmem_wr1 = 0; 
reg execute1 = 0;
reg load1 = 0;
reg [3:0] vnmem_add1 = 0;
reg [3:0] pmem_add1 = 0;
reg [3:0] norm_add1 = 0;
reg unsign1 = 1;

assign inst1[27] = unsign1;
assign inst1[26:23] = norm_add1;
assign inst1[22] = norm_wr1;
assign inst1[21] = norm_rd1;
assign inst1[20] = norm1;
assign inst1[19] = div1;
assign inst1[18] = acc1;
assign inst1[17] = col_c1;
assign inst1[16] = ofifo_rd1;
assign inst1[15:12] = vnmem_add1;
assign inst1[11:8]  = pmem_add1;
assign inst1[7] = execute1;
assign inst1[6] = load1;
assign inst1[5] = vmem_rd1;
assign inst1[4] = vmem_wr1;
assign inst1[3] = nmem_rd1;
assign inst1[2] = nmem_wr1;
assign inst1[1] = pmem_rd1;
assign inst1[0] = pmem_wr1;

reg [bw_psum-1:0] temp5b1;
reg [bw_psum-1:0] temp5b1_abs;

reg [bw_psum+3:0] temp_sum1;
reg [bw_psum*col-1:0] temp16b1;
reg [bw_psum*col-1:0] temp16b1_abs;

reg [bw_psum+3:0] psum_result1;
reg [(bw_psum+4)*4-1:0] cycle_result1;
reg [bw_psum+3:0] psum1_abs;
reg [(bw_psum+4)*4-1:0] cycle1_abs;
reg [bw_psum+7:0]	sum_core1_8est;
reg [(bw_psum+4)*4-1:0]	out_core1_8est;


reg [bw_psum+7:0] sum_core0_est;
reg [bw_psum+7:0] sum_core1_est;
reg [bw_psum*col-1:0]out_core0_est;
reg [bw_psum*col-1:0]out_core1_est;

reg [bw_psum*col-1:0]out_2core_est;
reg [(bw_psum+4)*4-1:0]	out_2core_8est;








fullchip #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) fullchip_instance (
      .reset(reset),
      .reset1(reset1),
      .clk0(clk), 
      .clk1(clk1),
      .mem_in(mem_in), 
      .mem_in1(mem_in1),
      .inst(inst),
      .inst1(inst1)
);

function [11:0] abs12 ;
  input [11:0] binary;
  begin
    if (binary[11]==1'b1)begin
      abs12 = -binary;
    end
    else begin
      abs12 = binary;
    end
  end
endfunction

function [15:0] abs16 ;
  input [15:0] binary;
  begin
    if (binary[15]==1'b1)begin
      abs16 = -binary;
    end
    else begin
      abs16 = binary;
    end
  end
endfunction

function [7:0] dec2bin ;
  input integer  weight ;
  begin
    if (weight>127)begin
     dec2bin[7] = 1;
     weight = weight - 128;
    end
    else
     dec2bin[7] = 0;

    if (weight>63) begin
     dec2bin[6] = 1;
     weight = weight - 64;
    end
    else 
     dec2bin[6] = 0;

    if (weight>31) begin
     dec2bin[5] = 1;
     weight = weight - 32;
    end
    else 
     dec2bin[5] = 0;

    if (weight>15)begin
     dec2bin[4] = 1;
     weight = weight - 16;
    end
    else
     dec2bin[4] = 0;

    if (weight>7) begin
     dec2bin[3] = 1;
     weight = weight - 8;
    end
    else 
     dec2bin[3] = 0;

    if (weight>3) begin
     dec2bin[2] = 1;
     weight = weight - 4;
    end
    else 
     dec2bin[2] = 0;

    if (weight>1) begin
     dec2bin[1] = 1;
     weight = weight - 2;
    end
    else 
     dec2bin[1] = 0;

    if (weight>0) 
     dec2bin[0] = 1;
    else 
     dec2bin[0] = 0;
  end
endfunction


                      ////    core0 start     /////

initial begin 

  $dumpfile("fullchip_tb.vcd");
  $dumpvars(0,fullchip_tb);




//////////////////////// 4bit 8col start (col_c=0) (core0)//////////////////////



///// V data txt reading /////

$display("##### V data txt reading #####");


  vn_file = $fopen("pos_vdata.txt", "r");
  vn_file1 = $fopen("pos_vdata.txt", "r");

  //// To get rid of first 4 data in data file ////
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);


  for (q=0; q<total_cycle; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          vn_scan_file = $fscanf(vn_file, "%d\n", captured_data);
          V[q][j] = captured_data;
          vn_scan_file1 = $fscanf(vn_file1, "%d\n", captured_data1);
          V1[q][j] = captured_data1;
          $display("%d\n", V[q][j]);
//          $display("%d\n", V1[q][j]);
    end
  end
/////////////////////////////////




  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;   clk1 = 1'b1; 
    #0.5 clk = 1'b1;   clk1 = 1'b0; 
  end




///// N data txt reading /////  N need to be divided in to 2 4bits binary number

$display("##### N data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   clk1 = 1'b1; 
    if(q==9) reset1 = 0;
    #0.5 clk = 1'b1;   clk1 = 1'b0; 
  end
  reset = 0;
  

  vn_file = $fopen("ndata.txt", "r");
  vn_file1 = $fopen("ndata.txt", "r");

  //// To get rid of first 4 data in data file ////
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);

  for (q=0; q<col; q=q+2) begin
    for (j=0; j<pr; j=j+1) begin
          vn_scan_file = $fscanf(vn_file, "%d\n", captured_data);
          data_bin = dec2bin(captured_data);
          N_8b[q][j] = captured_data;     //for 4col use
          N[q][j] = data_bin[7:4];     //for 8col use
          N[q+1][j] = data_bin[3:0];   //for 8col use


          vn_scan_file1 = $fscanf(vn_file1, "%d\n", captured_data1);
          data_bin1 = dec2bin(captured_data1);
          N_8b1[q][j] = captured_data1;     //for 4col use
          N1[q][j] = data_bin1[7:4];     //for 8col use
          N1[q+1][j] = data_bin1[3:0];   //for 8col use
//	  $display("##### %d\n", captured_data);
//          $display("##### %d\n", N[q][j]);
//	  $display("##### %d\n", N[q+1][j]);
//	  $display("##### %d\n", N_8b[q][j]);
    end
  end
/////////////////////////////////








/////////////// Estimated result printing /////////////////


$display("##### Estimated 4bit out #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result[t][q] = 0;
       result1[t][q] = 0;

     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + V[t][k] * N[q][k];
            result1[t][q] = result1[t][q] + V1[t][k] * N1[q][k];
//	    $display("%d\n", result[t][q]);
//	    $display("%d\n", result_abs[t][q]);
         end

         temp5b = result[t][q];
         temp16b = {temp16b[83:0], temp5b};   
	 temp5b_abs = abs12(result[t][q]);  
	 temp16b_abs =  {temp16b_abs[83:0], temp5b_abs};

         temp5b1 = result1[t][q];
         temp16b1 = {temp16b1[83:0], temp5b1}; 
	 temp5b1_abs = abs12(result1[t][q]);
	 temp16b1_abs =  {temp16b1_abs[83:0], temp5b1_abs};

	 sum_core0_est = temp16b_abs[11:0]+temp16b_abs[23:12]+temp16b_abs[35:24]
	 		+temp16b_abs[47:36]+temp16b_abs[59:48]+temp16b_abs[71:60]
			+temp16b_abs[83:72]+temp16b_abs[95:84];

	 sum_core1_est = temp16b1_abs[11:0]+temp16b1_abs[23:12]+temp16b1_abs[35:24]
	 		+temp16b1_abs[47:36]+temp16b1_abs[59:48]+temp16b1_abs[71:60]
			+temp16b1_abs[83:72]+temp16b1_abs[95:84];

	 out_core0_est[11:0] = {temp16b_abs[11:0],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core0_est[23:12] = {temp16b_abs[23:12],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core0_est[35:24] = {temp16b_abs[35:24],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core0_est[47:36] = {temp16b_abs[47:36],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core0_est[59:48] = {temp16b_abs[59:48],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core0_est[71:60] = {temp16b_abs[71:60],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core0_est[83:72] = {temp16b_abs[83:72],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core0_est[95:84] = {temp16b_abs[95:84],12'b000000000000}/(sum_core0_est + sum_core1_est);

	 out_core1_est[11:0] = {temp16b1_abs[11:0],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core1_est[23:12] = {temp16b1_abs[23:12],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core1_est[35:24] = {temp16b1_abs[35:24],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core1_est[47:36] = {temp16b1_abs[47:36],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core1_est[59:48] = {temp16b1_abs[59:48],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core1_est[71:60] = {temp16b1_abs[71:60],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core1_est[83:72] = {temp16b1_abs[83:72],12'b000000000000}/(sum_core0_est + sum_core1_est);
	 out_core1_est[95:84] = {temp16b1_abs[95:84],12'b000000000000}/(sum_core0_est + sum_core1_est);

	 out_2core_est =  out_core0_est +  out_core1_est;


     end

//     $display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
//     $display("%d %d %d %d %d %d %d %d", temp16b[95:84], temp16b[83:72], temp16b[71:60], temp16b[59:48], temp16b[47:36], temp16b[35:24], temp16b[23:12], temp16b[11:0]);
//     $display("%h %h %h %h %h %h %h %h", temp16b[95:84], temp16b[83:72], temp16b[71:60], temp16b[59:48], temp16b[47:36], temp16b[35:24], temp16b[23:12], temp16b[11:0]);
//     $display("prd core0 @cycle%2d: %h", t, temp16b);  
//     $display("prd core0 @cycle%2d: %h", t, temp16b_abs); 
//     $display("prd core0 @cycle%2d: %h", t, sum_core0_est);
//     $display("prd core0 @cycle%2d: %h", t, out_core0_est);

//     $display("prd core1 @cycle%2d: %h", t, temp16b1);     
//     $display("prd core1 @cycle%2d: %h", t, temp16b1_abs);
//     $display("prd core0 @cycle%2d: %h", t, sum_core1_est);
//     $display("prd core0 @cycle%2d: %h", t, out_core1_est);

     $display("4bit estimate  @cycle%2d: %h", t, out_2core_est); 

  end

//////////////////////////////////////////////






///// Vmem writing  /////

$display("##### Vmem writing  #####");

  for (q=0; q<total_cycle; q=q+1) begin

    #0.5 clk = 1'b0;  clk1 = 1'b1;
    vmem_wr = 1;  if (q>0) vnmem_add = vnmem_add + 1; 
    
    mem_in[2*bw-1:0*bw] = V[q][0];    //7:0
    mem_in[4*bw-1:2*bw] = V[q][1];    //15:8
    mem_in[6*bw-1:4*bw] = V[q][2];
    mem_in[8*bw-1:6*bw] = V[q][3];
    mem_in[10*bw-1:8*bw] = V[q][4];
    mem_in[12*bw-1:10*bw] = V[q][5];
    mem_in[14*bw-1:12*bw] = V[q][6];
    mem_in[16*bw-1:14*bw] = V[q][7];  //2*4*8-1:
/*    mem_in[9*bw-1:8*bw] = Q[q][8];
    mem_in[10*bw-1:9*bw] = Q[q][9];
    mem_in[11*bw-1:10*bw] = Q[q][10];
    mem_in[12*bw-1:11*bw] = Q[q][11];
    mem_in[13*bw-1:12*bw] = Q[q][12];
    mem_in[14*bw-1:13*bw] = Q[q][13];
    mem_in[15*bw-1:14*bw] = Q[q][14];
    mem_in[16*bw-1:15*bw] = Q[q][15];
*/
    $display(" core0 @cycle%2d: %b", q, mem_in); 
/*    for(i=0; i<8; i=i+1) begin
	    $display(" core0 @cycle%2d: %b", q, V[q][i]); end
*/
    #0.5 clk = 1'b1;  clk1 = 1'b0;

    vmem_wr1 = 1;  if (q>0) vnmem_add1 = vnmem_add1 + 1; 
    
    mem_in1[2*bw-1:0*bw] = V1[q][0];    //7:0
    mem_in1[4*bw-1:2*bw] = V1[q][1];    //15:8
    mem_in1[6*bw-1:4*bw] = V1[q][2];
    mem_in1[8*bw-1:6*bw] = V1[q][3];
    mem_in1[10*bw-1:8*bw] = V1[q][4];
    mem_in1[12*bw-1:10*bw] = V1[q][5];
    mem_in1[14*bw-1:12*bw] = V1[q][6];
    mem_in1[16*bw-1:14*bw] = V1[q][7];  //2*4*8-1:

  end


  #0.5 clk = 1'b0;  clk1 = 1'b1;
  vmem_wr = 0; 
  vnmem_add = 0;
  #0.5 clk = 1'b1;  clk1 = 1'b0;
  vmem_wr1 = 0; 
  vnmem_add1 = 0;
///////////////////////////////////////////





///// Nmem writing  /////

$display("##### Nmem writing #####");

  for (q=0; q<col; q=q+1) begin

    #0.5 clk = 1'b0;  clk1 = 1'b1;
    nmem_wr = 1; if (q>0) vnmem_add = vnmem_add + 1; 
    
    mem_in[2*bw-1:0*bw] = N[q][0];    //7:0
    mem_in[4*bw-1:2*bw] = N[q][1];    //15:8
    mem_in[6*bw-1:4*bw] = N[q][2];
    mem_in[8*bw-1:6*bw] = N[q][3];
    mem_in[10*bw-1:8*bw] = N[q][4];
    mem_in[12*bw-1:10*bw] = N[q][5];
    mem_in[14*bw-1:12*bw] = N[q][6];
    mem_in[16*bw-1:14*bw] = N[q][7];  //2*4*8-1:
/*    mem_in[9*bw-1:8*bw] = K[q][8];
    mem_in[10*bw-1:9*bw] = K[q][9];
    mem_in[11*bw-1:10*bw] = K[q][10];
    mem_in[12*bw-1:11*bw] = K[q][11];
    mem_in[13*bw-1:12*bw] = K[q][12];
    mem_in[14*bw-1:13*bw] = K[q][13];
    mem_in[15*bw-1:14*bw] = K[q][14];
    mem_in[16*bw-1:15*bw] = K[q][15];
*/
    #0.5 clk = 1'b1;  clk1 = 1'b0;
    nmem_wr1 = 1; if (q>0) vnmem_add1 = vnmem_add1 + 1; 
    
    mem_in1[2*bw-1:0*bw] = N1[q][0];    //7:0
    mem_in1[4*bw-1:2*bw] = N1[q][1];    //15:8
    mem_in1[6*bw-1:4*bw] = N1[q][2];
    mem_in1[8*bw-1:6*bw] = N1[q][3];
    mem_in1[10*bw-1:8*bw] = N1[q][4];
    mem_in1[12*bw-1:10*bw] = N1[q][5];
    mem_in1[14*bw-1:12*bw] = N1[q][6];
    mem_in1[16*bw-1:14*bw] = N1[q][7];  //2*4*8-1:

  end

  #0.5 clk = 1'b0;  clk1 = 1'b1;
  nmem_wr = 0;  
  vnmem_add = 0;
  #0.5 clk = 1'b1;  clk1 = 1'b0;
  nmem_wr1 = 0;  
  vnmem_add1 = 0;
///////////////////////////////////////////



  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;  clk1 = 1'b1;
    #0.5 clk = 1'b1;  clk1 = 1'b0;
  end




/////  N data loading  /////
$display("##### N data loading to processor #####");

  for (q=0; q<col+1; q=q+1) begin
    #0.5 clk = 1'b0;  clk1 = 1'b1;
    load = 1; 
    if (q==1) nmem_rd = 1;
    if (q>1) begin
       vnmem_add = vnmem_add + 1;
    end

    #0.5 clk = 1'b1;  clk1 = 1'b0;
    load1 = 1; 
    if (q==1) nmem_rd1 = 1;
    if (q>1) begin
       vnmem_add1 = vnmem_add1 + 1;
    end

  end

  #0.5 clk = 1'b0;  clk1 = 1'b1;
  nmem_rd = 0; vnmem_add = 0;
  #0.5 clk = 1'b1;  clk1 = 1'b0;
  nmem_rd1 = 0; vnmem_add1 = 0;

  #0.5 clk = 1'b0;  clk1 = 1'b1;
  load = 0; 
  #0.5 clk = 1'b1;  clk1 = 1'b0;  
  load1 = 0; 

///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   clk1 = 1'b1;
    #0.5 clk = 1'b1;   clk1 = 1'b0;
 end





///// execution  /////
$display("##### execute #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  clk1 = 1'b1;
    execute = 1; 
    vmem_rd = 1;

    if (q>0) begin
       vnmem_add = vnmem_add + 1;
    end

    #0.5 clk = 1'b1;  clk1 = 1'b0;

    execute1 = 1; 
    vmem_rd1 = 1;

    if (q>0) begin
       vnmem_add1 = vnmem_add1 + 1;
    end
  end

  #0.5 clk = 1'b0;  clk1 = 1'b1;
  vmem_rd = 0; vnmem_add = 0; execute = 0;
  #0.5 clk = 1'b1;  clk1 = 1'b0;
  vmem_rd1 = 0; vnmem_add1 = 0; execute1 = 0;


///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   clk1 = 1'b1;
    #0.5 clk = 1'b1;   clk1 = 1'b0;
 end




////////////// output fifo rd and wb to psum mem ///////////////////

$display("##### move ofifo to pmem #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk = 1'b0;  clk1 = 1'b1;
    ofifo_rd = 1; 
    pmem_wr = 1; 

    if (q>0) begin
       pmem_add = pmem_add + 1;
    end

    #0.5 clk = 1'b1;  clk1 = 1'b0;
    ofifo_rd1 = 1; 
    pmem_wr1 = 1; 

    if (q>0) begin
       pmem_add1 = pmem_add1 + 1;
    end
  end

  #0.5 clk = 1'b0;  clk1 = 1'b1;
  pmem_wr = 0; pmem_add = 0; ofifo_rd = 0;
  #0.5 clk = 1'b1;  clk1 = 1'b0;
  pmem_wr1 = 0; pmem_add1 = 0; ofifo_rd1 = 0;

///////////////////////////////////////////


// pmem_out from sram, no recofiguration, norm,  get sum from another core, write to norm sram //
$display("##### move pmem_out from sram, no recon, norm, get sum from another core,write to norm sram  #####");
  pmem_rd = 1;  //col_c = 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  pmem_rd1 = 1; //col_c1 = 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  pmem_add = pmem_add +1; acc = 1;div = 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  pmem_add1 = pmem_add1 +1; acc1 = 1; div1 = 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  for (q=0; q<total_cycle; q=q+1) begin
    pmem_add = pmem_add + 1;	  
    pmem_add1 = pmem_add1 + 1;	  
    if (q>4) begin
       norm_wr = 1;
       norm_wr1 = 1;
    end
//    div = 1;
    #0.5 clk = 1'b1; clk1 = 1'b0;
    div1 = 1;
    if (q>5) begin
       norm_add1 = norm_add1 + 1;
    end
    #0.5 clk = 1'b0; clk1 = 1'b1;
    if (q>5) begin
       norm_add = norm_add + 1;
    end
  end     
  #0.5 clk = 1'b1; clk1 = 1'b0;
  norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  pmem_rd = 0; pmem_add = 0; norm_add = norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  pmem_rd1 = 0; pmem_add1 = 0;norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  acc =0; norm_add =norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  acc1 =0; norm_add1 = norm_add1 + 1; //col_c =0;

  #0.5 clk = 1'b0; clk1 = 1'b1;
  norm_add =norm_add + 1; //col_c1 =0;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  norm_add =norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  div = 0;norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  div1 = 0;  norm_add =norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  norm_wr1 = 0; norm_add1 =0;
  #0.5 clk = 1'b0; clk1 = 1'b1; 
  div = 0;norm_wr = 0; norm_add =0;
  
  for (q=0; q<5; q=q+1) begin
	  #0.5 clk = 1'b1; clk1 = 1'b0;
	  #0.5 clk = 1'b0; clk1 = 1'b1;
  end

  //////////////////// 4bit 8col end////////////////////////////////////






  //////////////////// 8bit 4col start//////////////////////////////////

/////////////// Estimated result printing /////////////////


$display("##### Estimated 8bit out #####");


  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result[t][q] = 0;
       result1[t][q] = 0;
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+2) begin
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + V[t][k] * N_8b[q][k];
            result1[t][q] = result1[t][q] + V1[t][k] * N_8b1[q][k];
//	    $display("%d",result[t][q]);
         end

         psum_result = result[t][q];
         cycle_result = {cycle_result[47:0], psum_result};
	 psum_abs = abs16(result[t][q]);  
	 cycle_abs =  {cycle_abs[47:0], psum_abs};

         psum_result1 = result1[t][q];
         cycle_result1 = {cycle_result1[47:0], psum_result1};
	 psum1_abs = abs16(result1[t][q]);  
	 cycle1_abs =  {cycle1_abs[47:0], psum1_abs};

//	 $display("%h",psum_abs);
//	 $display("%h",psum_result);

	 sum_core0_8est = cycle_abs[15:0]+cycle_abs[31:16]+cycle_abs[47:32]
	 		+cycle_abs[63:48];
	 sum_core1_8est = cycle1_abs[15:0]+cycle1_abs[31:16]+cycle1_abs[47:32]
	 		+cycle1_abs[63:48];	 
	
         out_core0_8est[15:0] = {cycle_abs[15:0],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core0_8est[31:16] = {cycle_abs[31:16],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core0_8est[47:32] = {cycle_abs[47:32],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core0_8est[63:48] = {cycle_abs[63:48],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core0_8est[79:64] = {cycle_abs[79:64],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core0_8est[95:80] = {cycle_abs[95:80],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core0_8est[111:96] = {cycle_abs[111:96],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core0_8est[127:112] = {cycle_abs[127:112],12'b000000000000}/(sum_core0_8est + sum_core1_8est);

	 out_core1_8est[15:0] = {cycle1_abs[15:0],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core1_8est[31:16] = {cycle1_abs[31:16],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core1_8est[47:32] = {cycle1_abs[47:32],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core1_8est[63:48] = {cycle1_abs[63:48],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core1_8est[79:64] = {cycle1_abs[79:64],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core1_8est[95:80] = {cycle1_abs[95:80],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core1_8est[111:96] = {cycle1_abs[111:96],12'b000000000000}/(sum_core0_8est + sum_core1_8est);
	 out_core1_8est[127:112] = {cycle1_abs[127:112],12'b000000000000}/(sum_core0_8est + sum_core1_8est);

	 out_2core_8est =  out_core0_8est +  out_core1_8est;
     end

//     $display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
//     $display("core0 @cycle%2d: %h", t, cycle_result); 
//     $display("abs core @cycle%2d: %h", t, cycle_abs); 
//     $display("sum core0 @cycle%2d: %h", t, sum_core0_8est);
//     $display("sum core1 @cycle%2d: %h", t, sum_core1_8est);
//     $display("8bit estimate  @cycle%2d: %h", t, out_2core_8est);
  end

//////////////////////////////////////////////




// pmem_out from sram, reconfiguration, norm, get sum from another core, write to norm sram//
/*
$display("##### move pmem_out from sram, recon, norm, get sum from another core write to norm sram #####");
  col_c = 1;pmem_rd = 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  col_c1 = 1;pmem_rd1 = 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  pmem_add = pmem_add +1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  pmem_add1 = pmem_add1 +1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  for (q=0; q<total_cycle; q=q+1) begin
    pmem_add = pmem_add + 1;	  
    pmem_add1 = pmem_add1 + 1;	  
    if (q>4) begin
       norm_wr = 1;
       norm_wr1 = 1;
    end
    acc = 1; div = 1;
    #0.5 clk = 1'b1; clk1 = 1'b0;
    acc1 = 1; div1 = 1;
    if (q>5) begin
       norm_add1 = norm_add1 + 1;
    end
    #0.5 clk = 1'b0; clk1 = 1'b1;
    if (q>5) begin
       norm_add = norm_add + 1;
    end
  end     
  #0.5 clk = 1'b1; clk1 = 1'b0;
  norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  pmem_rd = 0; pmem_add = 0; norm_add = norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  pmem_rd1 = 0; pmem_add1 = 0;norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  acc =0; norm_add =norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  acc1 =0; col_c =0; norm_add1 = norm_add1 + 1;

  #0.5 clk = 1'b0; clk1 = 1'b1;
  col_c1 =0;  norm_add =norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  norm_add =norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  div = 0;norm_add1 = norm_add1 + 1;
  #0.5 clk = 1'b0; clk1 = 1'b1;
  div1 = 0;  norm_add =norm_add + 1;
  #0.5 clk = 1'b1; clk1 = 1'b0;
  norm_wr1 = 0; norm_add1 =0;
  #0.5 clk = 1'b0; clk1 = 1'b1; 
  div = 0;norm_wr = 0; norm_add =0;
  
  for (q=0; q<5; q=q+1) begin
	  #0.5 clk = 1'b1; clk1 = 1'b0;
	  #0.5 clk = 1'b0; clk1 = 1'b1;
  end
*/

  #10 $finish;
end




endmodule
