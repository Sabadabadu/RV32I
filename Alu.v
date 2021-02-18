`timescale 1ns / 1ps

module Alu(
	input	[31:0]		x,
	input	[31:0]		y,
	input	[2:0]		funct3,
	input	[6:0]		funct7,
	input				m_0_x,
	input				m_sub_add,
	input	[1:0]		m_out,

	output	[31:0]		alu_out,
	output		 		comp
    );


	/* VARIABLES */

	// Adder
	wire	[31:0]	adder_out;
	wire			c;
	wire			v;

	// Comp
	wire	[31:0]	comp_out;

	// Logical
	wire	[31:0]	logical_out;

	// Shifter
	reg		[31:0]	shifter_out;


	/* DEFINITIONS */

	// m_out values
	parameter ADDER =	2'b00;
	parameter COMP =	2'b01;
	parameter LOGICAL = 2'b10;
	parameter SHIFTER = 2'b11;


	/* IMPLEMENTATION */

	// Adder
	Adder adder(
		.x(x),
		.y(y),
		.m_0_x(m_0_x),
		.m_sub_add(m_sub_add),

		.adder_out(adder_out),
		.c(c),
		.v(v)
	);
	
	// Comp
	Comp comp(
		.adder_out(adder_out),
		.c(c),
		.v(v),
		.funct3(funct3),

		.comp(comp),
		.comp_out(comp_out)
	);

	// Logical
	Logical logical(
		.x(x),
		.y(y),
		.funct3(funct3),

		.logical_out(logical_out)
	);

	// Shifter
	Shifter shifter(
		.x(x),
		.y(y),
		.funct3(funct3),
		.funct7(funct7),

		.shifter_out(shifter_out)
	);

	// alu_out
	always @(*) begin
		case(m_out)
			ADDER:		alu_out = adder_out;		
			COMP:		alu_out = comp_out;
			LOGICAL:	alu_out = logical_out;
			SHIFTER:	alu_out = shifter_out;
		endcase
	end

endmodule

