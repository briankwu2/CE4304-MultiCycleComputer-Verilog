`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:07:20 05/15/2021
// Design Name:   instr_ram
// Module Name:   /home/010/b/bk/bkw180001/Desktop/phase2impl/instr_ram_tb.v
// Project Name:  phase2impl
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instr_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module instr_ram_tb;

	// Inputs
	reg clk;
	reg [11:0] address;
	reg read_not_write;

	// Outputs
	wire [28:0] data;

	// Instantiate the Unit Under Test (UUT)
	instr_ram uut (
		.clk(clk), 
		.address(address), 
		.read_not_write(read_not_write), 
		.data(data)
	);

	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		address = 0;
		read_not_write = 0;

		// Wait 100 ns for global reset to finish
		#100;
		read_not_write = 1;
		clk = 1;
		#5;
		
		
		for (i = 0; i <= 4; i = i + 1)
		begin
		address <= 12'd2048;
		clk <= i;
		read_not_write = 1;
		#5;
		end
		
		
 
		// Add stimulus here

	end
      
endmodule

