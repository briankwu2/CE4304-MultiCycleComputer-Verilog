`timescale 1ns / 1ps
module addr_reg (
    clk,
    dataIn,
    dataOut,
    en
);

`include "parameters.v"

input clk;
input en;
input [ADDRESS_BUS_WIDTH-1:0] dataIn ;
output reg [ADDRESS_BUS_WIDTH-1:0] dataOut;

always @ (posedge clk) // On the positive trigger of the clock, if enable is on, then read out the data from the register
begin
    if (en)
    dataOut <= dataIn;
end

endmodule

module data_reg  (
    clk,
    dataIn,
    dataOut,
    en
);
`include "parameters.v"

input clk;
input en;
input [DATA_BUS_WIDTH-1:0] dataIn ;
output reg [DATA_BUS_WIDTH-1:0] dataOut;

always @ (posedge clk) // On the positive trigger of the clock, if enable is on, then read out the data from the register
begin
    if (en)
    dataOut <= dataIn;
end

endmodule

module instr_reg  (
    clk,
    dataIn,
    dataOut,
    en
);

`include "parameters.v"
input clk;
input en;
input [INSTRUCTION_WIDTH-1:0] dataIn;
output reg [INSTRUCTION_WIDTH-1:0] dataOut;

always @ (posedge clk) // On the positive trigger of the clock, if enable is on, then read out the data from the register
begin
    if (en)
    dataOut <= dataIn;
end
    
endmodule

module causeReg  (
    clk,
    dataIn,
    dataOut,
    en
);
`include "parameters.v"
input clk;
input en;
input dataIn;
output reg dataOut;

always @ (posedge clk) // On the positive trigger of the clock, if enable is on, then read out the data from the register
begin
    if (en)
    dataOut <= dataIn;
end
    
endmodule

