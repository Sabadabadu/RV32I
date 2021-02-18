`timescale 1ns / 1ps

module Decoder(
	input		[31:0]	inst,
	            
	output		[6:0]	funct7,
	output		[2:0]	funct3,
	output	reg	[31:0]	imm,
	output		[4:0]	rs2,
	output		[4:0]	rs1,
	output		[4:0]	rd,
	output		[6:0]	opcode
    );


	/* VARIABLES */

	reg		[2:0]	inst_type;


	/* DEFINITIONS */
	
	// Instruction types
	parameter	R_TYPE	=	3'h0;
	parameter	I_TYPE	=	3'h1;
	parameter	S_TYPE	=	3'h2;
	parameter	B_TYPE	=	3'h3;
	parameter	U_TYPE	=	3'h4;
	parameter	J_TYPE	=	3'h5;

	// opcodes (the 2 LSB don't matter, they are always 11)
	parameter	LOAD	=	5'b00000;
	parameter	STORE	=	5'b01000;
	parameter	BRANCH	=	5'b11000;
                              
	parameter	JALR	=	5'b11001;
                              
	parameter	JAL		=	5'b11011;
                              
	parameter	OP_IMM	=	5'b00100;
	parameter	OP		=	5'b01100;
//  parameter	SYSTEM	=	5'b11100;
                              
	parameter	AUIPC	=	5'b00101;
	parameter	LUI		=	5'b01101;


	/* IMPLEMENTATION */

	assign funct7 = inst[31:25];
	assign funct3 = inst[14:12];

	// Decide which instruction type is inst
	always @(*) begin
		case(inst[6:2])
			LOAD: begin
				inst_type = I_TYPE;
			end
			STORE: begin
				inst_type = S_TYPE;
			end
			BRANCH: begin
				inst_type = B_TYPE;
			end

			JALR: begin
				inst_type = I_TYPE;
			end

			JAL: begin
				inst_type = J_TYPE;
			end

			OP_IMM: begin
				inst_type = I_TYPE;
			end
			OP: begin
				inst_type = R_TYPE;
			end
		/*  SYSTEM: begin
				inst_type = ?_TYPE;
			end */

			AUIPC: begin
				inst_type = U_TYPE;
			end
			LUI: begin
				inst_type = U_TYPE;
			end

			default:
				inst_type = 3'bxxx;
		endcase
	end
	
	// Decide what the immediate is according to the intruction type
	// All immediates are sign extended to 32 bits
	always @(*) begin
		case(inst_type)
			R_TYPE: begin
				// R_TYPE has no immediate
				imm = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			end
			I_TYPE: begin
				imm = {{21{inst[31]}}, inst[30:25], inst[24:21], inst[20]};
			end	
			S_TYPE: begin
				imm = {{21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};
			end	
			B_TYPE: begin
				imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
			end	
			U_TYPE: begin
				imm = {inst[31], inst[30:20], inst[19:12], 12'b000000000000};
			end	
			J_TYPE: begin
				imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0};
			end	
			default: begin
				imm = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			end
		endcase
	end

	assign rs2 = inst[24:20];
	assign rs1 = inst[19:15];
	assign rd  = inst[11:7];

	assign opcode = inst[6:0];

endmodule
