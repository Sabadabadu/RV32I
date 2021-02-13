`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2021 10:46:04 AM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
	input	[31:0]		x,
	input	[31:0]		y,
	input	[6:0]		funct7,
	input	[2:0]		funct3,
	input	[6:0]		opcode,

	output	[31:0]		out
	output	reg 		branch
    );

	/* VARIABLES */

	reg		[2:0]	inst_type;

	// Adder-subtractor
	wire			x_zero;	 // x on high, zero on low
	wire			sub_add; // subtraction on sub_add high, addition on low
	wire	[31:0]	final_x;
	wire	[31:0]	final_y;
	
	wire	[31:0]	adder_out;
	wire			adder_c;

	// Carry and overflow flags
	wire			c;
	wire			v;

	// Shifts
	reg		[31:0]	shift_out;

	// Logical
	wire	[31:0]	logical_out;

	// Comparison
	wire			comparison_signed; // signed on high, unsigned on low
	wire	[31:0]	comparison_out;

	wire			eq;
	wire			ne;
	wire			lt;
	wire			ge;

	/* DEFINITIONS */
	
	// funct3
	// Shifts
	parameter	SL	=	3'b001;
	parameter	SR	=	3'b101;

	// Comparison (branch)
	parameter	BEQ =	3'b000;
	parameter	BNE =	3'b001;
	parameter	BLT =	3'b100;
	parameter	BGE =	3'b101;
	parameter	BLTU =	3'b110;
	parameter	BGEU =	3'b111;

	// Comparison (slt)
	parameter	SLT =	3'b010;
	parameter	SLTU =	3'b011;
	
	parameter	SLTI =	3'b010;
	parameter	SLTIU =	3'b011;

	/* IMPLEMENTATION */

	// Adder-subtracter
	assign final_x = x_zero ? x : 32'h00000000;
	assign final_y = sub_add ? ~y : y;

	Adder_IP adder(
		.A(final_x),
		.B(final_y),
		.C_IN(sub_add),
		.C_OUT(adder_c),
		.S(adder_out)
	);

	assign c = adder_c ^ sub_add;
	assign v = (~x[31] & ~final_y[31] & adder_out[31]) | 
		(x[31] & final_y[31] & ~adder_out[31]);

	// Shifts
	always @(*) begin
		case(funct3)
			SL: begin
				shift_out = x << y[4:0];
			end
			SR: begin
				shift_out = funct7[5] ? (x >>> y[4:0]) : (x >> y[4:0]);
			end
		endcase
	end

	// Logical
	always @(*) begin
		case(// TODO)
			AND: begin
				logical_out = x & y;
			end
			OR: begin
				logical_out = x | y;
			end
			XOR: begin
				logical_out = x ^ y;
			end
		endcase
	end

	// Comparison (these are correct when adder_out = final_x - final_y)
	assign eq = (adder_out == 32'h00000000);
	assign ne = ~eq;

	assign lt = comparison_signed ? adder_out[31] ^ v : ~c;
	assign ge = ~lt;

	assign comparison_out = {31{1'b0}, lt};

	// Determine comparison_signed and branch
	always @(*) begin
		case(opcode[6:2])
			JAL: begin
				branch = 1;
				comparison_signed = x;
			end
			JALR: begin
				branch = 1;
				comparison_signed = x;
			end
			BRANCH: begin
				case(funct3)
					BEQ: begin
						branch = eq;
						comparison_signed = x;
					end
					BNE: begin
						branch = ne;
						comparison_signed = x;
					end
					BLT: begin
						branch = lt;
						comparison_signed = 1;
					end
					BGE: begin
						branch = ge;
						comparison_signed = 1;
					end
					BLTU: begin
						branch = lt;
						comparison_signed = 0;
					end
					BGEU: begin
						branch = ge;
						comparison_signed = 0;
					end
					default: begin
						branch = x;
						comparison_signed = x;
					end
				endcase
			end
			OP_IMM: begin
				case(funct3)
					SLTI: begin
						branch = x;
						comparison_signed = 1;
					end
					SLTIU: begin
						branch = x;
						comparison_signed = 0;
					end
					default: begin
						branch = x;
						comparison_signed = x;
					end
				endcase
			end
			OP: begin
				case(funct3)
					SLT: begin
						branch = x;
						comparison_signed = 1;
					end
					SLTU: begin
						branch = x;
						comparison_signed = 0;
					end
					default: begin
						branch = x;
						comparison_signed = x;
					end
				endcase
			end
			default: begin
				branch = x;
				comparison_signed = x;
			end
		endcase
	end
	
	// Final out
	always @(*) begin
		case(//TODO)
			ADDER: begin
				out = adder_out;
			end
			SHIFT: begin
				out = // TODO;
			end
			LOGICAL: begin
				out = logical_out;
			end
			COMPARISON: begin
				out = // TODO;
			end
		endcase
	end

	always @(*) begin
		case(inst[6:2])
			LOAD: begin
				out = adder_out;
				sub_add = 0;
			end
			STORE: begin
				out = adder_out;
				sub_add = 0;
			end
			BRANCH: begin
				out = adder_out;
				sub_add = 1;
			end

			JALR: begin
				out = adder_out;
				sub_add = 0;
			end

			JAL: begin
				out = adder_out;
				sub_add = 0;
			end

			OP_IMM: begin
				case(// TODO)
					ADDI: begin
						out = adder_out;
						sub_add = 0;
					end
					SLTI: begin
						out = comparison_out;
					end
					SLTIU: begin
						out = comparison_out;
					end
					XORI: begin
						out = logical_out;
					end
					ORI: begin
						out = logical_out;
					end
					ANDI: begin
						out = logical_out;
					end
					SLI: begin
						out = shift_out;
					end
					SRI: begin
						out = shift_out;
					end
					default: begin

					end
				endcase
			end
			OP: begin
				case(// TODO)
					ADDI: begin
						out = adder_out;
						sub_add = 0;
					end
					SLTI: begin
						out = comparison_out;
					end
					SLTIU: begin
						out = comparison_out;
					end
					XORI: begin
						out = logical_out;
					end
					ORI: begin
						out = logical_out;
					end
					ANDI: begin
						out = logical_out;
					end
					SLI: begin
						out = shift_out;
					end
					SRI: begin
						out = shift_out;
					end
					default: begin

					end
				endcase
			end
		/*  SYSTEM: begin
				type_out = ADDER_SUBTRACTER;
			end */

			AUIPC: begin
				type_out = ADDER_SUBTRACTER;
			end
			LUI: begin
				type_out = ADDER_SUBTRACTER;
			end

			default:
				type_out = ADDER_SUBTRACTER;
		endcase
	end


endmodule

