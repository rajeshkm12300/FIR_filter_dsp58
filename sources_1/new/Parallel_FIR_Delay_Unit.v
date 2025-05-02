`timescale 1ns / 1ps

module Parallel_FIR_Delay_Unit#(
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
    temp<=0;
    end
    
    assign dsp58_delay=((temp>=delay1)&&(temp<(delay1+1)))?(1'b1):(1'b0);
    assign filter_delay=(count !=0)?((count > (filter_length))?(1'b1):(1'b0)):(0);
   
    
    
    always @(posedge clk) begin 
    if(~filter_delay)begin 
    temp<=0;
    end
    else 
    temp<=temp+1;
    end
    
    always @(posedge clk)begin
    //$monitor("count=%d",count);
   
   if((starting_delay>=1)) begin
    count<=count+1;
    end
    if(starting_delay <7)
    starting_delay<=starting_delay + 1;
    end
    




endmodule