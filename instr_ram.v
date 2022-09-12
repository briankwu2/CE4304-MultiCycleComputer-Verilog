`timescale 1ns / 1ps
// RAM that holds the instruction data
module instr_ram (
    clk,
    address,
    read_not_write,
	data
);

`include "parameters.v"

input clk;
input [ADDRESS_BUS_WIDTH-1:0] address;
input read_not_write;
output [INSTRUCTION_WIDTH-1:0] data;

reg [INSTRUCTION_WIDTH-1:0] ram_memory [NUM_INSTRUCTION_WORDS-1:0]; // each address now goes to a word through partioning
reg [INSTRUCTION_WIDTH-1:0] ram_private;
wire [ADDRESS_BUS_WIDTH-4:0] word_index; // there are 2048 bits, and therefore 512 words available in the instruction ram. 
// therefore 9 bits are needed to represent that many words, which is our 12 bits for address - 3 = 9 bits

initial 
begin

    // Project Programs   
	// Program 1:
	// C = A + B;
	//
	// Assembly Equivalent: (assuming A is 0x10 and B is at 0x20)
	// 1: lr R1, 0x10(R0)  (R1 = A)
	// EXPLAIN CODE: |LR Op| R1 | R0 |N/A |    0x10      |
	// MACHINE CODE: |00001|0001|0000|0000|0000 0001 0000|
	// HEXADECIMAL CODE: 0x1100010
	ram_memory[0] = 29'h1100010;
	

	// 2: lr R2, 0x20(R0)  (R2 = B)
	// EXPLAIN CODE:|LR OP| R2 | R0 |N/A |    0x20      |
	// MACHINE CODE:|00001|0010|0000|0000|0000 0010 0000|
	// HEXADECIMAL CODE:0x1200020
	ram_memory[1] = 29'h1200020;

	// 3: add R3, R1, R2   (R3 = C, C = A + B)
	// EXPLAIN CODE:|ADD OP| R3 | R1 | R2 |      N/A     |
	// MACHINE CODE: |00011|0011|0001|0010|0000 0000 0000|
	// HEXADECIMAL CODE:0x3312000
	ram_memory[2] = 29'h3312000;

	// 4: sr R0(0x30), R3 (store R3 into memory)
	// EXPLAIN CODE: |SR OP|N/A |R0  |R3  |     0x30     |
	// MACHINE CODE: |00010|0000|0000|0011|0000 0011 0000|
	// HEXADECIMAL CODE:0x2003030
	ram_memory[3] = 29'h2003030;

	// -----------------------------------------------------------------------------------------------------------
    // Program 2:
	// int sum = 0;
	// for(i = 0; i <= 10; i++) {
	//  sum += i;
	// }     

    // Assembly Equivalent:   

	// 1: mov R1, R0 (sum = 0)
	// EXPLAIN CODE: |MovOP| R1 | R0 |N/A |     N/A      |
	// MACHINE CODE: |00110|0001|0000|0000|0000 0000 0000|
	// HEXADECIMAL CODE: 0x6100000
	ram_memory[4] = 29'h6100000;

	// 2: mov R2, R0 (i = 0)
	// EXPLAIN CODE: |MovOp| R2 |R0  | N/A|      N/A     |
	// MACHINE CODE: |00110|0010|0000|0000|0000 0000 0000|
	// HEXADECIMAL CODE: 0x6200000
	ram_memory[5] = 29'h6200000;

	// 3: li R3, 0xA (R3 = 10)
	// EXPLAIN CODE: |LiOp | R3 |N/A |N/A |     0xA       |
	// MACHINE CODE: |01000|0011|0000|0000|0000 0000 01010|
	// HEXADECIMAL CODE: 0x830000A
	ram_memory[6] = 29'h830000A;

	// 4: incr R2 (i++)
	// EXPLAIN CODE: |i++Op| R2 | R2 |N/A |   N/A        |
	// MACHINE CODE: |00111|0010|0010|0000|0000 0000 0000|
	// HEXADECIMAL CODE: 0x7220000 
	ram_memory[7] = 29'h7220000;

	// 5: add R1, R2, R1 (sum += i) 
	// EXPLAIN CODE: |addOP| R1 | R2 | R1 |      N/A     |
	// MACHINE CODE: |00011|0001|0010|0001|0000 0000 0000|
	// HEXADECIMAL CODE: 0x3121000
	ram_memory[8] = 29'h3121000;

	// 6: bneq R2, R3, -3  (jumps to 8 if R2 = R3) (i == 10)
	// EXPLAIN CODE: |bneqOp|N/A | R2 | R3 |    -3(dec)   |
	// MACHINE CODE: |01001 |0000|0010|0011|1111 1111 1101|
	// HEXADECIMAL CODE: 0xA023FFD
	ram_memory[9] = 29'hA023FFD;

	// 7: sr 0x40(R0), R1 (stores sum at data address 0x40)
	// EXPLAIN CODE: |srOp |N/A | R0 | R1 | 0x40         |
	// MACHINE CODE: |00010|0000|0000|0001|0000 0100 0000|
	// HEXADECIMAL CODE: 0x2001040
	ram_memory[10] = 29'h2001040;

	// 8: nop
	// MACHINE CODE: |00000|0000|0000|0000|0000 0000 0000|
	// HEXADECIMAL CODE:0x0000000
	ram_memory[11] = 29'h0000000;


end

assign word_index = address[10:0] >> 2; // creates the word index from the address.

always @ (posedge clk) 
begin
    if (read_not_write)
        ram_private <= ram_memory[word_index]; // reads the instruction ram data (in words)
    else
        ram_memory[word_index] <= data; // writes the data into the instruction ram    
end

assign data = ram_private; // output the final data if read
    
endmodule