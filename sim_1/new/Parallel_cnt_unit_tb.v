`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2025 01:50:37 PM
// Design Name: 
// Module Name: Parallel_cnt_unit_tb
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


module Parallel_cnt_unit_tb();
parameter H_ADDR_WIDTH=4;
parameter X_ADDR_WIDTH=6;
reg clk,rst_n,fpopmode_bit_i;
wire R_en;
wire [H_ADDR_WIDTH-1:0] h_addr;
wire [X_ADDR_WIDTH-1:0] x_addr;
wire filter_delay,dsp58_delay,overflow_o,underflow_o,invalid_o;
Parallel_FIR_Control_Unit #()uut(
.clk(clk),
.rst_n(rst_n),
.fpopmode_bit_i(fpopmode_bit_i),
.R_en(R_en),
.h_addr(h_addr),
.x_addr(x_addr),
.filter_delay(filter_delay),
.dsp58_delay(dsp58_delay),
.overflow_o(overflow_o),
.underflow_o(underflow_o),
.invalid_o(invalid_o)
);

initial begin 
clk=0;
rst_n=0;
fpopmode_bit_i=1;
end
initial forever begin #50 clk=~clk; end 
endmodule
