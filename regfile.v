// This component correlates to the register file that outputs data 
// to the ALU, and stores data in registers for fast access.

module regFile (
    write_address,
    write_data,
    write_enable,
    read_address1,
    read_address2,
    read_data1,
    read_data2,
    clk
);

`include "parameters.v"

input clk;
input [REGFILE_ADDR_BITS-1:0] write_address; // Which address to write the data to.
input [DATA_BUS_WIDTH-1:0] write_data; // What data is being written at the write address
input write_enable; // Enables overwriting a register
input [REGFILE_ADDR_BITS-1:0] read_address1; // Address of the data1
input [REGFILE_ADDR_BITS-1:0] read_address2; // Address of the data2
output [DATA_BUS_WIDTH-1:0] read_data1; // The data being read out of the register (address1)
output [DATA_BUS_WIDTH-1:0] read_data2; // The data being read out of the register (address2)

reg [WIDTH_REGISTER_FILE-1:0] regFile [NUM_REGISTERS-1:0];
// Create a register file that is an array of how many registers there are, and each register contains data equals
// the width of the register file. 

// Behavior that writes to the register file (if write_enable is on) using the write data and write address. Happens on the negative edge of the clock.
always @ (negedge clk)
begin
    if (write_enable)
        regFile[write_address] <= write_data;
end

// asynchronous zero register. (if address is 0, then the registers contents will be 0 regardless of what is written into it)
assign read_data1 = (read_address1 ? regFile[read_address1] : 24'b0);
assign read_data2 = (read_address2 ? regFile[read_address2] : 24'b0);

endmodule