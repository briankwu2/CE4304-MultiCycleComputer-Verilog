`timescale 1ns / 1ps
module addr_mux4to1 (
    data0,
    data1,
    data2,
    data3,
    sel,
    dataOut
);

`include "parameters.v"

input [ADDRESS_BUS_WIDTH-1:0] data0;
input [ADDRESS_BUS_WIDTH-1:0] data1;
input [ADDRESS_BUS_WIDTH-1:0] data2;
input [ADDRESS_BUS_WIDTH-1:0] data3;
input [1:0] sel;
output reg[ADDRESS_BUS_WIDTH-1:0] dataOut;

always @ (*)
begin
    case (sel) // MUX logic
    0: 
    dataOut <= data0;
    1:
    dataOut <= data1;
    2:
    dataOut <= data2;
    3:
    dataOut <= data3;
endcase
  
end

endmodule

module data_mux4to1 (
    data0,
    data1,
    data2,
    data3,
    sel,
    dataOut
);

`include "parameters.v"

input [DATA_BUS_WIDTH-1:0] data0;
input [DATA_BUS_WIDTH-1:0] data1;
input [DATA_BUS_WIDTH-1:0] data2;
input [DATA_BUS_WIDTH-1:0] data3;
input [1:0] sel;
output reg[DATA_BUS_WIDTH-1:0] dataOut;


always @ (*)
begin
    case (sel) // MUX logic
    0: 
    dataOut <= data0;
    1:
    dataOut <= data1;
    2:
    dataOut <= data2;
    3:
    dataOut <= data3;
endcase
 
end

endmodule
  
