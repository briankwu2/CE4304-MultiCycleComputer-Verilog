`timescale 1ns / 1ps
module addr_mux2to1 (
    data0,
    data1,
    sel,
    dataOut
);

`include "parameters.v"

input [ADDRESS_BUS_WIDTH-1:0] data0;
input [ADDRESS_BUS_WIDTH-1:0] data1;
input sel;
output reg [ADDRESS_BUS_WIDTH-1:0] dataOut;

always @ (*)
begin
    case (sel) // MUX logic
        0: 
        dataOut = data0;

        1:
        dataOut = data1;
    endcase
end

    
endmodule

module data_mux2to1 (
    data0,
    data1,
    sel,
    dataOut
);

`include "parameters.v"

input [DATA_BUS_WIDTH-1:0] data0;
input [DATA_BUS_WIDTH-1:0] data1;
input sel;
output reg[DATA_BUS_WIDTH-1:0] dataOut;

always @ (*)
begin
    case (sel) // MUX logic
        0: 
        dataOut <= data0;

        1:
        dataOut <= data1;
    endcase
end
   
endmodule

module cause_mux2to1 (
    data0,
    data1,
    sel,
    dataOut
);

input data0;
input data1;
input sel;
output reg dataOut;

always @ (*)
begin
    case (sel) // MUX logic
        0: 
        dataOut <= data0;

        1:
        dataOut <= data1;
    endcase
end
   
endmodule