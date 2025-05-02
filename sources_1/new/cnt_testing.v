`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2025 12:18:50 PM
// Design Name: 
// Module Name: cnt_testing
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


module cnt_testing#(

parameter H_ADDR_WIDTH=4,
parameter X_ADDR_WIDTH=6,
parameter H_MEMO_DEPTH=1<<H_ADDR_WIDTH,
parameter X_MEMO_DEPTH=1<<X_ADDR_WIDTH,
parameter FILTER_LENGTH=1<<H_ADDR_WIDTH,
parameter FILTER_ORDER=FILTER_LENGTH-1,
parameter FPOPMODE_DELAY=4,
parameter COEFF_DELAY=H_MEMO_DEPTH
)(
input clk,rst_n,
output reg R_en,
output reg [H_ADDR_WIDTH-1:0] h_addr,
output reg [X_ADDR_WIDTH-1:0] x_addr,
output filter_delay,dsp58_delay,
output reg[31:0] N
    );
    reg state=0; // this state for idle and 1 for increment address
    //wire dsp58_delay;
   // integer N;
    //wire filter_delay;
    wire [5:0]starting_delay;
    initial begin 
    N=1;
    R_en=1;
    h_addr<=0;
    x_addr<=H_MEMO_DEPTH-1;
    end
    always @(posedge clk)begin
     N=(filter_delay)?(N+1):(N);
    end
    // port mapping of delay module
    delay_testing #(
    .delay1(FPOPMODE_DELAY),
    .filter_length(FILTER_LENGTH)
    )delay(
    .clk(clk),
    .dsp58_delay(dsp58_delay),
    .filter_delay(filter_delay),
    .starting_delay(starting_delay)
    );
    /*
    // prot mapping of Memory testing
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
     .h_out(h_out),
     .x_out(x_out)
     );
    */
   
 always @(posedge clk) begin 
 //$monitor("h memory depth=%b,COEFF_DELAY=%b,x_addr=%b",H_MEMO_DEPTH,COEFF_DELAY,x_addr);
        if(rst_n)begin 
             state<=0;
             h_addr<=0;
             x_addr<=H_MEMO_DEPTH-1;
             
                end  
           else if(starting_delay >= 1)begin 
          if(N<=((X_MEMO_DEPTH-H_MEMO_DEPTH)+2)) begin
                    if(filter_delay)begin
                    h_addr<=0;
                    x_addr<=(H_MEMO_DEPTH + N)-2;
                 
                    end 
                    else begin 
                    
                            h_addr<=h_addr+1;
                            x_addr<=(x_addr-1);
                           // x_addr<=0;
                            
                            
                            end 
                     
                        
            
                    end
          
           end
            
    
    end
    
endmodule
