`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2025 08:37:13 AM
// Design Name: 
// Module Name: cnt_testing_tb
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


module cnt_testing_tb();
parameter H_ADDR_WIDTH=4;
parameter X_ADDR_WIDTH=6;
reg clk,rst_n;
wire R_en;
wire [H_ADDR_WIDTH-1:0] h_addr;
wire [X_ADDR_WIDTH-1:0] x_addr;
wire filter_delay,dsp58_delay;
cnt_testing #()uut(
.clk(clk),
.rst_n(rst_n),
.R_en(R_en),
.h_addr(h_addr),
.x_addr(x_addr),
.filter_delay(filter_delay),
.dsp58_delay(dsp58_delay)
);

initial begin 
clk=0;
rst_n=0;
end
initial forever begin #50 clk=~clk; end 



endmodule
