`timescale 1ns / 1ps
module ALU (
    a,
    b, 
    result, 
    ALU_OP,
    Z,
    C,
    N
);

`include "parameters.v"
parameter MSB = DATA_BUS_WIDTH-1;


input [DATA_BUS_WIDTH-1: 0] a; // input a with width of the data bus
input [DATA_BUS_WIDTH-1: 0] b; // input b with width of data bus
input [ALU_OP_NUM_BITS-1:0] ALU_OP; // Control signal for the ALU, in this implementation it has 3 bits. 
output [DATA_BUS_WIDTH-1:0] result; // result of ALU operation
output Z; // overflow flag
output N; // negative flag
output C; // carry out


reg [DATA_BUS_WIDTH:0] answer; // adds the MSB to handle for overflow (whichs then assigned to C)

always @ (*) // on any input change
begin
    case(ALU_OP) // lists all the operations for ALU
        ALU_OP_ADD:
            answer <= a + b;
        ALU_OP_SUB:
            answer <= a + ~(b) + 25'b1; // Subtraction uses A + (2's complement of B i.e. negative)
        ALU_OP_AND:
            answer <= a & b; // bitwise AND operation onto a and b
        ALU_OP_OR:
            answer <= a | b; // bitwise OR operation onto a and b
        ALU_OP_XOR:
            answer <= a ^ b; // bitwise XOR operation onto a and b
        ALU_OP_NOT: // bitwise inverter
            answer <= ~a;
        ALU_OP_INCR: // increments source register by 1!
            answer <= a + 1;

        default:
            answer <= 0;

    endcase
end

// assign outputs with the resulting operations

assign result = answer[MSB:0]; // assigns the result from a OPERATION b
assign Z = (answer ? 1'b0 : 1'b1); // determines zero flag
assign C = answer[DATA_BUS_WIDTH]; // determines if there is a carryout (overflow) or not
assign N = answer[MSB]; // determines if the result is negative or not

endmodule