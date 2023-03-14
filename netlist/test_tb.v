         temp5b = result[t][q];
         temp16b = {temp16b[83:0], temp5b};   
	 temp5b_abs = abs(result[t][q]);  
	 temp16b_abs =  {temp16b_abs[83:0], temp5b_abs};

         temp5b1 = result1[t][q];
         temp16b1 = {temp16b1[83:0], temp5b1}; 
	 temp5b1_abs = abs(result1[t][q]);
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

//     $display("4bit estimate  @cycle%2d: %h", t, out_2core_est);
//
//     
reg [bw_psum+3:0] psum_result1;
reg [(bw_psum+4)*4-1:0] cycle_result1;

reg [bw_psum+3:0] psum_abs;
reg [(bw_psum+4)*4-1:0] cycle_abs;
reg [bw_psum+7:0]	sum_core0_8est;
reg [(bw_psum+4)*4-1:0]	out_core0_8est;

