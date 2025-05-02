`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2025 08:38:08 PM
// Design Name: 
// Module Name: FIR_TOP_tb
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


module FIR_TOP_tb();
parameter DATA_WIDTH=32;
parameter H_ADDR_WIDTH=4;
parameter X_ADDR_WIDTH=6;
reg clk,rst_n;
wire R_en;
wire [H_ADDR_WIDTH-1:0] h_addr;
wire [X_ADDR_WIDTH-1:0] x_addr;
wire filter_delay,dsp58_delay;
wire [DATA_WIDTH-1:0] y_o,x_i,h_i;
wire invalid_o,overflow_o,underflow_o;
reg fpopmode_bit_i;

FIR_TOP #()uut(
.clk(clk),
.rst_n(rst_n),
.R_en(R_en),
.fpopmode_bit_i(fpopmode_bit_i),
.h_addr(h_addr),
.x_addr(x_addr),
.filter_delay(filter_delay),
.dsp58_delay(dsp58_delay),
.y_o(y_o),
.x_i(x_i),
.h_i(h_i),
.invalid_o(invalid_o),
.overflow_o(overflow_o),
.underflow_o(underflow_o)
);

initial begin 
clk=0;
rst_n=0;
fpopmode_bit_i=1;
end
initial forever begin #50 clk=~clk; end 




endmodule
