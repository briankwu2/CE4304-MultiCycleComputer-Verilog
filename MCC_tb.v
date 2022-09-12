`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:37:48 05/15/2021
// Design Name:   MCC
// Module Name:   /home/010/b/bk/bkw180001/Desktop/phase2impl/MCC_tb.v
// Project Name:  phase2impl
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MCC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MCC_tb;

	// Inputs
	reg mainClock;
	reg reset;
	wire[23:0] programOutput;

	// Instantiate the Unit Under Test (UUT)
	MCC uut (
		.mainClock(mainClock), 
		.reset(reset), 
		.programOutput(programOutput)
	);
	
	integer i;
	
	initial begin
		// Initialize Inputs
		mainClock = 0;
		reset = 0;
		
		#100;
		
		for (i = 0; i <= 3; i = i + 1)
		begin
		reset <= 1;
		mainClock <= i;
		#50;
		end
		
		
		for (i = 0; i <= 400; i = i + 1)
		begin
		reset <= 0;
		mainClock <= i;
		#50;
		end
		
		
		
		// Add stimulus here

	end
      
endmodule

