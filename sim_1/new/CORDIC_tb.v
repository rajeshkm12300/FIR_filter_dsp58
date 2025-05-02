`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 10:53:28 AM
// Design Name: 
// Module Name: COORDIC_iteration_tb
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


module CORDIC_tb();
reg [31:0] y,Angle;
reg clk;
reg [4:0] CHRVE;
wire[31:0] sin, cos,arctan_y,sinh,cosh,arctanh_y,exp;
//wire [31:0] z_i_1,x_output,y_output;
//wire [5:0] count,count1;

CORDIC uut(
.y(y),
.z(Angle),
.clk(clk),
.sin(sin),
.cos(cos),
.CHRVE(CHRVE),
.arctan_y(arctan_y),
//.z_i_1(z_i_1),
//.x_output(x_output),
//.y_output(y_output),
//.count(count),
.sinh(sinh),
.cosh(cosh),
.arctanh_y(arctanh_y),
//.count1(count1),
.exp(exp)
);

initial begin clk=0; end
always begin #50; 
clk=~clk; end

initial begin
Angle<=32'b01000001111100000000000000000000; //30
//Angle<=32'b00000000000000000000000000000000; //0
//Angle<=32'b01000010001101000000000000000000; //45
 // Angle<=32'b01000001101000000000000000000000; //20
  //Angle<=32'b01000010111100000000000000000000; //120
  // Angle<=32'b01000011101000000000000000000000; //320
   //Angle<=32'b01000010010010000000000000000000; //50
//x<=32'b00111111000110110011001100110100; //.6073
y<=32'b00000000000000000000000000000000;
//x<=32'b00111111100000000000000000000000; //1
//y<=32'b00111111100000000000000000000000; //1
 //y<=32'b01000001111100000000000000000000; //30
 //y<=32'b00111111110111000010100011010010;//1.732
 //y<=32'b00111111010101100110011001100110; //0.8039
 //y<=32'b01000000100000000000000000000000; //4
// y<=32'b00111111010011001100110011001100; //0.8
 //y<=32'b00111111000110011001100110011010; //0.6
 //y<=32'b01000001000000000000000000000000 ;//8
 //y<=32'b01000010101101000000000000000000; //90
 //y<=32'b01000000000000000000000000000000; //2
 // testing hyperbolic funcition in rotation mode
 //x<=32'b00111111100110101000111100001000; //1.20749
 //x<=32'b00111111100000000000000000000000;//1
// y<=32'b00000000000000000000000000000000;
 //Angle<=32'b00111111000110011001100110011010; //0.6
// Angle<=32'b00111111010011001100110011001101; //0.8
//CHRVE<=5'b00101; //for sin and cos
CHRVE<=5'b00101; //for exponential

end

endmodule
