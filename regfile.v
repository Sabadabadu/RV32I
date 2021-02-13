module regfile(
	input clk,
	input [31:0] d,
	output [31:0] a,
	output [31:0] b,
	input [4:0] rd,
	input [4:0] ra,
	input [4:0] rb,
	input we_d
);
	reg [31:0] registers [31:0];

	assign a = registers[ra];
	assign b = registers[rb];

	always @(posedge clk) begin
		if (we_d) begin
			registers[rd] <= d;
		end
	end
endmodule
