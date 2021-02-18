`timescale 1ns / 1ps

module Logical(
	input		[31:0]	x,
	input		[31:0]	y,
	input		[2:0]	funct3,

	output	reg	[31:0]	logical_out
    );


	/* DEFINITIONS */

	// funct3 (of logical operation instructions)
	parameter XOR = 3'b100;
	parameter OR =	3'b110;
	parameter AND = 3'b111;


	/* IMPLEMENTATION */

	always @(*) begin
		case(funct3)
			XOR:	logical_out = x ^ y;
			OR:		logical_out = x | y;
			AND:	logical_out = x & y;
			default: logical_out = 32'hxxxxxxxx;
		endcase
	end

endmodule

