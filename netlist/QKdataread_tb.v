///// V Q data txt reading /////

$display("##### V Q data txt reading #####");


  vn_file = $fopen("vdata.txt", "r");
  vn_file1 = $fopen("qdata.txt", "r");

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
          $display("%d\n", V1[q][j]);
    end
  end
/////////////////////////////////




  for (q=0; q<2; q=q+1) begin
    #0.5 clk = 1'b0;   clk1 = 1'b1; 
    #0.5 clk = 1'b1;   clk1 = 1'b0; 
  end




///// N K data txt reading /////  N need to be divided in to 2 4bits binary number

$display("##### N data txt reading #####");

  for (q=0; q<10; q=q+1) begin
    #0.5 clk = 1'b0;   clk1 = 1'b1; 
    if(q==9) reset1 = 0;
    #0.5 clk = 1'b1;   clk1 = 1'b0; 
  end
  reset = 0;
  

  vn_file = $fopen("ndata.txt", "r");
  vn_file1 = $fopen("kdata.txt", "r");

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


$display("##### Estimated 4bit multiplication result #####");

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
	    //$display("%d",k);
         end

         temp5b = result[t][q];
         temp16b = {temp16b[83:0], temp5b};    

         temp5b1 = result1[t][q];
         temp16b1 = {temp16b1[83:0], temp5b1}; 
     end

//     $display("%d %d %d %d %d %d %d %d", result[t][0], result[t][1], result[t][2], result[t][3], result[t][4], result[t][5], result[t][6], result[t][7]);
//     $display("%d %d %d %d %d %d %d %d", temp16b[95:84], temp16b[83:72], temp16b[71:60], temp16b[59:48], temp16b[47:36], temp16b[35:24], temp16b[23:12], temp16b[11:0]);
//     $display("%h %h %h %h %h %h %h %h", temp16b[95:84], temp16b[83:72], temp16b[71:60], temp16b[59:48], temp16b[47:36], temp16b[35:24], temp16b[23:12], temp16b[11:0]);
     $display("prd @cycle%2d: %h", t, temp16b);    //%40h
     $display("prd @cycle%2d: %h", t, temp16b1);    //%40h

  end

