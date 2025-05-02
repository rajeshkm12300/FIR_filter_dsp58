`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 12:09:09 PM
// Design Name: 
// Module Name: dsp
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

module dsp	#(
parameter FILTER_ORDER = 4, DATA_WIDTH = 32,  COEFF_WIDTH = 32, OUTPUT_WIDTH = 32, DATA_MAN_WIDTH = 23, DATA_EXP_WIDTH = 8, COEFF_MAN_WIDTH = 23, COEFF_EXP_WIDTH = 8)				
	(clk_i,ce_i,rst_i,fpopmode_bit_i,x_i,h_i,y_o,invalid_o,overflow_o,underflow_o);
/**********************************************************************************/
/* Internal Parameters */
/**********************************************************************************/
localparam FPOPMODE_WIDTH = 7;	
/**********************************************************************************/
/* Input/Output Ports */
/**********************************************************************************/
input clk_i,ce_i,rst_i;
input fpopmode_bit_i;
input [DATA_WIDTH-1:0] x_i;
input [COEFF_WIDTH-1:0] h_i;
output [OUTPUT_WIDTH-1:0] y_o;
output invalid_o,overflow_o,underflow_o;
/**********************************************************************************/
/* Internal signals */
/**********************************************************************************/
localparam AREG = 1;
localparam FPBREG = 1;
localparam FPMPIPEREG = 1;
localparam FPM_PREG = 1;
localparam FPA_PREG = 1;
localparam FPOPMREG = 1;

wire [DATA_MAN_WIDTH-1:0] a_man_i;
wire [DATA_EXP_WIDTH-1:0] a_exp_i;
wire a_sign_i;
wire [COEFF_MAN_WIDTH-1:0] b_man_i;
wire [COEFF_EXP_WIDTH-1:0] b_exp_i;
wire b_sign_i;
wire fpinmode;
wire [FPOPMODE_WIDTH-1:0] fpopmode;

assign {a_sign_i,a_exp_i,a_man_i} = x_i;
assign {b_sign_i,b_exp_i,b_man_i} = h_i;
assign fpinmode = 1'b1;
assign fpopmode = {2'b00,fpopmode_bit_i,2'b00,2'b01};
/**********************************************************************************/
/* Filter Stage */
/**********************************************************************************/
//// DSPFP32 instantiation ////
DSPFP32 #(
    .ACASCREG (0),
    .AREG (AREG),
    .A_FPTYPE ("B32"),
    .A_INPUT ("DIRECT"),
    .BCASCSEL ("B"),
    .B_D_FPTYPE ("B32"),
    .B_INPUT ("DIRECT"),
    .FPA_PREG (FPA_PREG),
    .FPBREG (FPBREG),
    .FPCREG (0),
    .FPDREG (0),
    .FPMPIPEREG (FPMPIPEREG),
    .FPM_PREG (FPM_PREG),
    .FPOPMREG (FPOPMREG),
    .INMODEREG (0),
    .PCOUTSEL ("FPM"),
    .RESET_MODE ("SYNC"),
    .USE_MULT ("MULTIPLY")
)
DSPFP32_inst(
  .ACOUT_EXP(),
  .ACOUT_MAN(),
  .ACOUT_SIGN(),
  .BCOUT_EXP(),
  .BCOUT_MAN(),
  .BCOUT_SIGN(),
  .FPA_INVALID(invalid_o),
  .FPA_OUT(y_o),
  .FPA_OVERFLOW(overflow_o),
  .FPA_UNDERFLOW(underflow_o),
  .FPM_INVALID(),
  .FPM_OUT(),
  .FPM_OVERFLOW(),
  .FPM_UNDERFLOW(),
  .PCOUT(),

  .ACIN_EXP(),
  .ACIN_MAN(),
  .ACIN_SIGN(),
  .ASYNC_RST(),
  .A_EXP(a_exp_i),
  .A_MAN(a_man_i),
  .A_SIGN(a_sign_i),
  .BCIN_EXP(),
  .BCIN_MAN(),
  .BCIN_SIGN(),
  .B_EXP(b_exp_i),
  .B_MAN(b_man_i),
  .B_SIGN(b_sign_i),
  .C(),
  .CEA1(),
  .CEA2(1'b1),
  .CEB(1'b1),
  .CEC(),
  .CED(),
  .CEFPA(1'b1),
  .CEFPM(1'b1),
  .CEFPMPIPE(1'b1),
  .CEFPINMODE(),
  .CEFPOPMODE(1'b1),
  .CLK(clk_i),
  .D_EXP(),
  .D_MAN(),
  .D_SIGN(),
  .FPINMODE(fpinmode),
  .FPOPMODE(fpopmode),
  .PCIN(),
  .RSTA(1'b0),
  .RSTB(1'b0),
  .RSTC(),
  .RSTD(),
  .RSTFPA(1'b0),
  .RSTFPINMODE(),
  .RSTFPM(1'b0),
  .RSTFPMPIPE(1'b0),
  .RSTFPOPMODE(1'b0)
);



	
endmodule