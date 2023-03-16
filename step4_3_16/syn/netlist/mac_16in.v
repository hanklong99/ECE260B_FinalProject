// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_16in (clk, reset, out, a, b, unsign);

parameter bw = 4;
parameter bw_psum = 2*bw+4;
parameter pr = 8; // parallel factor: number of inputs = 8

output [bw_psum-1:0] out;
input  clk;
input  reset;
input  [pr*bw*2-1:0] a;
input  [pr*bw*2-1:0] b;
input unsign;


wire		[2*bw-1:0]	product0_4by4	;
wire		[2*bw-1:0]	product1_4by4	;
wire		[2*bw-1:0]	product2_4by4	;
wire		[2*bw-1:0]	product3_4by4	;
wire		[2*bw-1:0]	product4_4by4	;
wire		[2*bw-1:0]	product5_4by4	;
wire		[2*bw-1:0]	product6_4by4	;
wire		[2*bw-1:0]	product7_4by4	;
reg		[2*bw-1:0]	product0_4by4_reg	;
reg		[2*bw-1:0]	product1_4by4_reg	;
reg		[2*bw-1:0]	product2_4by4_reg	;
reg		[2*bw-1:0]	product3_4by4_reg	;
reg		[2*bw-1:0]	product4_4by4_reg	;
reg		[2*bw-1:0]	product5_4by4_reg	;
reg		[2*bw-1:0]	product6_4by4_reg	;
reg		[2*bw-1:0]	product7_4by4_reg	;


//v is a, n is b

genvar i;


assign	product0_4by4	=  unsign ? {a[bw*1-1:bw*0]}*{b[bw*1-1:bw*0]} :	{a[bw*	2	-1:bw*	0	]}	*	{b[bw*	2	-1:	bw*	0	]};
assign	product1_4by4	=  unsign ? {a[bw*3-1:bw*2]}*{b[bw*3-1:bw*2]} :	{a[bw*	4	-1:bw*	2	]}	*	{b[bw*	4	-1:	bw*	2	]};
assign	product2_4by4	=  unsign ? {a[bw*5-1:bw*4]}*{b[bw*5-1:bw*4]} :	{a[bw*	6	-1:bw*	4	]}	*	{b[bw*	6	-1:	bw*	4	]};
assign	product3_4by4	=  unsign ? {a[bw*7-1:bw*6]}*{b[bw*7-1:bw*6]} :	{a[bw*	8	-1:bw*	6	]}	*	{b[bw*	8	-1:	bw*	6	]};
assign	product4_4by4	=  unsign ? {a[bw*9-1:bw*8]}*{b[bw*9-1:bw*8]} :	{a[bw*  10	-1:bw*	8	]}	*	{b[bw*	10	-1:	bw*	8	]};
assign	product5_4by4	=  unsign ? {a[bw*11-1:bw*10]}*{b[bw*11-1:bw*10]} : {a[bw*  12	-1:bw*	10	]}	*	{b[bw*	12	-1:	bw*	10	]};
assign	product6_4by4	=  unsign ? {a[bw*13-1:bw*12]}*{b[bw*13-1:bw*12]} : {a[bw*  14	-1:bw*	12	]}	*	{b[bw*	14	-1:	bw*	12	]};
assign	product7_4by4	=  unsign ? {a[bw*15-1:bw*14]}*{b[bw*15-1:bw*14]} : {a[bw*  16	-1:bw*	14	]}	*	{b[bw*	16	-1:	bw*	14	]};
/*
assign	product8	=	{{(bw){a[bw*	9	-1]}},	a[bw*	9	-1:bw*	8	]}	*	{{(bw){b[bw*	9	-1]}},	b[bw*	9	-1:	bw*	8	]};
assign	product9	=	{{(bw){a[bw*	10	-1]}},	a[bw*	10	-1:bw*	9	]}	*	{{(bw){b[bw*	10	-1]}},	b[bw*	10	-1:	bw*	9	]};
assign	product10	=	{{(bw){a[bw*	11	-1]}},	a[bw*	11	-1:bw*	10	]}	*	{{(bw){b[bw*	11	-1]}},	b[bw*	11	-1:	bw*	10	]};
assign	product11	=	{{(bw){a[bw*	12	-1]}},	a[bw*	12	-1:bw*	11	]}	*	{{(bw){b[bw*	12	-1]}},	b[bw*	12	-1:	bw*	11	]};
assign	product12	=	{{(bw){a[bw*	13	-1]}},	a[bw*	13	-1:bw*	12	]}	*	{{(bw){b[bw*	13	-1]}},	b[bw*	13	-1:	bw*	12	]};
assign	product13	=	{{(bw){a[bw*	14	-1]}},	a[bw*	14	-1:bw*	13	]}	*	{{(bw){b[bw*	14	-1]}},	b[bw*	14	-1:	bw*	13	]};
assign	product14	=	{{(bw){a[bw*	15	-1]}},	a[bw*	15	-1:bw*	14	]}	*	{{(bw){b[bw*	15	-1]}},	b[bw*	15	-1:	bw*	14	]};
assign	product15	=	{{(bw){a[bw*	16	-1]}},	a[bw*	16	-1:bw*	15	]}	*	{{(bw){b[bw*	16	-1]}},	b[bw*	16	-1:	bw*	15	]};
*/

always@(posedge clk) begin
	if(reset)begin
		product0_4by4_reg <= 0;
		product1_4by4_reg <= 0;
		product2_4by4_reg <= 0;
		product3_4by4_reg <= 0;
		product4_4by4_reg <= 0;
		product5_4by4_reg <= 0;
		product6_4by4_reg <= 0;
		product7_4by4_reg <= 0;
        end
	else begin
		product0_4by4_reg <= product0_4by4;
		product1_4by4_reg <= product1_4by4;
		product2_4by4_reg <= product2_4by4;
		product3_4by4_reg <= product3_4by4;
		product4_4by4_reg <= product4_4by4;
		product5_4by4_reg <= product5_4by4;
		product6_4by4_reg <= product6_4by4;
		product7_4by4_reg <= product7_4by4;
	end
end


assign out =    unsign ? 
	        {product0_4by4_reg	}
	+	{product1_4by4_reg	}
	+	{product2_4by4_reg	}
	+	{product3_4by4_reg	}
	+	{product4_4by4_reg	}
	+	{product5_4by4_reg	}
	+	{product6_4by4_reg	}
	+	{product7_4by4_reg	}
	:
	        {{(4){product0_4by4_reg[2*bw-1]}},product0_4by4_reg	}
	+	{{(4){product1_4by4_reg[2*bw-1]}},product1_4by4_reg	}
	+	{{(4){product2_4by4_reg[2*bw-1]}},product2_4by4_reg	}
	+	{{(4){product3_4by4_reg[2*bw-1]}},product3_4by4_reg	}
	+	{{(4){product4_4by4_reg[2*bw-1]}},product4_4by4_reg	}
	+	{{(4){product5_4by4_reg[2*bw-1]}},product5_4by4_reg	}
	+	{{(4){product6_4by4_reg[2*bw-1]}},product6_4by4_reg	}
	+	{{(4){product7_4by4_reg[2*bw-1]}},product7_4by4_reg	};
/*	+	{{(4){product8[2*bw-1]}},product8	}
	+	{{(4){product9[2*bw-1]}},product9	}
	+	{{(4){product10[2*bw-1]}},product10	}
	+	{{(4){product11[2*bw-1]}},product11	}
	+	{{(4){product12[2*bw-1]}},product12	}
	+	{{(4){product13[2*bw-1]}},product13	}
	+	{{(4){product14[2*bw-1]}},product14	}
	+	{{(4){product15[2*bw-1]}},product15	};
*/


endmodule
