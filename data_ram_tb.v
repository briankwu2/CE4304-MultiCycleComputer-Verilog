`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:17:03 05/15/2021
// Design Name:   data_ram
// Module Name:   /home/010/b/bk/bkw180001/Desktop/phase2impl/data_ram_tb.v
// Project Name:  phase2impl
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: data_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module data_ram_tb;

	// Inputs
	reg clk;
	reg [11:0] address;
	reg [23:0] write_data;
	reg read_not_write;
	reg cs;

	// Outputs
	wire [23:0] read_data;

	// Instantiate the Unit Under Test (UUT)
	data_ram uut (
		.clk(clk), 
		.address(address), 
		.write_data(write_data), 
		.read_data(read_data), 
		.read_not_write(read_not_write), 
		.cs(cs)
	);


	integer c;
	initial begin
		// Initialize Inputs
		clk = 0;
		address = 0;
		write_data = 0;
		read_not_write = 1;
		cs = 1;

		// Wait 100 ns for global reset to finish
		#10;
		// reads for A = 0x10
		for (c= 0; c <= 4; c = c + 1)
		begin
		clk <= c;
		address <= 12'h10;
		#5;
		end
		
		// reads for B = 0x20
		for (c= 0; c <= 4; c = c + 1)
		begin
		clk <= c;
		address <= 12'h20;
		#5;
		end
		
		
	end
      
endmodule

