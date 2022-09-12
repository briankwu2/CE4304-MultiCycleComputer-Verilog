// Author: Brian Wu
// Date Created: 4/9/21
// Decoder verilog file used to create the base for phase 1 of the ISA. 
// Chooses three operand code      
// Registers are named R# where # spans from {0..NUM_REGISTERS -1} (0-15 registers)
// R0 is a special register that only stores 0.

module instruction_decoder (
	instruction,  
	r_dst, 
	r_src,
	r_tgt,
	immed,
	opcode);
	`include "parameters.v"
	
	input [INSTRUCTION_WIDTH-1:0] instruction;
	output [REGFILE_ADDR_BITS-1:0] r_dst;
	output [REGFILE_ADDR_BITS-1:0] r_src;
	output [REGFILE_ADDR_BITS-1:0] r_tgt;
	output [IMMEDIATE_WIDTH-1:0] immed;
	output [WIDTH_OPCODE-1:0] opcode;
	   
	parameter OPCODE_LSB = INSTRUCTION_WIDTH - WIDTH_OPCODE; // 29 - 5 = 24
	parameter REG_DEST_LSB = OPCODE_LSB - REGFILE_ADDR_BITS; // 24 - 4 = 20 
	parameter REG_SRC_LSB = REG_DEST_LSB - REGFILE_ADDR_BITS; // 20 - 4 = 16
	parameter REG_TGT_LSB = REG_SRC_LSB - REGFILE_ADDR_BITS; // 16 - 4 = 12
	
	// Assign the instructions
	                                     
	assign opcode = instruction[INSTRUCTION_WIDTH-1:OPCODE_LSB]; // [28:24] 5 bits
	assign r_dst = instruction[OPCODE_LSB-1:REG_DEST_LSB]; // [23:20] 4 bits
	assign r_src = instruction[REG_DEST_LSB-1:REG_SRC_LSB]; // [19:16] 4 bits
	assign r_tgt = instruction[REG_SRC_LSB-1:REG_TGT_LSB]; // [15:12] 4 bits
	assign immed = instruction[REG_TGT_LSB-1:0]; // [11:0] 12 bits
	
	                                              
	                                          
	// Instructions
	//-------------------------------------------------------------------  
	// Instruction 0: NOP (No-Operation Command)  
	// ASSEMBLY LANGUAGE: mov R0, R0 where R0 is a register than is always assigned 0. 
	// Operation: R0 = R0;
	// |  opcode  |	r_dst	| r_src	 | unused  |  
	// |    5     |   4     |   4    |   16    |      
	
	// Instruction 1: Load Register
	// ASSEMBLY LANGUAGE: lr Rt, offset(Rs) ; loads register Rd with memory location of offset(Rs)
	// Operation: (Rd) = M(offset + (Rs))
	// |  opcode  | r_dst   | r_src	 | unused | immediate |      
	// |    5     |   4     |   4    |   4    |     12    | 
	
	// Instruction 2: Store Register
	// ASSEMBLY LANGUAGE: sr offset(Rs), Rt ; stores the contents of source register into memory location of offset(Rd)	   
	// Operation: M(offset + (Rs)) = Rt;  
	// |  opcode  | unused  | r_src	| r_tgt   | immediate |      
	// |    5     |   4     |   4    |   4    |     12    | 
	
	// Instruction 3: Add Registers
	// ASSEMBLY LANGUAGE: add Rd, Rs, Rt; store contents of Rs + Rt into Rd (Rd = Rs + Rt)       
	// Operation: Rd = Rs + Rt;
	// |  opcode  |	r_dst	| r_src	 | r_tgt  | unused    |      
	// |    5     |   4     |   4    |   4    |     12    |
	
	// Instruction 4: Add immediate
	// ASSEMBLY LANGUAGE: addi Rd, immed ; Adds immed into Rd   
	// Operation: Rd = Rd + immed
	// |  opcode  |	r_dst	| r_dst  |unused  | immediate |      
	// |    5     |   4     |   4    |   4    |     12    |
	
	// Instruction 5: Subtract registers
	// ASSEMBLY LANGUAGE: sub Rd, Rs, Rt ; subtracts register Rt from Rs
	// Operation: Rd = Rs - Rt;
	// |  opcode  |	r_dst	| r_src  | r_tgt  | immediate |      
	// |    5     |   4     |   4    |   4    |     12    |    
	
	// Instruction 6: Move register
	// ASSEMBLY LANGUAGE: mov Rd, Rs; moves contents of Rs into Rd 
	// Operation: Rd = Rs;
	// |  opcode  |	r_dst	| r_src	 | unused |      
	// |    5     |   4     |   4    |   16   |    
	
	// Instruction 7: Increment Register
	// ASSEMBLY LANGUAGE: incr Rd; increments register Rd by 1
	// Operation: Rd++; (or Rd = Rd + 1;) There is ALUOp that is INCR.
	// |  opcode  |	r_dst	|  r_dst  |   unused  | immediate |      
	// |    5     |   4     |    4    |     4     |   12      |
	
	// Instruction 8: Load Immediate
	// ASSEMBLY LANGUAGE: li Rd, immed; loads immediate into Rd
	// Operation: Rd = immed;     
	// |  opcode  |	r_dst	| unused | immediate |      
	// |    5     |   4     |    8   |     12    | 
	
	// Instruction 9: Branch Equal
	// ASSEMBLY LANGUAGE: beq Rs, Rt, immed; if Rs == Rt, then branch to PC+4+immed
	// |  opcode  |	unused	| r_src	 | r_tgt  | immediate |      
	// |    5     |   4     |   4    |   4    |     12    | 
	
	// Instruction 10: Branch Not Equal
	// ASSEMBLY LANGUAGE: bneq Rd, Rs, immed; if Rd != Rs, then branch to PC+4+immed
	// |  opcode  |	unused	| r_src	 | r_tgt  | immediate |      
	// |    5     |   4     |   4    |   4    |     12    |           
	
	// Instruction 11: Branch unconditional 
    // ASSEMBLY LANGUAGE: buc immed; jumps to PC+4+immed
	// | op code  | 				immed				  |
	// |    5     |					24 bits				  |
	
	// Instruction 12: AND operation
	// ASSEMBLY LANGUAGE: and Rd, Rs, Rt; store the result of Rs AND Rt into register Rd
	// Operation: Rd = Rs && Rt;
	// |  opcode  |	r_dst	| r_src	 | r_tgt  |  unused   |      
	// |    5     |   4     |   4    |   4    |     12    |
	
	// Instruction 13: OR operation
	// ASSEMBLY LANGUAGE: or Rd, Rs, Rt; store the results of Rs OR Rt into register Rd
	// Operation: Rd = Rs || Rt;
	// |  opcode  |	r_dst	| r_src	 | r_tgt  |  unused   |      
	// |    5     |   4     |   4    |   4    |     12    |   
	
	// Instruction 14: NOT operation (invert)
	// ASSEMBLY LANGUAGE: not Rd, Rs; invert the contents of register Rs and store into Rd   
	// Operation: Rd = !(Rs)
	// |  opcode  |	r_dst	| r_src	 |   unused |      
	// |    5     |   4     |   4    |     16   |
	
	// Instruction 15: XOR operation
	// ASSEMBLY LANGUAGE: xor Rd, Rs, Rt; Rd = Rs XOR Rt
	// |  opcode  |	r_dst	| r_src	 | r_tgt  |  unused   |      
	// |    5     |   4     |   4    |   4    |     12    |

	// Instruction 16: Shift Left
	// ASSEMBLY LANGUAGE: shifl Rd, Rs, immed; shift Rd left by immed bits
	// |  opcode  |	r_dst	| r_src	 | unused |  immed    |      
	// |    5     |   4     |   4    |   4    |     12    |  
	
	// Instruction 17: Shift Right
	// ASSEMBLY LANGUAGE: shifr Rd, Rs, immed; shift Rd right by immed bits
	// |  opcode  |	r_dst	| r_src	 | unused |  immed    |      
	// |    5     |   4     |   4    |   4    |     12    |
	
	
	
    // Project Programs   
	// Program 1:
	// C = A + B;
	//
	// Assembly Equivalent: (assuming A is 0x10 and B is at 0x20)
	// 1: lr R1, 0x10(R0)  (R1 = A)
	// EXPLAIN CODE: |LR Op| R1 | R0 |N/A |    0x10      |
	// MACHINE CODE: |00001|0001|0000|0000|0000 0001 0000|
	// HEXADECIMAL CODE: 0x1100010
	
	// 2: lr R2, 0x20(R0)  (R2 = B)
	// EXPLAIN CODE:|LR OP| R2 | R0 |N/A |    0x20      |
	// MACHINE CODE:|00001|0010|0000|0000|0000 0010 0000|
	// HEXADECIMAL CODE:0x1200020

	// 3: add R3, R1, R2   (R3 = C, C = A + B)
	// EXPLAIN CODE:|ADD OP| R3 | R1 | R2 |      N/A     |
	// MACHINE CODE: |00011|0011|0001|0010|0000 0000 0000|
	// HEXADECIMAL CODE:0x3312000

	// 4: sr R0(0x30), R3 (store R3 into memory)
	// EXPLAIN CODE: |SR OP|N/A |R0  |R3  |     0x30     |
	// MACHINE CODE: |00010|0000|0000|0011|0000 0011 0000|
	// HEXADECIMAL CODE:0x2003030

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

	// 2: mov R2, R0 (i = 0)
	// EXPLAIN CODE: |MovOp| R2 |R0  | N/A|      N/A     |
	// MACHINE CODE: |00110|0010|0000|0000|0000 0000 0000|
	// HEXADECIMAL CODE: 0x6200000

	// 3: li R3, 0xA (R3 = 10)
	// EXPLAIN CODE: |LiOp | R3 |N/A |N/A |     0xA       |
	// MACHINE CODE: |01000|0011|0000|0000|0000 0000 01010|
	// HEXADECIMAL CODE: 0x830000A

	// 4: incr R2 (i++)
	// EXPLAIN CODE: |i++Op| R2 | R2 |N/A |   N/A        |
	// MACHINE CODE: |00111|0010|0010|0000|0000 0000 0000|
	// HEXADECIMAL CODE: 0x7220000 

	// 5: add R1, R2, R1 (sum += i) 
	// EXPLAIN CODE: |addOP| R1 | R2 | R1 |      N/A     |
	// MACHINE CODE: |00011|0001|0010|0001|0000 0000 0000|
	// HEXADECIMAL CODE: 0x3121000

	// 6: bneq R2, R3, -3  (jumps to 8 if R2 = R3) (i == 10)
	// EXPLAIN CODE: |bneqOp|N/A | R2 | R3 |    -3(dec)   |
	// MACHINE CODE: |01001 |0000|0010|0011|1111 1111 1101|
	// HEXADECIMAL CODE: 0xA023FFD

	// 7: sr 0x40(R0), R1 (stores sum at data address 0x40)
	// EXPLAIN CODE: |srOp |N/A | R0 | R1 | 0x40         |
	// MACHINE CODE: |00010|0000|0000|0001|0000 0100 0000|
	// HEXADECIMAL CODE: 0x2001040

	// 8: nop
	// MACHINE CODE: |00000|0000|0000|0000|0000 0000 0000|
	// HEXADECIMAL CODE:0x0000000
	
endmodule					                                                                            	