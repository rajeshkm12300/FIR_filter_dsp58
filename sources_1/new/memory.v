`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:15:55 PM
// Design Name: 
// Module Name: memory
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


//`timescale 1 ns/1 ps

module memory #(parameter DATA_WIDTH = 32, COEFF_WIDTH = 32, MEMORY_DEPTH = 8, ADDRESS_WIDTH = 3)			
	(clk_i,x_i,en_x_i,en_h_i,we_x_i,we_h_i,addr_x_i,addr_h_i,x_o,h_o);
/**********************************************************************************/
/* Input/Output Ports */
/**********************************************************************************/
input clk_i;
input [DATA_WIDTH-1:0] x_i;
input en_x_i,en_h_i;
input we_x_i,we_h_i;
input [ADDRESS_WIDTH-1:0] addr_x_i,addr_h_i;
output reg [DATA_WIDTH-1:0] x_o = 0;
output reg [COEFF_WIDTH-1:0] h_o = 0;
/**********************************************************************************/
/* Internal Signals */
/**********************************************************************************/
reg [DATA_WIDTH-1:0] mem [0:MEMORY_DEPTH-1]; 
reg [DATA_WIDTH-1:0] x = 0;
reg [COEFF_WIDTH-1:0] h = 0;
/**********************************************************************************/
/* Memory Initialization */
/**********************************************************************************/
initial begin
	$readmemh("./src/init_rom.txt",mem);
end
/**********************************************************************************/
/* Memory */
/**********************************************************************************/
// - X
always @(posedge clk_i) begin
	if(en_x_i) begin 
		if(we_x_i) begin
			mem[addr_x_i] <= x_i;
			x <= x_i;
		end else begin
			x <= mem[addr_x_i];
		end
	end
	x_o <= x;
end

// - H
always @(posedge clk_i) begin
	if(en_h_i) begin 
		if(we_h_i)
			mem[addr_h_i] <= 0;
		h <= mem[addr_h_i];
	end
	h_o <= h;
end


endmodule

