`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:23:59 05/16/2021
// Design Name:   instruction_decoder
// Module Name:   /home/010/b/bk/bkw180001/Desktop/phase2impl/decoder_tb.v
// Project Name:  phase2impl
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instruction_decoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module decoder_tb;

	// Inputs
	reg [28:0] instruction;

	// Outputs
	wire [3:0] r_dst;
	wire [3:0] r_src;
	wire [3:0] r_tgt;
	wire [11:0] immed;
	wire [4:0] opcode;

	// Instantiate the Unit Under Test (UUT)
	instruction_decoder uut (
		.instruction(instruction), 
		.r_dst(r_dst), 
		.r_src(r_src), 
		.r_tgt(r_tgt), 
		.immed(immed), 
		.opcode(opcode)
	);

	initial begin
		// Initialize Inputs
		instruction = 29'h1101432;

		// Wait 100 ns for global reset to finish
		#100;
		
		instruction = 29'h5554321;
		
		#100;
		
		instruction = 29'b11111111111111111111111111111;
        
		// Add stimulus here

	end
      
endmodule

