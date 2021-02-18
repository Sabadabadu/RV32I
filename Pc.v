`timescale 1ns / 1ps

module Pc(
	input				clk,
	input		[31:0]	alu_out,
	input				comp,
	input		[31:0]	imm,
	input				jump,
	input				branch,

	output	reg	[31:0]	pc,
	output		[31:0]	pc_next // carries pc+4 on jump instructions
    );


	/* VARIABLES */

	wire	[31:0]	pc_increment;


	/* IMPLEMENTATION */

	assign pc_increment = (branch & comp) ? imm : 32'h00000004;

	Adder_IP adder(
		.A(pc),
		.B(pc_increment),
		.C_IN(1'b0),
		// .C_OUT(// don't care),
		.S(pc_next)
	);

	always @(posedge clk) begin
		pc <= jump ? alu_out : pc_next;
	end

endmodule

