`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 09:20:12 PM
// Design Name: 
// Module Name: delay_testing
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


module delay_testing#(
parameter delay1=4, filter_length=16
)(
input clk,
output dsp58_delay,filter_delay,
output reg[5:0] starting_delay
    );
    
   
    
    
    integer count,temp;
    wire temp1;
    
    initial begin 
  //  clk<=0;
    count<=1;
    starting_delay<=0;
    temp<=5;
    end
    
    assign dsp58_delay=(temp==delay1)?(1'b1):(1'b0);
    assign temp1=(count !=0)?((count % (filter_length))?(1'b0):(1'b1)):(0);
    assign filter_delay=(temp==1)?(1'b1):(1'b0);
    
    
    always @(posedge clk) begin 
    if(temp1)begin 
    temp<=0;
    end
    else 
    temp<=temp+1;
    end
    
    always @(posedge clk)begin
    $monitor("count=%d",count);
   if(temp1)begin
   count<=0;
   end
   if((starting_delay>=1)&& ~temp1) begin
    count<=count+1;
    end
    if(starting_delay <7)
    starting_delay<=starting_delay + 1;
    end
    
endmodule
