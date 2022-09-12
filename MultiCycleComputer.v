
module MCC
(
    mainClock,
    reset,
    programOutput
);
`include "parameters.v"

// Define the ports
input mainClock;
input reset;
output [DATA_BUS_WIDTH-1:0] programOutput;

supply1 VDD; // a "1" source
supply0 zeroGND; // a "0" source
wire RAMClock; // delayed clock for data retrieval

// Define wires needed to connect all the components together. 
wire [DATA_BUS_WIDTH-1:0] EPCReg;
wire causeReg;
wire causeResult;

// memory wires
wire [ADDRESS_BUS_WIDTH-1:0] pcAddress;
wire [ADDRESS_BUS_WIDTH-1:0] nextPcAddress;
wire [DATA_BUS_WIDTH-1:0] memData;
wire [DATA_BUS_WIDTH-1:0] writeData;
wire [DATA_BUS_WIDTH-1:0] userData;
// instruction register wires
wire [INSTRUCTION_WIDTH-1:0] instruction;
wire [INSTRUCTION_WIDTH-1:0] instrRam_data;

// register wires

wire [REGFILE_ADDR_BITS-1:0] writeAddress; // destination register
wire [REGFILE_ADDR_BITS-1:0] readAddress1; // source register 1
wire [REGFILE_ADDR_BITS-1:0] readAddress2; // source register 2
wire [DATA_BUS_WIDTH-1:0] readData1;
wire [DATA_BUS_WIDTH-1:0] readData2;


// ALU wires
wire [DATA_BUS_WIDTH-1:0] aluInputA;
wire [DATA_BUS_WIDTH-1:0] aluInputB;
wire [DATA_BUS_WIDTH-1:0] ALUResult;
wire equal_zero; // for branch 
wire carryOut;
wire negative;

//registers to hold saved states
wire [DATA_BUS_WIDTH-1:0] regFile_A;
wire [DATA_BUS_WIDTH-1:0] regFile_B;
wire [DATA_BUS_WIDTH-1:0] aluRegResult;
wire [DATA_BUS_WIDTH-1:0] regFile_A_saved;
wire [DATA_BUS_WIDTH-1:0] regFile_B_saved;

// control wires
wire [WIDTH_OPCODE-1:0] opcode;
wire memRead;
wire memSelect;
wire regWrite;
wire IRWrite;
wire [ALU_OP_NUM_BITS-1:0] aluOp;
wire aluSrcA;
wire [1:0] aluSrcB;
wire [1:0] PCSource;
wire PCWrite;
wire memToReg;
wire EPCWrite;
wire IntCause;
wire CauseWrite;



// other wires
wire [IMMEDIATE_WIDTH-1:0] immediate;
wire [DATA_BUS_WIDTH-1:0] imm4;
wire [DATA_BUS_WIDTH-1:0] sign_extended;


wire [ADDRESS_BUS_WIDTH-1:0] resetAddress;
wire [ADDRESS_BUS_WIDTH-1:0] jumpAddress;

assign resetAddress = PROGRAM_LOAD_ADDRESS; // Program Load Address at 0x800 or 2048
assign jumpAddress = PROGRAM_LOAD_ADDRESS; // there is currently no "jump" instruction used
assign programOutput = memData;

// start the linking of components

// create an address register that holds the address of the program counter.
addr_reg program_counter (.clk(mainClock), .dataIn(nextPcAddress), .dataOut(pcAddress), .en(PCWrite));

assign #20 RAMClock = mainClock; // Sets a delay in the clock for accessing RAM


// harvard architecture implements separate rams for data and instruction
// each ram has a different width (instruction width and data bus width)
instr_ram instrMemory (.address(pcAddress), .clk(RAMClock), .data(instrRam_data), .read_not_write(VDD));
data_ram dataMemory(.address(aluRegResult[ADDRESS_BUS_WIDTH-1:0]), .read_data(memData), .clk(mainClock), .write_data(regFile_B_saved), .cs(memSelect), .read_not_write(memRead));


// instruction register to store the instruction
instr_reg instructionRegister (.clk(mainClock), .dataIn(instrRam_data), .dataOut(instruction), .en(IRWrite));

// data register to hold the contents of the dataram
data_reg dataRegister (.clk(RAMClock), .dataIn(memData), .dataOut(userData), .en(memSelect));

// seperates the instruction into its respective addresses.
instruction_decoder decoder(.instruction(instruction), .r_dst(writeAddress), .r_src(readAddress1),.r_tgt(readAddress2), .immed(immediate), .opcode(opcode));


// register file to hold and access data
regFile registerFile (.write_address(writeAddress), .write_data(writeData), .write_enable(regWrite), 
                        .read_address1(readAddress1), .read_address2(readAddress2), .read_data1(regFile_A),.read_data2(regFile_B),
                        .clk(mainClock) );


// holds the read data from the regfile
data_reg registerA (.clk(mainClock), .dataIn(regFile_A), .dataOut(regFile_A_saved), .en(VDD));
data_reg registerB (.clk(mainClock), .dataIn(regFile_B), .dataOut(regFile_B_saved), .en(VDD));

// selects which data to write back to the register file
data_mux2to1 regFileWriteBack (.data0(aluRegResult), .data1(userData), .sel(memToReg), .dataOut(writeData));

// sign extender and left shifter (by 2)
signExtender signExtend (.in(immediate), .out(sign_extended));
leftShift2 leftshift (.shiftIn(sign_extended), .shiftOut(imm4)); 

// MUX to select what data goes into the ALU input A
data_mux2to1 aluSrcA_Sel (.data0({12'b0, pcAddress}), .data1(regFile_A_saved), .sel(aluSrcA), .dataOut(aluInputA)); // picks between pcAddress + 12 empty bits, or register A


// mux to select ALU source B
data_mux4to1 aluSrcB_Sel (.data0(regFile_B_saved), .data1(24'h4), .data2(sign_extended), .data3(imm4), .sel(aluSrcB), .dataOut(aluInputB));


// ALU that performs all execution and processing in computer
ALU alu1 (.a(aluInputA), .b(aluInputB), .result(ALUResult), .ALU_OP(aluOp), .Z(equal_zero), .C(carryOut), .N(negative));

// holds the result of the ALU for use in data retrieval or addressing
data_reg ALUOut (.clk(mainClock), .dataIn(ALUResult), .dataOut(aluRegResult), .en(VDD)); // always enabled

// selects what address the PC will go to
addr_mux4to1 pcSource_sel (.data0(ALUResult[ADDRESS_BUS_WIDTH-1:0]), .data1(aluRegResult[ADDRESS_BUS_WIDTH-1:0]), .data2(), 
                            .data3(resetAddress), .sel(PCSource), .dataOut(nextPcAddress));


// the control unit that basically controls the whole computer (this was so hard to do)
controller controlPath (.clock(mainClock),.instruction(instruction), .reset(reset), .zero(equal_zero),
                         .memRead(memRead), .memSelect(memSelect), .regWrite(regWrite), .IRWrite(IRWrite),
                         .aluOp(aluOp), .aluSrcA(aluSrcA), .aluSrcB(aluSrcB), .PCSource(PCSource), .PCWrite(PCWrite),
                         .memToReg(memToReg), .EPCWrite(EPCWrite), .IntCause(IntCause), .CauseWrite(CauseWrite));

// exception registers, unsure how to implement correctly for now
cause_mux2to1 causeMux (.data0(zeroGND), .data1(VDD), .sel(IntCause), .dataOut(causeResult));
data_reg EPCregister (.clk(mainClock), .dataIn(aluRegResult), .dataOut(EPCReg), .en(EPCWrite));
causeReg causeRegister (.clk(mainClock), .dataIn(causeResult), .dataOut(causeResult), .en(CauseWrite));


endmodule