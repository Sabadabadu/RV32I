`timescale 1ns / 1ps

module Regfile(
	input clk,
	input [31:0] d,
	output [31:0] a,
	output [31:0] b,
	input [4:0] rd,
	input [4:0] rs1,
	input [4:0] rs2,
	input we_d
);


	/* VARIABLES */

	reg [31:0] registers [31:0];


	/* IMPLEMENTATION */

	assign a = registers[rs1];
	assign b = registers[rs2];

	always @(posedge clk) begin
		if (we_d) begin
			registers[rd] <= d;
		end
	end

endmodule
