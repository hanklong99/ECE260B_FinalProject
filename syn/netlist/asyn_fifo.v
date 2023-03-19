module asyn_fifo (wr_clk, rd_clk, reset, wr_en, wr_data, rd_en, rd_data, full, empty);

parameter col = 8;
parameter bw = 4;
parameter bw_psum = 2*bw+4;
parameter pr = 8;

input wr_clk, rd_clk, reset;
input wr_en, rd_en;
input [bw_psum-1:0] wr_data;
output [bw_psum-1:0] rd_data;
output full;
output empty;

parameter addr_w = $clog2(pr);

reg [addr_w : 0] wr_ptr, rd_ptr;
wire [addr_w : 0] g_wr_ptr, g_rd_ptr;
reg [addr_w : 0] wr_w2r_reg1, rd_r2w_reg1, wr_w2r_reg, rd_r2w_reg2;
wire [addr_w-1 : 0] wr_addr, rd_addr;
assign wr_addr = wr_ptr[addr_w-1: 0];
assign rd_addr = rd_ptr[addr_w-1: 0];

//write
always@(posedge wr_clk or posedge reset) begin
	if(reset) begin
		wr_ptr <= 0;
	end
	else if ( wr_en & !full) begin
		wr_ptr <= wr_ptr + 1;
	end
end
assign g_wr_ptr = (wr_ptr >> 1) ^ wr_ptr;
always@(posedge rd_clk or posedge reset) begin
	if(reset) begin
		wr_w2r_reg1 <= 0;
		wr_w2r_reg2 <= 0;
        end
	else begin
		wr_w2r_reg1 <= g_wr_ptr;
		wr_w2r_reg2 <= wr_w2r_reg1;
	end
end
assign empty = (g_rd_ptr == wr_w2r_reg2);

//read 
always@(posedge rd_clk or posedge reset) begin
	if(reset) begin
		rd_ptr <= 0;
	end
	else if(rd_en & !empty) begin
		rd_ptr <= rd_ptr + 1;
	end
end
assign g_rd_ptr = ( rd_ptr >> 1) ^ rd_ptr;
aways@(posedge wr_clk or posedge reset) begin
	if(reset) begin
		rd_r2w_reg1 <= 0;
		rd_r2w_reg2 <= 0;
	end
	else begin
		rd_r2w_reg1 <= g_rd_ptr;
		rd_r2w_reg2 ,= rd_r2w_reg1;
	end
end
assign full = (g_wr_ptr == {~rd_r2w_reg2[addr_w:addr_w-1], rd_r2w_reg2[addr_w-2 : 0]});

//dual port mem
reg [bw_psum-1:0] mem [0:pr-1];
reg [bw_psum-1:0] rd_data_reg;
integer i;
always@(posedge wr_clk or posedge reset) begin
	if (reset) begin
		for ( i=0; i < pr; i++)begin
			mem[i] <= 0;
		end
	end
	else if (wr_en & !full) begin
		mem[wr_addr] <= wr_data;
	end
end
always@(posedge rd_clk or posedge reset) begin
	if (reset) begin
		rd_data_reg <= 0;
	end
	else if (rd_en & !empty) begin
		rd_data_reg <= mem[rd_addr];
	end
end

assign rd_data = rd_data_reg;

endmodule



