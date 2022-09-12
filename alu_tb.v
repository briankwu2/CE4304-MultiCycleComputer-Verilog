`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:26:38 05/15/2021
// Design Name:   ALU
// Module Name:   /home/010/b/bk/bkw180001/Desktop/phase2impl/alu_tb.v
// Project Name:  phase2impl
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_tb;

	// Inputs
	reg [23:0] a;
	reg [23:0] b;
	reg [2:0] ALU_OP;

	// Outputs
	wire [23:0] result;
	wire Z;
	wire C;
	wire N;
`include "parameters.v"
	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.a(a), 
		.b(b), 
		.result(result), 
		.ALU_OP(ALU_OP), 
		.Z(Z), 
		.C(C), 
		.N(N)
	);

	integer i;
	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;
		ALU_OP = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		// Tests adding
		for (i = 0; i <= 1; i = i + 1)
		begin
		ALU_OP = ALU_OP_ADD;
		a <= 24'd500;
		b <= 24'd500;
		#5;
		end
		
		// Tests subtraction (and the zero flag)
		for (i = 0; i <= 1; i = i + 1)
		begin
		ALU_OP = ALU_OP_SUB;
		a <= 24'd100;
		b <= 24'd100;
		#5;
		end
		
		// Test negative result
		for (i = 0; i <= 1; i = i + 1)
		begin
		ALU_OP = ALU_OP_SUB;
		a <= 24'd100;
		b <= 24'd400;
		#5;
		end
		
		// Add stimulus here

	end
      
endmodule

