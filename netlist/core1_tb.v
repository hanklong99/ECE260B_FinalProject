reg reset1 = 1;
reg clk1 =0;
reg [pr*bw*2-1:0] mem_in1;     
reg norm_rd1 = 0;
reg norm_wr1 = 0;
reg norm1 =0;
reg div1 = 0;
reg acc1 = 0;
reg col_c1 = 0;              
reg ofifo_rd1 = 0;           
wire [26:0] inst1; 
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




initial begin 

  $dumpfile("fullchip_tb.vcd");
  $dumpvars(0,fullchip_tb);




/////////////////////// 4bit 8col start (col_c=0) (core1) //////////////////////



///// V data txt reading /////

$display("##### V data txt reading #####");


  vn_file = $fopen("vdata.txt", "r");

  //// To get rid of first 4 data in data file ////
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);
//  vn_scan_file = $fscanf(vn_file, "%s\n", captured_data);


  for (q=0; q<total_cycle; q=q+1) begin
    for (j=0; j<pr; j=j+1) begin
          vn_scan_file = $fscanf(vn_file, "%d\n", captured_data);
          V[q][j] = captured_data;
//          $display("%d\n", V[q][j]);
    end
  end
/////////////////////////////////



//  #0.1
  for (q=0; q<2; q=q+1) begin
    #0.5 clk1 = 1'b0;   
    #0.5 clk1 = 1'b1;   
  end




///// N data txt reading /////  N need to be divided in to 2 4bits binary number

$display("##### N data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk1 = 1'b0;   
    #0.5 clk1 = 1'b1;   
  end
  reset1 = 0;

  vn_file = $fopen("ndata.txt", "r");

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
//	  $display("##### %d\n", captured_data);
//          $display("##### %d\n", N[q][j]);
//	  $display("##### %d\n", N[q+1][j]);
//	  $display("##### %d\n", N_8b[q][j]);
    end
  end
/////////////////////////////////








/////////////// Estimated result printing /////////////////


$display("##### Estimated 4bit multiplication result #####");

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result[t][q] = 0;
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + V[t][k] * N[q][k];
	    //$display("%d",k);
         end

         temp5b = result[t][q];
         temp16b = {temp16b[83:0], temp5b};    
     end

//     $display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
//     $display("%d %d %d %d %d %d %d %d", temp16b[95:84], temp16b[83:72], temp16b[71:60], temp16b[59:48], temp16b[47:36], temp16b[35:24], temp16b[23:12], temp16b[11:0]);
//     $display("%h %h %h %h %h %h %h %h", temp16b[95:84], temp16b[83:72], temp16b[71:60], temp16b[59:48], temp16b[47:36], temp16b[35:24], temp16b[23:12], temp16b[11:0]);
     $display("prd @cycle%2d: %h", t, temp16b);    //%40h

  end

//////////////////////////////////////////////






///// Vmem writing  /////

$display("##### Vmem writing  #####");

  for (q=0; q<total_cycle; q=q+1) begin

    #0.5 clk1 = 1'b0;  
    vmem_wr1 = 1;  if (q>0) vnmem_add1 = vnmem_add1 + 1; 
    
    mem_in1[2*bw-1:0*bw] = V[q][0];    //7:0
    mem_in1[4*bw-1:2*bw] = V[q][1];    //15:8
    mem_in1[6*bw-1:4*bw] = V[q][2];
    mem_in1[8*bw-1:6*bw] = V[q][3];
    mem_in1[10*bw-1:8*bw] = V[q][4];
    mem_in1[12*bw-1:10*bw] = V[q][5];
    mem_in1[14*bw-1:12*bw] = V[q][6];
    mem_in1[16*bw-1:14*bw] = V[q][7];  //2*4*8-1:
/*    mem_in[9*bw-1:8*bw] = Q[q][8];
    mem_in[10*bw-1:9*bw] = Q[q][9];
    mem_in[11*bw-1:10*bw] = Q[q][10];
    mem_in[12*bw-1:11*bw] = Q[q][11];
    mem_in[13*bw-1:12*bw] = Q[q][12];
    mem_in[14*bw-1:13*bw] = Q[q][13];
    mem_in[15*bw-1:14*bw] = Q[q][14];
    mem_in[16*bw-1:15*bw] = Q[q][15];
*/
    #0.5 clk1 = 1'b1;  

  end


  #0.5 clk1 = 1'b0;  
  vmem_wr1 = 0; 
  vnmem_add1 = 0;
  #0.5 clk1 = 1'b1;  
///////////////////////////////////////////





///// Nmem writing  /////

$display("##### Nmem writing #####");

  for (q=0; q<col; q=q+1) begin

    #0.5 clk1 = 1'b0;  
    nmem_wr1 = 1; if (q>0) vnmem_add1 = vnmem_add1 + 1; 
    
    mem_in1[2*bw-1:0*bw] = N[q][0];    //7:0
    mem_in1[4*bw-1:2*bw] = N[q][1];    //15:8
    mem_in1[6*bw-1:4*bw] = N[q][2];
    mem_in1[8*bw-1:6*bw] = N[q][3];
    mem_in1[10*bw-1:8*bw] = N[q][4];
    mem_in1[12*bw-1:10*bw] = N[q][5];
    mem_in1[14*bw-1:12*bw] = N[q][6];
    mem_in1[16*bw-1:14*bw] = N[q][7];  //2*4*8-1:
/*    mem_in[9*bw-1:8*bw] = K[q][8];
    mem_in[10*bw-1:9*bw] = K[q][9];
    mem_in[11*bw-1:10*bw] = K[q][10];
    mem_in[12*bw-1:11*bw] = K[q][11];
    mem_in[13*bw-1:12*bw] = K[q][12];
    mem_in[14*bw-1:13*bw] = K[q][13];
    mem_in[15*bw-1:14*bw] = K[q][14];
    mem_in[16*bw-1:15*bw] = K[q][15];
*/
    #0.5 clk1 = 1'b1;  

  end

  #0.5 clk1 = 1'b0;  
  nmem_wr1 = 0;  
  vnmem_add1 = 0;
  #0.5 clk1 = 1'b1;  
///////////////////////////////////////////



  for (q=0; q<2; q=q+1) begin
    #0.5 clk1 = 1'b0;  
    #0.5 clk1 = 1'b1;   
  end




/////  N data loading  /////
$display("##### N data loading to processor #####");

  for (q=0; q<col+1; q=q+1) begin
    #0.5 clk1 = 1'b0;  
    load1 = 1; 
    if (q==1) nmem_rd1 = 1;
    if (q>1) begin
       vnmem_add1 = vnmem_add1 + 1;
    end

    #0.5 clk1 = 1'b1;  
  end

  #0.5 clk1 = 1'b0;  
  nmem_rd1 = 0; vnmem_add1 = 0;
  #0.5 clk1 = 1'b1;  

  #0.5 clk1 = 1'b0;  
  load = 0; 
  #0.5 clk1 = 1'b1;  

///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk1 = 1'b0;   
    #0.5 clk1 = 1'b1;   
 end





///// execution  /////
$display("##### execute #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk1 = 1'b0;  
    execute1 = 1; 
    vmem_rd1 = 1;

    if (q>0) begin
       vnmem_add1 = vnmem_add1 + 1;
    end

    #0.5 clk1 = 1'b1;  
  end

  #0.5 clk1 = 1'b0;  
  vmem_rd1 = 0; vnmem_add1 = 0; execute1 = 0;
  #0.5 clk1 = 1'b1;  


///////////////////////////////////////////

 for (q=0; q<10; q=q+1) begin
    #0.5 clk1 = 1'b0;   
    #0.5 clk1 = 1'b1;   
 end




////////////// output fifo rd and wb to psum mem ///////////////////

$display("##### move ofifo to pmem #####");

  for (q=0; q<total_cycle; q=q+1) begin
    #0.5 clk1 = 1'b0;  
    ofifo_rd1 = 1; 
    pmem_wr1 = 1; 

    if (q>0) begin
       pmem_add1 = pmem_add1 + 1;
    end

    #0.5 clk1 = 1'b1;  
  end

  #0.5 clk1 = 1'b0;  
  pmem_wr1 = 0; pmem_add1 = 0; ofifo_rd1 = 0;
  #0.5 clk1 = 1'b1;  

///////////////////////////////////////////

/*
// pmem_out from sram, no recofiguration, norm,  get sum from another core, write to norm sram //

$display("##### move pmem_out from sram, no recon, norm, get sum from another core,write to norm sram  #####");

  pmem_rd1 = 1;
  #0.5 clk1 = 1'b0;
  #0.5 clk1 = 1'b1;

  #0.5 clk1 = 1'b0;
  pmem_add1 = pmem_add1 +1;
  #0.5 clk1 = 1'b1;
  #0.5 clk1 = 1'b0;
  for (q=0; q<total_cycle; q=q+1) begin
    pmem_add1 = pmem_add1 + 1;	  
    if (q>4) begin
       norm_wr1 = 1;
    end
    acc1 = 1; div1 = 1;
    #0.5 clk1 = 1'b1;
    #0.5 clk1 = 1'b0;
    if (q>5) begin
       norm_add1 = norm_add1 + 1;
    end
  end     
  #0.5 clk1 = 1'b1;
  #0.5 clk1 = 1'b0;
  pmem_rd1 = 0; pmem_add1 = 0; norm_add1 = norm_add1 + 1;
  #0.5 clk1 = 1'b1;
  #0.5 clk1 = 1'b0;
  acc1 =0; norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1;  
  #0.5 clk1 = 1'b0; 
  norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1; 
  #0.5 clk1 = 1'b0;
  norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1; 
  div = 0;
  #0.5 clk1 = 1'b0;
  norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1; 
  norm_wr1 = 0; norm_add1 =0;

///////////////////////////////////////////

*/
  //////////////////// 4bit 8col end////////////////////////////////////






  //////////////////// 8bit 4col start//////////////////////////////////

/////////////// Estimated result printing /////////////////


$display("##### Estimated 8bit multiplication result #####");


  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+1) begin
       result[t][q] = 0;
     end
  end

  for (t=0; t<total_cycle; t=t+1) begin
     for (q=0; q<col; q=q+2) begin
         for (k=0; k<pr; k=k+1) begin
            result[t][q] = result[t][q] + V[t][k] * N_8b[q][k];
//	    $display("%d",result[t][q]);
         end

         psum_result = result[t][q];
         cycle_result = {cycle_result[47:0], psum_result};
     end

//     $display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
     $display("prd @cycle%2d: %h", t, cycle_result); 

  end

//////////////////////////////////////////////




// pmem_out from sram, reconfiguration, norm, get sum from another core, write to norm sram//

$display("##### move pmem_out from sram, recon, norm, get sum from another core write to norm sram #####");
  col_c1 = 1;pmem_rd1 = 1;
  #0.5 clk1 = 1'b0;
  #0.5 clk1 = 1'b1;
  #0.5 clk1 = 1'b0;
  pmem_add1 = pmem_add1 +1;
  #0.5 clk1 = 1'b1;
  #0.5 clk1 = 1'b0;
  for (q=0; q<total_cycle; q=q+1) begin
    pmem_add1 = pmem_add1 + 1;	  
    if (q>4) begin
       norm_wr1 = 1;
    end
    acc1 = 1; div1 = 1;
    #0.5 clk1 = 1'b1;
    #0.5 clk1 = 1'b0;
    if (q>5) begin
       norm_add1 = norm_add1 + 1;
    end
  end     
  #0.5 clk1 = 1'b1;
  #0.5 clk1 = 1'b0;
  pmem_rd1 = 0; pmem_add1 = 0; norm_add1 = norm_add1 + 1;
  #0.5 clk1 = 1'b1;
  #0.5 clk1 = 1'b0;
  acc1 =0; norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1;  
  col_c1 =0;
  #0.5 clk1 = 1'b0; 
  norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1; 
  #0.5 clk1 = 1'b0;
  norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1; 
  div1 = 0;
  #0.5 clk1 = 1'b0;
  norm_add1 =norm_add1 + 1;
  #0.5 clk1 = 1'b1; 
  norm_wr1 = 0; norm_add1 =0;




  #10 $finish;


end

