`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2025 09:55:13 AM
// Design Name: 
// Module Name: Memory_testing
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


module Memory_testing#(
parameter ADDR_WIDTH=4,
parameter DATA_ADDR_WIDTH=6,
parameter DATA_WIDTH=32,
parameter X_MEM_DEPTH=1<<DATA_ADDR_WIDTH,
parameter MEM_DEPTH=1<<ADDR_WIDTH,
parameter INIT_FILE = "C:/Users/Rajesh/Desktop/FIR_Filter/Memory_input.hex",
parameter X_INIT_FILE="C:/Users/Rajesh/Desktop/FIR_Filter/X_INIT_FILE.bin"

)(
input wire clk,
input wire rst_n,
input wire [ADDR_WIDTH-1:0] h_addr,
input wire [DATA_ADDR_WIDTH-1:0] x_addr,
input wire R_en,
output reg [DATA_WIDTH-1:0] h_out,x_out
    );
    
    reg [DATA_WIDTH-1:0] rom_mem[0:MEM_DEPTH-1],x_rom_mem[0:X_MEM_DEPTH-1];
    
    
    initial begin
    if(INIT_FILE != "") begin 
    $readmemh(INIT_FILE,rom_mem);
    end
    if(X_INIT_FILE !="")begin
    $readmemb(X_INIT_FILE,x_rom_mem);
    end
    end
    initial begin 
    x_out<=x_rom_mem[x_addr];
    h_out<=rom_mem[h_addr];
    end
    always @(posedge clk)begin
    
    //$monitor("h_data=%b,h_addr=%d,x_out=%b,x_addr=%d",h_out,h_addr,x_out,x_addr);
    if(rst_n) begin
    h_out<={DATA_WIDTH{1'b0}};
    x_out<={DATA_WIDTH{1'b0}};
    end
    else if(R_en)begin
    h_out<=rom_mem[h_addr];
    x_out<=x_rom_mem[x_addr];
    end
    end
    
endmodule
