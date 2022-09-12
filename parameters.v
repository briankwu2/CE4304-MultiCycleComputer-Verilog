// Author: Brian Wu
// Date Created: 4/9/21
// Verilog file used for setting the parameters of the decoder.
// 
                 
// Given project parameters             
parameter ADDRESS_BUS_WIDTH = 12 ;
parameter NUM_ADDRESS = 4096 ;
parameter PROGRAM_LOAD_ADDRESS = 2048 ;
parameter DATA_BUS_WIDTH = 24 ;
parameter REGFILE_ADDR_BITS = 4 ;
parameter NUM_REGISTERS = 16 ;
parameter WIDTH_REGISTER_FILE = 24 ;
parameter INSTRUCTION_WIDTH = 29 ;
parameter IMMEDIATE_WIDTH = 12 ;
parameter NUM_INSTRUCTIONS = 32 ;       
parameter WIDTH_OPCODE = 5 ;    

// for instr_ram.v
parameter NUM_INSTRUCTION_ADDRESSES = NUM_ADDRESS >> 1; // half of the RAM memory is dedicated for instructions
parameter NUM_INSTRUCTION_WORDS = NUM_INSTRUCTION_ADDRESSES >> 2; 
// Since our INSTR word width is 29 bits, we need 4 bytes for each word, and therefore we have num_instructions address / 4. (partitioning)


// ALU_OP control signal parameters
parameter ALU_OP_NUM_BITS = 3;
parameter ALU_OP_ADD = 0;
parameter ALU_OP_SUB = 1;
parameter ALU_OP_AND = 2;
parameter ALU_OP_OR = 3;
parameter ALU_OP_XOR = 4;
parameter ALU_OP_NOT = 5;
parameter ALU_OP_INCR = 6;

// PC Mux select parameters
parameter PC_SELECT_ALU = 0;
parameter PC_SELECT_ALU_REG = 1;
parameter PC_SELECT_JUMP = 2;
parameter PC_SELECT_RESET = 3; // jumps to the original program counter address


// List of opcode instructions to decode  
parameter INSTR_NOP = 0;
parameter INSTR_LR = 1 ;
parameter INSTR_SR = 2 ;
parameter INSTR_ADD = 3 ;
parameter INSTR_ADDI = 4 ;  
parameter INSTR_SUBI = 5; 
parameter INSTR_MOV = 6 ;   
parameter INSTR_INCR = 7;
parameter INSTR_LI = 8;
parameter INSTR_BEQ = 9;  
parameter INSTR_BNEQ = 10;   
parameter INSTR_BUC = 11;
parameter INSTR_AND = 12;
parameter INSTR_OR = 13;
parameter INSTR_NOT = 14;
parameter INSTR_XOR = 15; 
parameter INSTR_SHIFL = 16;
parameter INSTR_SHIFR = 17;                           