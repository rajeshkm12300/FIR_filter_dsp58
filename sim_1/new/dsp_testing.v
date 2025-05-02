`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2025 12:39:21 PM
// Design Name: 
// Module Name: dsp_testing
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dsp_testing();
reg clk_i;//ce_i,rst_i;
reg fpopmode_bit_i;
reg [31:0] x_i;
reg [31:0] h_i;
wire [31:0] y_o;
reg ce_i=0;
reg [3:0] shift_reg=8;
DSP1 uut(
.clk_i(clk_i),//ce_i,rst_i;
. fpopmode_bit_i(fpopmode_bit_i),
. x_i(x_i),
. h_i(h_i),
. y_o(y_o)

);

initial begin 
clk_i<=0; 
fpopmode_bit_i<=1;
end
initial begin forever begin #50; clk_i<=~clk_i; end end
initial begin 
x_i<=32'b01000000101000000000000000000000; //5
h_i<=32'b01000000101000000000000000000000;//5
#250;
//x_i<=32'b01000010110010000000000000000000;
//h_i<=32'b01000010110010000000000000000000;
x_i<=32'b00111111100000000000000000000000; // 1
//h_i<=0;
#150;
h_i<=32'b01000000111000000000000000000000; //7

end

endmodule

