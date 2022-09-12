`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:54:04 05/15/2021
// Design Name:   signExtender
// Module Name:   /home/010/b/bk/bkw180001/Desktop/phase2impl/signExtender_tb.v
// Project Name:  phase2impl
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: signExtender
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module signExtender_tb;

	// Inputs
	reg [11:0] in;

	// Outputs
	wire [23:0] out;

	// Instantiate the Unit Under Test (UUT)
	signExtender uut (
		.in(in), 
		.out(out)
	);
	
	
	integer i;
	initial begin
		// Initialize Inputs
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		// 
		for (i = 0; i<= 1; i = i+ 1)
		begin
		in = 12'd15;
		#10;
		end
		
		for (i = 0; i<= 1; i = i+ 1)
		begin
		in = ~(12'd500) + 1;
		#10;
		end
		
		for (i = 0; i<= 1; i = i+ 1)
		begin
		in = 12'd0;
		#10;
		end
		
		// Add stimulus here
	end
 
 
endmodule

