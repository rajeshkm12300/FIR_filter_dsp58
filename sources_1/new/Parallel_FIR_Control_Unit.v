`timescale 1ns / 1ps

module Parallel_FIR_Control_Unit#(
parameter H_ADDR_WIDTH=4,
parameter X_ADDR_WIDTH=6,
parameter DATA_WIDTH=32,
parameter H_MEMO_DEPTH=1<<H_ADDR_WIDTH,
parameter X_MEMO_DEPTH=1<<X_ADDR_WIDTH,
parameter FILTER_LENGTH=1<<H_ADDR_WIDTH,
parameter FILTER_ORDER=FILTER_LENGTH-1,
parameter FPOPMODE_DELAY=4,
parameter COEFF_DELAY=H_MEMO_DEPTH
)(
input clk,rst_n,fpopmode_bit_i,
output reg R_en,
output reg [H_ADDR_WIDTH-1:0] h_addr,
output  reg [X_ADDR_WIDTH-1:0] x_addr,
output filter_delay,dsp58_delay,invalid_o,overflow_o,underflow_o,
output reg[31:0] N
);
reg [X_ADDR_WIDTH-1:0] starting_address[0:(X_MEMO_DEPTH-H_MEMO_DEPTH)];
wire [DATA_WIDTH-1:0] x_i[0:(X_MEMO_DEPTH-H_MEMO_DEPTH)];
wire [DATA_WIDTH-1:0] h_i[0:(X_MEMO_DEPTH-H_MEMO_DEPTH)];
wire [DATA_WIDTH-1:0] y_o[0:(X_MEMO_DEPTH-H_MEMO_DEPTH)];
reg [DATA_WIDTH-1:0] Y_OUTPUT[0:(X_MEMO_DEPTH-H_MEMO_DEPTH)];
integer k,M;
wire [5:0] starting_delay;

Parallel_FIR_Delay_Unit #(
    .delay1(FPOPMODE_DELAY),
    .filter_length(FILTER_LENGTH)
    )delay(
    .clk(clk),
    .dsp58_delay(dsp58_delay),
    .filter_delay(filter_delay),
    .starting_delay(starting_delay)
    );
    
genvar j;
    generate
        for (j = 0; j <= (X_MEMO_DEPTH-H_MEMO_DEPTH); j = j + 1) begin : inst_loop
            Memory_testing #(
    .ADDR_WIDTH(H_ADDR_WIDTH),
    .DATA_ADDR_WIDTH(X_ADDR_WIDTH),
    .X_MEM_DEPTH(X_MEMO_DEPTH),
    .MEM_DEPTH(H_MEMO_DEPTH)
     )memory(
     .clk(clk),
     .rst_n(rst_n),
     .h_addr(h_addr),
     . x_addr(starting_address[j]),
     .R_en(R_en),
     .h_out(h_i[j]),
     .x_out(x_i[j])
     );
        end
    endgenerate
    
    
    genvar p;
    generate
        for (p = 0; p <= (X_MEMO_DEPTH-H_MEMO_DEPTH); p = p + 1) begin : inst_loop_dsp
           DSP1 #(
 
 )				
	dsp1(
		.clk_i(clk), 
		//.ce_i(ce_i), 
		//.rst_i(rst_n),
		.dsp58_delay(dsp58_delay),
		.fpopmode_bit_i(fpopmode_bit_i),
		.x_i(x_i[p]),
		.h_i(h_i[p]),
		.y_o(y_o[p]),
		.invalid_o(invalid_o),
		.overflow_o(overflow_o),
		.underflow_o(underflow_o)
	);  
    
        end
    endgenerate








initial begin 
N=0;
h_addr=0;
R_en<=1;
end

 reg [4:0] array [0:56];

    // Generate block to initialize array with N+1 values
    genvar i;
    generate
        for (i = 0; i <= (X_MEMO_DEPTH-H_MEMO_DEPTH); i = i + 1) begin : array_init_loop
            initial begin
                starting_address[i] <= H_MEMO_DEPTH+ i-1; 
            end
        end
    endgenerate


always @(posedge clk)begin 

 if(rst_n)begin 
             h_addr<=0;
             x_addr<=H_MEMO_DEPTH-1;
             
                end  
           else if(starting_delay >= 1)begin 
          if(N<=(H_MEMO_DEPTH-2)) begin
                    if(filter_delay)begin
                    h_addr<=0;
                   // R_en<=0;
                    end 
                    else begin 
                    
                            h_addr<=h_addr+1;
                            
                            for(k=0;k<=X_MEMO_DEPTH;k=k+1)begin
                           starting_address[k]<=starting_address[k]-1;
                           // x_addr<=0;
                           // R_en<=1;
                            
                            end
                            N<=N+1;
                            
                            end 
                     
                        
            
                    end
                    else begin
                    R_en<=0;
                    if(dsp58_delay)begin
                    for(M=0;M<=(X_MEMO_DEPTH-H_MEMO_DEPTH);M=M+1)begin
                    Y_OUTPUT[M]<=y_o[M];
                    end
                    end
          end
           end
            
end

endmodule