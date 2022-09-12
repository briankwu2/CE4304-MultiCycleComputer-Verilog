`timescale 1ns / 1ps
module data_ram (
    clk,
    address,
    write_data,
    read_data,
    read_not_write,
    cs
);

`include "parameters.v"

input [ADDRESS_BUS_WIDTH - 1:0] address;
input [DATA_BUS_WIDTH-1: 0] write_data;
output [DATA_BUS_WIDTH-1:0] read_data;
input read_not_write;
input cs;
input clk;

parameter NUM_DATA_ADDRESSES = NUM_ADDRESS / 2; // Half of the data is shared with the instruction RAM.

// Our data width is 24 bits, so 3 bytes per stored "word"
reg [7:0] ram_memory [NUM_DATA_ADDRESSES - 1:0]; // memory space in the RAM
reg [DATA_BUS_WIDTH - 1:0] ram_private; // the byte loaded found in RAM


initial begin
// A = 0x10, (A) = 20
ram_memory[16] = 8'h14;
ram_memory[17] = 8'h00;
ram_memory[18] = 8'h00;

// B = 0x20, (B) = 22
ram_memory[32] = 8'h16;
ram_memory[33] = 8'h00;
ram_memory[34] = 8'h00;



end

always @ (posedge clk) // Data collected on the positive edge of the clock.
begin
    if (cs)
        if (read_not_write) 
        begin // reads a 24 bit word from ram memory
            ram_private[7:0] <= ram_memory[address]; // Retrieves the first third of the data word
            ram_private[15:8] <= ram_memory[address+1]; // Retrieves the second third of the data word
            ram_private [23:16] <= ram_memory [address + 2]; // retrieves the last third of the data word
        end	  
        else
        begin // Writes a 16bit word into ram_memory
        ram_memory[address] <= write_data[7:0]; // Writes data to the ram_memory
        ram_memory[address+1] <= write_data[15:8]; // Writes the other portion of the data into ram_memory/
        ram_memory[address+2] <= write_data[23:16]; // Writes the last third into ram_memory
        end
    else
        ram_private <= 24'bz; // If chip select is 0, set the output to a 24 bit high impedance (not retrieving memory).
end
assign read_data = ram_private; // Output the data to read_data port.
  
endmodule