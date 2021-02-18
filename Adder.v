`timescale 1ns / 1ps

module Adder(
	input		[31:0]	x,
	input		[31:0]	y,
	input				m_0_x,		// on high operates with 0 instead of x
	input				m_sub_add,	// on high subtraction is performed

	output		[31:0]	adder_out,
	output				c,			// carry flag, indicates result of 
									// unsigned operation cannot be 
									// represented
	output				v			// overflow flag, analogous but for 
									// signed operations
    );


	/* VARIABLES */

	wire	[31:0]	adder_x;
	wire	[31:0]	adder_y;


	/* IMPLEMENTATION */

	assign	adder_x = m_0_x ? 32'h00000000 : x;
	assign	adder_y = y ^ {32{m_sub_add}};

	Adder_IP adder(
		.A(adder_x),
		.B(adder_y),
		.C_IN(m_sub_add),
		.C_OUT(adder_c),
		.S(adder_out)
	);

	assign c = adder_c ^ m_sub_add;
	assign v = (~adder_x[31] & ~adder_y[31] & adder_out[31]) | 
		(adder_x[31] & adder_y[31] & ~adder_out[31]);

endmodule

