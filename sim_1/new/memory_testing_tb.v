`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 09:30:18 PM
// Design Name: 
// Module Name: memory_testing_tb
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


module memory_testing_tb();
parameter ADDR_WIDTH=4;
parameter DATA_ADDR_WIDTH=6;
parameter DATA_WIDTH=32;
parameter CLK_PERIOD=10;

reg clk;
reg rst_n;
reg [ADDR_WIDTH-1:0] h_addr;
reg [DATA_ADDR_WIDTH-1:0] x_addr;
reg R_en;
wire [DATA_WIDTH-1:0] h_out,x_out;


Memory_testing #(
.ADDR_WIDTH(ADDR_WIDTH),
.DATA_WIDTH(DATA_WIDTH),
.DATA_ADDR_WIDTH(DATA_ADDR_WIDTH),
.INIT_FILE("C:/Users/Rajesh/Desktop/Memory_input.hex"),
.X_INIT_FILE("C:/Users/Rajesh/Desktop/X_INIT_FILE.bin")
)
Memory_testing(
        .clk(clk),
        .rst_n(rst_n),
        .h_addr(h_addr),
        .x_addr(x_addr),
        .R_en(R_en),
        .h_out(h_out),
        .x_out(x_out)
        
);

initial begin 
clk=0;
rst_n=0;
R_en=1;
h_addr=0;
x_addr=0;
rst_n=1;
R_en=1;
repeat(16)begin
#CLK_PERIOD;
h_addr=h_addr+1;
end

 end
 initial begin
 repeat(64) begin 
 #CLK_PERIOD;
 x_addr=x_addr+1;
 
 end
 end
always begin 
#(CLK_PERIOD*0.5);
clk=~clk;
end

endmodule
