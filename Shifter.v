`timescale 1ns / 1ps

module Shifter(
	input		[31:0]	x,
	input		[31:0]	y,
	input		[2:0]	funct3,
	input		[6:0]	funct7,		// to distinguish logical and 
									// arithmetic shifts

	output	reg	[31:0]	shifter_out
    );


	/* DEFINITIONS */

	// funct3 (of shift instructions)
	parameter SL = 3'b001;
	parameter SR = 3'b101;


	/* IMPLEMENTATION */

	always @(*) begin
		case(funct3)
			SL:	shifter_out = x << y[4:0];
			SR:	shifter_out = funct7[5] ? x >>> y[4:0] : x >> y[4:0];
			default: shifter_out = 32'hxxxxxxxx;
		endcase
	end

endmodule

