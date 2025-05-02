`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:09:41 PM
// Design Name: 
// Module Name: control_logic
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


module control_logic #(parameter FILTER_ORDER = 4, MEMORY_DEPTH = 4, ADDRESS_WIDTH = 2, TOTAL_DELAY = 8, FPOPMODE_DELAY = 4)
	(clk_i,ce_i,rst_i,en_x_o,en_h_o,we_x_o,addr_x_o,addr_h_o,fpopmode_bit_o,dv_o);
/**********************************************************************************/
/* Internal Parameters */
/**********************************************************************************/
localparam IDLE = 1'b0;
localparam COUNT = 1'b1;

localparam ENABLE_COUNTER_WIDTH = $clog2(MEMORY_DEPTH/2);
/**********************************************************************************/
/* Input/Output Ports */
/**********************************************************************************/
input clk_i,ce_i,rst_i;
output en_x_o,en_h_o;
output we_x_o;
output [ADDRESS_WIDTH-1:0] addr_x_o,addr_h_o;
output fpopmode_bit_o;
output dv_o;
/**********************************************************************************/
/* Internal Signals */
/**********************************************************************************/
reg [ADDRESS_WIDTH-1:0] addr_x = (MEMORY_DEPTH/2);
reg [ADDRESS_WIDTH-1:0] addr_h = 0;
reg [FPOPMODE_DELAY-1:0] fpopmode_bit = 0;
reg [TOTAL_DELAY-1:0] dv = 0;

reg state = IDLE;
reg enable = 1'b0;
reg ce = 1'b0;
/**********************************************************************************/
/* Control Logic */
/**********************************************************************************/
// - Address Data 
always @ (posedge clk_i) begin
	if(rst_i) begin
		state <= IDLE;
		addr_h <= 0;
		addr_x <= (MEMORY_DEPTH/2);
		enable <= 1'b0;
	end else begin
		case(state)
			IDLE: begin
							if(ce_i) begin 
								state <= COUNT;
								enable <= 1'b1;
							end else begin
								state <= IDLE;
								enable <= 1'b0;
							end
							addr_h <= 0;
						end
			COUNT: 	begin
								if(addr_h==(MEMORY_DEPTH/2)-2) begin
									state <= IDLE;
								end else begin
									state <= COUNT;
								end
								if(addr_x==MEMORY_DEPTH-1) begin
										addr_x <= (MEMORY_DEPTH/2);
								end else begin
										addr_x <= addr_x + 1'b1;
									end
								addr_h <= addr_h + 1'b1;
							end
		endcase
	end
end

always @(posedge clk_i) begin  
	if(rst_i) begin
		ce <= 1'b0;
	end else begin
		ce <= ce_i;
	end
end

assign addr_x_o = addr_x;
assign addr_h_o = addr_h;

// - Control Signals
assign we_x_o = ce;

assign en_x_o = enable;
assign en_h_o = enable;

// - FPOPMODE bit
always @(posedge clk_i) begin 
	if(rst_i) begin
		fpopmode_bit <= 0;
	end else begin
		fpopmode_bit <= {fpopmode_bit[FPOPMODE_DELAY-2:0],~ce_i};
	end
end

assign fpopmode_bit_o = fpopmode_bit[FPOPMODE_DELAY-1];

// - DV 
always @(posedge clk_i) begin 
		dv <= {dv[TOTAL_DELAY-1:0],ce_i};
end

assign dv_o = dv[TOTAL_DELAY-1];

endmodule
