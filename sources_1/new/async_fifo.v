`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2025 12:50:34 PM
// Design Name: 
// Module Name: async_fifo
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


module async_fifo#(
parameter DATA_LENGTH=32,
parameter MEMORY_SIZE=32,
parameter ADDRESS_WIDTH=$clog2(MEMORY_SIZE)
)(
input wr_clk,rd_clk,wr_en,rd_en,rst_fifo,
input [DATA_LENGTH-1:0] data_in,
output reg [DATA_LENGTH-1:0] data_out,
output  full,empty,overflow,underflow,
output  [ADDRESS_WIDTH:0] wr_pointer, rd_pointer,
output reg [ADDRESS_WIDTH:0] B_to_G_wr_pointer,
    G_to_B_wr_pointer,
    B_to_G_rd_pointer,
    G_to_B_rd_pointer,
    sync_wr_pointer,
    sync_wr_pointer1,
    sync_rd_pointer,
    sync_rd_pointer1
    );
    
    reg [DATA_LENGTH-1:0] RAM[0:MEMORY_SIZE-1];
    
    initial begin 
   // full<=0;
   // empty<=0;
   // overflow<=0;
   // underflow<=0;
    B_to_G_wr_pointer<=0;
    G_to_B_wr_pointer<=0;
    B_to_G_rd_pointer<=0;
    G_to_B_rd_pointer<=0;
    sync_wr_pointer<=0;
    sync_wr_pointer1<=0;
    sync_rd_pointer<=0;
    sync_rd_pointer1<=0;
    
    end
    /*
    reg [ADDRESS_WIDTH:0] wr_pointer, 
    rd_pointer,
    B_to_G_wr_pointer,
    G_to_B_wr_pointer,
    B_to_G_rd_pointer,
    G_to_B_rd_pointer,
    sync_wr_pointer,
    sync_wr_pointer1,
    sync_rd_pointer,
    sync_rd_pointer1;
    */
    integer i,j,k,m;
    async_wr_pointer #(
    .DATA_LENGTH(DATA_LENGTH),
    .MEMORY_SIZE(MEMORY_SIZE),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
    )
     memory_write(
     .wr_clk(wr_clk),
     .wr_en(wr_en),
     .rst_fifo(rst_fifo),
     .full(full),
     .wr_pointer(wr_pointer)
     );
     
     async_rd_pointer #(
    .DATA_LENGTH(DATA_LENGTH),
    .MEMORY_SIZE(MEMORY_SIZE),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
    )
     memory_read(
     .rd_clk(rd_clk),
     .rd_en(rd_en),
     .rst_fifo(rst_fifo),
     .empty(empty),
     .rd_pointer(rd_pointer)
     );
     
     assign full=((wr_pointer[ADDRESS_WIDTH] != G_to_B_rd_pointer[ADDRESS_WIDTH])&&(wr_pointer[ADDRESS_WIDTH-1:0] == G_to_B_rd_pointer[ADDRESS_WIDTH-1:0]))?(1):(0);
     assign empty=(rd_pointer == G_to_B_wr_pointer)?(1):(0);
     assign overflow=(full)?((wr_en)?(1):(0)):(0);
     assign underflow=(empty)?((rd_en)?(1):(0)):(0);
     // write data in a memory
     always @(posedge wr_clk)begin
     if(wr_en)begin
     RAM[wr_pointer[ADDRESS_WIDTH-1:0]]<=data_in; 
     end
     end
     
     // Read data from memory
     always @(posedge rd_clk)begin 
     if(rd_en)begin 
     data_out<=RAM[rd_pointer[ADDRESS_WIDTH-1:0]];
     end
     end
     // Binary to gray code conversion of write pointer 
    
     always @(*)begin
     B_to_G_wr_pointer<=((wr_pointer)>>1)+(wr_pointer);
     end
     // Binary to gray code conversion of read pointer
    
     always @(*)begin
    B_to_G_rd_pointer<=((rd_pointer)>>1)+(rd_pointer);
     end
     
     // Gray to binary conversion of write pointer module // full
     
     always @(*)begin
     G_to_B_rd_pointer[ADDRESS_WIDTH]<=sync_rd_pointer[ADDRESS_WIDTH];
     for(k=ADDRESS_WIDTH-1;k>=0;k=k-1)begin 
     G_to_B_rd_pointer[k]<=G_to_B_rd_pointer[k+1]^sync_rd_pointer[k];
     end
     end
     // Gray to binary conversion of read pointer module // empty
      
      always @(*)begin
     G_to_B_wr_pointer[ADDRESS_WIDTH]<=sync_wr_pointer[ADDRESS_WIDTH];
     for(m=ADDRESS_WIDTH-1;m>=0;m=m-1)begin 
     G_to_B_wr_pointer[m]<=G_to_B_wr_pointer[m+1]^sync_wr_pointer[m];
     end
     end
     
     // duel flip-flop cross domain synchronization for write operation
     /*
     always @(*)begin 
     sync_wr_pointer<=B_to_G_wr_pointer;
     end
     
     always @(*)begin 
     sync_rd_pointer<=B_to_G_rd_pointer;
     end
     
     */
     always @(posedge rd_clk)begin 
     sync_wr_pointer1<=B_to_G_wr_pointer;
     end
     always @(posedge rd_clk)begin 
     sync_wr_pointer<=sync_wr_pointer1;
     end
     
     // duel flip-flop cross domain synchronization for read operations
     always @(posedge wr_clk)begin 
     sync_rd_pointer1<=B_to_G_rd_pointer;
     end
     always @(posedge wr_clk)begin 
     sync_rd_pointer<=sync_rd_pointer1;
     end
     
     
endmodule
