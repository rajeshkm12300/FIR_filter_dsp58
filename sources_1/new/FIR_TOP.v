`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2025 11:52:20 AM
// Design Name: 
// Module Name: FIR_TOP
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


module FIR_TOP #(
parameter H_ADDR_WIDTH=4,
parameter X_ADDR_WIDTH=6,
parameter H_MEMO_DEPTH=1<<H_ADDR_WIDTH,
parameter X_MEMO_DEPTH=1<<X_ADDR_WIDTH,
parameter FILTER_LENGTH=1<<H_ADDR_WIDTH,
parameter FILTER_ORDER=FILTER_LENGTH-1,
parameter DATA_WIDTH=32,
parameter FPOPMODE_DELAY=4,
parameter COEFF_DELAY=H_MEMO_DEPTH
)(
input clk,rst_n,//ce_i,rst_i;
input fpopmode_bit_i,
output  [H_ADDR_WIDTH-1:0] h_addr,
output  [X_ADDR_WIDTH-1:0] x_addr,
output [DATA_WIDTH-1:0] y_o,
output invalid_o,overflow_o,underflow_o,R_en,
output filter_delay,dsp58_delay,
output  rst_dsp58,
output [DATA_WIDTH-1:0] x_i,
output [DATA_WIDTH-1:0] h_i
);
 //wire [DATA_WIDTH-1:0] x_i;
 //wire [DATA_WIDTH-1:0] h_i;
 wire [31:0] N;
 reg[DATA_WIDTH-1:0] Y_OUTPUT[0:(X_MEMO_DEPTH-H_MEMO_DEPTH)];
 
 assign rst_dsp58=filter_delay;
 
 DSP1 #(
 
 )				
	dsp1(
		.clk_i(clk), 
		//.ce_i(ce_i), 
		//.rst_i(rst_n),
		.dsp58_delay(dsp58_delay),
		.fpopmode_bit_i(fpopmode_bit_i),
		.x_i(x_i),
		.h_i(h_i),
		.y_o(y_o),
		.invalid_o(invalid_o),
		.overflow_o(overflow_o),
		.underflow_o(underflow_o)
	);  
    
    Memory_testing #(
    .ADDR_WIDTH(H_ADDR_WIDTH),
    .DATA_ADDR_WIDTH(X_ADDR_WIDTH),
    .X_MEM_DEPTH(X_MEMO_DEPTH),
    .MEM_DEPTH(H_MEMO_DEPTH)
     )memory(
     .clk(clk),
     .rst_n(rst_n),
     .h_addr(h_addr),
     . x_addr(x_addr),
     .R_en(R_en),
     .h_out(h_i),
     .x_out(x_i)
     );
    
    cnt_testing #(
    .H_ADDR_WIDTH(H_ADDR_WIDTH),
    .X_ADDR_WIDTH(X_ADDR_WIDTH),
    .H_MEMO_DEPTH(H_MEMO_DEPTH),
    . X_MEMO_DEPTH(X_MEMO_DEPTH),
    . FILTER_LENGTH(FILTER_LENGTH),
    . FILTER_ORDER(FILTER_ORDER),
    . FPOPMODE_DELAY(FPOPMODE_DELAY),
    . COEFF_DELAY(COEFF_DELAY)
    )control (
    .clk(clk),
    .rst_n(rst_n),
    .R_en(R_en),
    .h_addr(h_addr),
    .x_addr(x_addr),
    .filter_delay(filter_delay),
    .dsp58_delay(dsp58_delay),
    .N(N)
    );
    
    always @(*)begin 
    //$monitor("Y_OUTPUT=%b,N=%d",Y_OUTPUT[N-2],(N-2));
    if(dsp58_delay)begin
    if(N<=(X_MEMO_DEPTH-H_MEMO_DEPTH))
    Y_OUTPUT[N-2]<=y_o;
    end
    end
    
    always @(posedge clk)begin
    if(N==(X_MEMO_DEPTH-H_MEMO_DEPTH))
     $writememb("C:/Users/Rajesh/Desktop/FIR_Filter/write_bin.txt",Y_OUTPUT,0,(X_MEMO_DEPTH-H_MEMO_DEPTH));
    end
    
endmodule
