`timescale 1ns / 1ps

module tb_Decoder(

    );

	// Decoder inputs and outputs
	reg		[31:0]	inst;
        
    wire	[6:0]	funct7;
    wire	[2:0]	funct3;
    wire	[31:0]	imm;
    wire	[4:0]	rs2;
    wire	[4:0]	rs1;
    wire	[4:0]	rd;
    wire	[6:0]	opcode;

	// clock signal
	reg	sim_clk;

	// clock period
	parameter CLK_PERIOD = 10;
	
	// Module to test
	Decoder decoder(
		.inst(inst),
        .funct7(funct7),
        .funct3(funct3),
        .imm(imm),
        .rs2(rs2),
        .rs1(rs1),
        .rd(rd),
        .opcode(opcode)
	);          


	// generate clock
	initial sim_clk = 1'b0;

	always #(CLK_PERIOD/2) begin
		sim_clk = ~sim_clk;
	end
	
	initial begin
		@(posedge sim_clk);
		inst = 32'b111111111100_00011_010_00101_0000011; // lw x5, -4(x3)

		@(posedge sim_clk);
		inst = 32'b1111111_00101_00011_010_11100_0100011; // sw x5, -4(x3)

		@(posedge sim_clk);
		inst = 32'b1111111_00101_00011_100_11110_1100011; // blt x3, x5, -2050


		forever begin
			@(posedge sim_clk);
		end

	end

endmodule
