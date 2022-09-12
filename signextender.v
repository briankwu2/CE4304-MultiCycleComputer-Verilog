`timescale 1ns / 1ps
module signExtender (
    in,
    out
);
    
`include "parameters.v"

input [IMMEDIATE_WIDTH-1:0] in;
output reg [DATA_BUS_WIDTH-1:0] out;

always @ (in)
begin
    out[IMMEDIATE_WIDTH-1:0] = in[IMMEDIATE_WIDTH-1:0];
    out[DATA_BUS_WIDTH-1: IMMEDIATE_WIDTH] = {12{in[IMMEDIATE_WIDTH-1]}};
end

endmodule