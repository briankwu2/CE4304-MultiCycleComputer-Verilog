module leftShift (
    shiftIn,
    shiftOut,
    amountShift
);
`include "parameters.v"
input [4:0] amountShift; // log2(DATA_BUS_WIDTH) = ceiling (log2(24)) = ceiling (4.58) = 5bits to represent amount that can be shifted
input [DATA_BUS_WIDTH-1:0] shiftIn;
output [DATA_BUS_WIDTH-1:0] shiftOut;

assign shiftOut = shiftIn << amountShift; // Shifts the input left "amountShift" of times.
    
endmodule

module rightShift (
    shiftIn,
    shiftOut,
    amountShift
);
`include "parameters.v"
input [4:0] amountShift; // log2(DATA_BUS_WIDTH) = ceiling (log2(24)) = ceiling (4.58) = 5bits to represent amount that can be shifted
input [DATA_BUS_WIDTH-1:0] shiftIn;
output [DATA_BUS_WIDTH-1:0] shiftOut;

assign shiftOut = shiftIn >> amountShift; // Shifts the input right "amountShift" of times.
    
endmodule

// Used for shifting exactly 2 for PC or data
module leftShift2 (
    shiftIn,
    shiftOut
);
`include "parameters.v"
input [DATA_BUS_WIDTH-1:0] shiftIn;
output [DATA_BUS_WIDTH-1:0] shiftOut;


assign shiftOut = shiftIn << 2; // Left shifts by 2.

endmodule




