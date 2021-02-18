`timescale 1ns / 1ps

/* This module computes comparisons as required depending on the 
* instruction executed. As such, it only matters for branch and SLT 
* instructions. When one such instruction is being executed, the Adder 
* block is subtracting the two values being compared; this block exploits 
* the result and the flags generated to determine the result of the 
* comparison (which depends on which instruction is being executed).
*/

module Comp(
	input		[31:0]	adder_out,
	input				c,
	input				v,
	input		[2:0]	funct3,

	output reg     		comp,		// result of the comparison; matters 
									// only for branches and computing 
									// comp_out
	output     	[31:0]	comp_out	// comp, extended to 32 bits with 0
									// matters only for SLTs
    );


	/* VARIABLES */

	wire eq;
	wire ne;
	wire lt;
	wire ge;

	reg  signed_comp;	// high when the comparison is signed;
						// depends only on the instruction being executed


	/* DEFINITIONS */

	// funct3 (of branch and SLT instructions)
	parameter BEQ  = 3'b000;
	parameter BNE  = 3'b001;

	parameter SLT  = 3'b010;
	parameter SLTU = 3'b011;

	parameter BLT  = 3'b100;
	parameter BGE  = 3'b101;
	parameter BLTU = 3'b110;
	parameter BGEU = 3'b111;


	/* IMPLEMENTATION */

	assign eq = (adder_out == 0);
	assign ne = ~eq;
	assign lt = signed_comp ? (adder_out[31] ^ v) : c;
			// it's c and not ~c because for subtractions, from which 
			// all comparisons are computed, the Adder block already 
			// negates the carry flag
	assign ge = ~lt;

	// Determine signed_comp and choose a comparison signal for comp
	always @(*) begin
		case(funct3)
			BEQ:  begin
				signed_comp = 1'bx;
				comp = eq;
			end
			BNE:  begin
				signed_comp = 1'bx;
				comp = ne;
			end

			SLT:  begin
				signed_comp = 1'b1;
				comp = lt;
			end
			SLTU: begin
				signed_comp = 1'b0;
				comp = lt;
			end

			BLT:  begin
				signed_comp = 1'b1;
				comp = lt;
			end
			BGE:  begin
				signed_comp = 1'b1;
				comp = ge;
			end
			BLTU: begin
				signed_comp = 1'b0;
				comp = lt;
			end
			BGEU: begin
				signed_comp = 1'b0;
				comp = ge;
			end
			// Should never happen
			default: begin
				signed_comp = 1'bx;
				comp = 1'bx;
			end
		endcase
	end

	assign comp_out = {31'h00000000, comp};

endmodule

