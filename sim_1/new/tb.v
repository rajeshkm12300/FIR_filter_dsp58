`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:20:31 PM
// Design Name: 
// Module Name: tb
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


//localparam MAN_WIDTH = 23;
//localparam EXP_WIDTH = 8;
//localparam SP_WIDTH = 32;

`define END_SIM_NS (10**4)

module tb1
    #(parameter SEED_X_MAN = 23'd153659, SEED_X_EXP = 8'd100, SEED_X_SIGN = 1'b0, SEED_CE = 1'b1) 
    ();
localparam MAN_WIDTH = 23;
localparam EXP_WIDTH = 8;
localparam SP_WIDTH = 32;
    
//// Internal parameters //// 
// - Design
localparam HALF_PERIOD_NS = 5;
localparam GSR_DELAY = 100; //ns

// - DSP 
localparam FILTER_ORDER = 4;            
localparam DSP_DELAY = 4;
localparam MEMORY_DELAY = 2;
localparam MULT_LATENCY = DSP_DELAY + 1;
localparam MULT_ACC_LATENCY = MULT_LATENCY + 1;
// - Parameters for dist_uniform
localparam START 	 = 0;
localparam END_MAN   = (2**(MAN_WIDTH))-1;         
localparam END_EXP 	 = (2**(EXP_WIDTH))-1;	
localparam END = 1;		

//// Input/Output ports ////
// - Input
reg clk_i,rst_i;
wire ce_i;
wire [SP_WIDTH-1:0] x_i;

// - Output
wire [SP_WIDTH-1:0] y_o; 
wire invalid_o,overflow_o,underflow_o;
wire dv_o;
//// Internal Signals ////
// - Inputs
reg ce;
reg [MAN_WIDTH-1:0] x_man;                                                                                           
reg [EXP_WIDTH-1:0] x_exp;                                                                                           
reg x_sign;                                                                                           
// - Random
integer seed_x_man = SEED_X_MAN;                                                                                                             
integer seed_x_exp = SEED_X_EXP;                                                                                                             
integer seed_x_sign = SEED_X_SIGN;                                                                                                             
integer seed_ce = SEED_CE;                                                                                                             
// - Rom
reg [SP_WIDTH-1:0] rom [0:FILTER_ORDER-1];
// - Counter
reg [$clog2(FILTER_ORDER)-1:0] counter;

//// DUT ////
top1 
    DUV (
			.clk_i(clk_i),
            .rst_i(rst_i),
            .ce_i(ce_i),
            .x_i(x_i),
            .y_o(y_o),
            .invalid_o(invalid_o),
            .overflow_o(overflow_o),
            .underflow_o(underflow_o)
         //   .dv_o(dv_o)
        );
            
//// Initial block ////
initial 
begin
    // // - DUV inputs
    x_man  = 0;
    x_exp  = 0;
    x_sign  = 1'b0;
	// - Counters
    counter = 0;
    // - clock and reset  
    clk_i = 1'b0;
	rst_i = 1'b1;
	ce = 1'b0;
	#(GSR_DELAY) rst_i = 1'b0;
end

integer f;
initial
begin
    $timeformat(-9,2,"ns");
    f = $fopen("output.dat","w");
// - End of simulation
    #(`END_SIM_NS) 
    $fclose(f);
    $finish;
end

//// Clock  ////
always 
    #HALF_PERIOD_NS clk_i = !clk_i;
    
//// Stimuli ////
always @ (posedge clk_i) begin
	if(rst_i) begin
        x_man <= 0;
		x_exp <= 0;
        x_sign <= 1'b0;
        ce <= 1'b0;
	end else begin
        if(counter==FILTER_ORDER-1) begin
            x_man <= $dist_uniform(seed_x_man,START,END_MAN);
            x_exp <= $dist_uniform(seed_x_exp,START,END_EXP);
    		x_sign <= $dist_uniform(seed_x_man,START,END);
            ce <= $dist_uniform(seed_ce,START,END);
    	end else begin
            ce <= 1'b0;
        end 
    end  
end

always @ (posedge clk_i) begin
	if(rst_i) begin
		counter <=0;
	end else begin
		if(counter==FILTER_ORDER-1)
			counter <= 0;
		else
			counter <= counter+1'b1;
	end  
end

//// Redirect input to DSP ////
assign ce_i = ce;
assign x_i = {x_sign,x_exp,x_man};

// - ROM
initial begin
    $readmemh("./src/init_rom_tb.txt",rom);
end

//// Test Result ////
always @ (posedge clk_i) begin
    if(dv_o) begin
        $fwrite(f,"Time=%0t Data_out_sign=%0d Data_out_exp=%0d Data_out_man=%0d Invalid=%0d Underflow=%0d Overflow=%0d\n",$realtime,y_o[31],y_o[30:23],y_o[22:0],invalid_o,underflow_o,overflow_o);
    end
end

endmodule