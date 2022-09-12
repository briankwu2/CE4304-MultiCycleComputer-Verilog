module controller (
    instruction,
    clock,
    reset,
    zero,
    memRead,
    memSelect,
    regWrite,
    IRWrite,
    aluOp,
    aluSrcA,
    aluSrcB,
    PCSource,
    PCWrite,
    memToReg,
    EPCWrite,
    IntCause,
    CauseWrite
);

`include "parameters.v"


input [INSTRUCTION_WIDTH-1:0] instruction;
input clock; // clock
input reset; // reset input
input zero; // for branch logic
output reg memRead; // Allows memory to be read from the iram/dram
output reg regWrite; // Allows the register file to be written to
output reg [ALU_OP_NUM_BITS-1:0] aluOp; // decides what operation the alu will do 
output reg aluSrcA; // decides which source will the ALU use for input A
output reg [1:0] aluSrcB; // decides which source will the ALU use for input B
output reg [1:0] PCSource; // Decides where the program counter will go (will it go to the next instruction, jump to an instruction, etc.)
// output reg regDst; there is no regDst MUX cause our destination register is always at the same location
output reg memToReg; // decides what data is put into the destination register
output reg IRWrite; // enables or disables writing to the instruction register
output reg PCWrite; // decides if the program counter register can be overwritten
output reg memSelect; // selects either dataram or instruction ram to pull memory from
output reg EPCWrite; // enables writing to the EPC register
output reg IntCause; // picks between 0, and 1 for the int cause
output reg CauseWrite; // enables the cause register to be written


// STATE PARAMETERS
parameter STATE_RESET = 0; // the state when the reset button is enabled on the overall top level machine
parameter STATE_instructionFetch = 1; // the instruction fetch state, where the instruction word is fetched from instruction ram
parameter STATE_instructionDecode = 2; // the instruction decode state, where the instruction is decoded into its various parts (addresses and function)
parameter STATE_loadRegister = 3; // the state where the opcode is loading a register, and therefore dataRam must be accessed and stored into the register file
parameter STATE_storeRegister = 4; // the state where data from a register must be stored back into data ram
parameter STATE_executeOperation = 5; // the state where the ALU is tasked to perform an "R-type" operation, and write the result into the register file
parameter STATE_branch = 6; // the state where a branch is made, and the new calculated PC address is put into the PC register
parameter STATE_moveRegister = 7; // the state where register data is moved into another register
parameter STATE_addImmediate = 8; // the state where a register is added with an immediate. must choose a the immediate source for ALU B 
parameter STATE_readMemory = 9; // the state where memory is read (for load register INSTR)
parameter STATE_writeMemory = 10; // the state that writes memory into destination register
parameter STATE_storeMemory = 11; // the state to store memory into data RAM
parameter STATE_writeALU = 12; // uhhh write the direct ALU back into the register
parameter STATE_subImmediate = 13; // subtracts immediate
parameter STATE_shift = 14;
parameter STATE_jump_buc = 15;
parameter STATE_error = 31; // state of error (unknown opcode or other)

parameter NUM_STATE_BITS = 5; // ceiling of log2(32) = 5
wire [WIDTH_OPCODE-1:0] opcode;
assign opcode = instruction[INSTRUCTION_WIDTH-1: INSTRUCTION_WIDTH - WIDTH_OPCODE];
reg [NUM_STATE_BITS-1:0] current_state;
reg [NUM_STATE_BITS-1:0] next_state;

// update or reset the state
always @ (posedge clock)
begin
    if (reset)
        current_state <= STATE_RESET;
    else
        current_state <= next_state; 
end

// begin state logic ---------------------------------------------------------------
always @ (current_state or opcode or zero)
begin
    // default state, or reset state
    IRWrite <= 1'b0;
    regWrite <= 1'b0;
    aluSrcA <= 1'b0;
    aluSrcB <= 2'b0;
    aluOp <= 3'b0; // defaults on add
    PCSource <= PC_SELECT_RESET;
    memToReg <= 1'b0;
    memRead <= 1'b0;
    
    case (current_state)
        STATE_RESET:
        begin
            next_state <= STATE_instructionFetch;
            aluSrcA <= 1'b0; // default register sources
            aluSrcB <= 2'b0; // Default register sources
            aluOp <= ALU_OP_ADD; // (ADD) default ALU
            PCSource <= PC_SELECT_RESET;
            PCWrite <= 1'b1; // allows the PC to be written to (allows it to go to the next instruction)
            memRead <= 1'b0;
            memSelect <= 1'b0;
            memToReg <= 1'b0; // selects the aluout
        end

        STATE_instructionFetch:
        begin
            next_state <= STATE_instructionDecode; // sets next state as instruction decode
            regWrite <= 1'b0; // disable register writing
            aluSrcA <= 1'b0; // set the ALU src a to be the PC
            aluSrcB <= 1'b1; // set the ALU src B to be a 4 bytes (the next instruction)
            aluOp <= ALU_OP_ADD; // Sets the ALU to add the PC = PC + 4;
            PCSource <= 2'b0; // selects the ALUout result (to load the next address into the PC)
            PCWrite <= 1'b1; // enables the PC register be overwritten
            memRead <= 1'b1; // reads from memory into the instruction register
            memSelect <= 1'b0;
            IRWrite <= 1'b1; // writes the instruction register with the (PC) data
        end

        STATE_instructionDecode:
        begin
            PCWrite <= 1'b0; // keeps the PC
            IRWrite <= 1'b0;  // keeps the current IR data

            aluSrcA <= 1'b0; // uses PC 
            aluSrcB <= 2'b11; // prepares branch address
            aluOp <= ALU_OP_ADD; // does PC + offset of branch

            case (opcode) // determines which state to go to
            INSTR_NOP:
                next_state <= STATE_instructionFetch;
            INSTR_LR:
                next_state <= STATE_loadRegister;
            INSTR_SR:
                next_state <= STATE_storeRegister;
            INSTR_ADD:
                next_state <= STATE_executeOperation;
            INSTR_ADDI:
                next_state <= STATE_addImmediate;
            INSTR_SUBI:
                next_state <= STATE_subImmediate;
            INSTR_MOV:
                next_state <= STATE_moveRegister;
            INSTR_INCR:
                next_state <= STATE_executeOperation;
            INSTR_LI:
                next_state <= STATE_addImmediate;
            INSTR_BEQ:
                next_state <= STATE_branch;
            INSTR_BNEQ:
                next_state <= STATE_branch;
            INSTR_BUC:
                next_state <= STATE_jump_buc;
            INSTR_AND:
                next_state <= STATE_executeOperation;
            INSTR_OR:
                next_state <= STATE_executeOperation;
            INSTR_NOT:
                next_state <= STATE_executeOperation;
            INSTR_XOR:
                next_state <= STATE_executeOperation;
            INSTR_SHIFL:
                next_state <= STATE_shift;
            INSTR_SHIFR:
                next_state <= STATE_shift;
            default:
                next_state <= STATE_error;
            endcase
            
        end

        STATE_loadRegister: // this state is to calculate the address of where in memory we fetch the data
        begin
            next_state <= STATE_readMemory;
            memToReg <= 1'b0;
            aluSrcA <= 1'b1; // ALU Register Source A
            aluSrcB <= 2'b10; // ALU immediate source B
            aluOp <= ALU_OP_ADD; //
        end

        STATE_storeRegister:
        begin
            next_state <= STATE_storeMemory;
            aluSrcA <= 1'b1; // ALU Register Source A
            aluSrcB <= 2'b10; // ALU immediate source B
            aluOp <= ALU_OP_ADD;
        end

        STATE_readMemory: // access memory stage of the load instruction. fetches the data from memory
        begin // MDR = M[ALUOut] 
            next_state <= STATE_writeMemory;
            memRead <= 1'b1; // Read memory from the data ram
            memSelect <= 1'b1; // select the data from the ALUOut
        end

        STATE_writeMemory: // writes memory to the register (for load instructions)
        begin
            next_state <= STATE_instructionFetch; // resets to next instruction
            memSelect <= 1'b1; 
            regWrite <= 1'b1; // enables register writing
            memToReg <= 1'b1; // uses data from memory data register to input into the register file
        end

        STATE_storeMemory:
        begin
            next_state <= STATE_instructionFetch;
            memRead <= 1'b0; // allows writing
            memSelect <= 1'b1; // Allows data to be written back into the memory.
        end
        
        STATE_executeOperation: // Executes the operation
        begin
            next_state <= STATE_writeALU;
            aluSrcA <= 1'b1; // ALU sources from register
            aluSrcB <= 1'b0; // ALU sources from register
            case (opcode) // decides which operation to execute

            INSTR_NOP: 
                aluOp <= ALU_OP_ADD;
            INSTR_ADD:
                aluOp <= ALU_OP_ADD;
            INSTR_AND:
                aluOp <= ALU_OP_ADD;
            INSTR_OR:
                aluOp <= ALU_OP_OR;
            INSTR_NOT:
                aluOp <= ALU_OP_NOT;
            INSTR_XOR:
                aluOp <= ALU_OP_XOR;
            INSTR_INCR:
                aluOp <= ALU_OP_INCR;
            endcase

        end

        STATE_writeALU:
        begin
            next_state <= STATE_instructionFetch; // next instruction
            memToReg <= 1'b0;
            regWrite <= 1'b1; // writes the ALU result to the destination register
        end

        STATE_branch: 
		  begin
            next_state <= STATE_instructionFetch; // either branches to the instruction, or goes to the next PC + 4 instruction
            aluSrcA <= 1'b1;
            aluSrcB <= 2'b0;
            aluOp <= ALU_OP_SUB;
            case(opcode)
                INSTR_BEQ: // if the two registers are equal, then branch
                if (zero)
                begin
                    PCSource <= 2'b01; // uses ALU output source
                    PCWrite <= 1'b1;
                end
                else
                    PCWrite <= 1'b0;

                INSTR_BNEQ: // If A != B (output by the ALU), then don't branch
                if (zero) 
                    PCWrite <= 1'b0;
                else
                begin
                    PCSource <= 2'b01; // uses ALU output source
                    PCWrite <= 1'b1;
                end
            endcase
			end


        STATE_addImmediate:
        begin
            next_state <= STATE_writeALU;
            aluSrcA <= 1'b1; // uses the register source a
            aluSrcB <= 2'b10; // uses the immediate source
            aluOp <= ALU_OP_ADD; // adds the register source a and immediate
        end

        STATE_moveRegister:
        begin
            next_state <= STATE_writeALU;
            aluSrcA <= 1'b1;
            aluSrcB <= 2'b00;
            aluOp <= ALU_OP_ADD;
        end

        STATE_error: 
        begin
            next_state <= STATE_RESET;
            EPCWrite <= 1'b1;
            IntCause <= 1'b0;
            CauseWrite <= 1'b1;
        end
       
        STATE_jump_buc:
        begin
            next_state <= STATE_instructionFetch;
            PCSource <= 2'b10;
            PCWrite <= 1'b1;
        end

    endcase
end


endmodule
