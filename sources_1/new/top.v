`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:07:55 PM
// Design Name: 
// Module Name: top
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


(* DONT_TOUCH = "YES" *)
module top #(parameter SP_WIDTH = 32, DATA_MAN_WIDTH = 23, DATA_EXP_WIDTH = 8, COEFF_MAN_WIDTH = 23, COEFF_EXP_WIDTH = 8, FILTER_ORDER = 4, DSP_DELAY = 4, MEMORY_DELAY = 3)
	(clk_i,ce_i,rst_i,x_i,y_o,invalid_o,overflow_o,underflow_o,dv_o);
/**********************************************************************************/
/* Parameters */
/**********************************************************************************/
localparam MEMORY_DEPTH = (2*FILTER_ORDER);				
localparam ADDRESS_WIDTH = $clog2(MEMORY_DEPTH);  
localparam TOTAL_DELAY = (FILTER_ORDER-1)+DSP_DELAY+MEMORY_DELAY;			
localparam FPOPMODE_DELAY = MEMORY_DELAY+(DSP_DELAY-2);
/**********************************************************************************/
/* Input/Output Ports */
/**********************************************************************************/
input clk_i,ce_i,rst_i;
input [SP_WIDTH-1:0] x_i;
output [SP_WIDTH-1:0] y_o;
output invalid_o,overflow_o,underflow_o;
output dv_o;
/**********************************************************************************/
/* Internal Signals */
/**********************************************************************************/
// - Control Logic 
wire en_x;
wire en_h;
wire we_x;
wire [ADDRESS_WIDTH-1:0] addr_x;
wire [ADDRESS_WIDTH-1:0] addr_h;
// - Memory
wire [SP_WIDTH-1:0] x;
wire [SP_WIDTH-1:0] h;
wire fpopmode_bit;
/**********************************************************************************/
/* Instances */
/**********************************************************************************/
/* CONTROL LOGIC */
control_logic #(.FILTER_ORDER(FILTER_ORDER),.MEMORY_DEPTH(MEMORY_DEPTH),.ADDRESS_WIDTH(ADDRESS_WIDTH),.TOTAL_DELAY(TOTAL_DELAY),.FPOPMODE_DELAY(FPOPMODE_DELAY))
	control_logic_inst (
							.clk_i(clk_i),.ce_i(ce_i),.rst_i(rst_i),
							.en_x_o(en_x),.en_h_o(en_h),.we_x_o(we_x),.addr_x_o(addr_x),.addr_h_o(addr_h),.fpopmode_bit_o(fpopmode_bit),.dv_o(dv_o)
						);


/* MEMORY */
memory	#(.DATA_WIDTH(SP_WIDTH),.COEFF_WIDTH(SP_WIDTH),.MEMORY_DEPTH(MEMORY_DEPTH),.ADDRESS_WIDTH(ADDRESS_WIDTH))			
	memory_inst(
					.clk_i(clk_i), 
					.x_i(x_i),
					.en_x_i(en_x), .en_h_i(en_h),
					.we_x_i(we_x), .we_h_i(1'b0),
					.addr_x_i(addr_x), .addr_h_i(addr_h),
					.x_o(x), .h_o(h)
				);
	
/* DSP */
dsp #(.FILTER_ORDER(FILTER_ORDER),.DATA_WIDTH(SP_WIDTH),.COEFF_WIDTH(SP_WIDTH),.OUTPUT_WIDTH(SP_WIDTH),.DATA_MAN_WIDTH(DATA_MAN_WIDTH),.DATA_EXP_WIDTH(DATA_EXP_WIDTH),.COEFF_MAN_WIDTH(COEFF_MAN_WIDTH),.COEFF_EXP_WIDTH(COEFF_EXP_WIDTH))				
	dsp_inst(
					.clk_i(clk_i), .ce_i(ce_i), .rst_i(rst_i),.fpopmode_bit_i(fpopmode_bit),
					.x_i(x),.h_i(h),
					.y_o(y_o),.invalid_o(invalid_o),.overflow_o(overflow_o),.underflow_o(underflow_o)
				);

endmodule

