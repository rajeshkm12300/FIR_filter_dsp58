`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 06:48:17 PM
// Design Name: 
// Module Name: COORDIC_iteration
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


module CORDIC(
input [31:0] y,z,
input clk,
input [4:0] CHRVE,
output [31:0] sin, cos,arctan_y,sinh,cosh,arctanh_y,exp
//output reg [31:0] z_i_1,x_output,y_output,
//output reg [5:0]count,count1
    );
    reg [31:0] z_i_1,x_output,y_output;
    reg [5:0]count,count1;
    reg [31:0] tan_table [19:0],tanh_table[19:0];
    wire [31:0] x_in,y_in,floating_out,x_input,y_input,angle_input,x_in_,y_in_,floating_out_,sin_temp,cos_temp;
    wire input_sync,start,rotation;
    reg [31:0] x_in1,y_in1,floating_out1,x_start,y_start,angle_input_cast;
    reg [3:0] CAST;
    reg init_state,temp;
    reg [2:0]clock,anticlock;
    wire fpopmode_bit_i,overflow_o,underflow_o,invalid_o;
    integer i;
    initial begin
    count<=0;
    count1<=1;
    init_state<=0;
    clock<=0;
    anticlock<=0;
 
        tan_table[0]  = 32'b01000010001101000000000000000000; // 45.000000° //
        tan_table[1]  = 32'b01000001110101001001000010110100; // 26.565051° //
        tan_table[2]  = 32'b01000001011000001000110000000000; // 14.036243° //
        tan_table[3]  = 32'b01000000111001000000000000000000; // 7.125016°  //
        tan_table[4]  = 32'b01000000011001001101000000000000; // 3.576334°  //
        tan_table[5]  = 32'b00111111111001011100000000000000; // 1.789911°  //
        tan_table[6]  = 32'b00111111011001110000000000000000; // 0.895174°  //
        tan_table[7]  = 32'b00111110111001111000000000000000; // 0.447614°  //
        tan_table[8]  = 32'b00111110011001100000000000000000; // 0.223811°  //
        tan_table[9]  = 32'b00111101111001100000000000000000; // 0.111906°  //
        tan_table[10] = 32'b00111101011001010010111000000000; // 0.055953°  ///
        tan_table[11] = 32'b00111100111001010011000000000000; // 0.027977°  ///
        tan_table[12] = 32'b00111100011001010011010000000000; // 0.013989°  ///
        tan_table[13] = 32'b00111011111001010011100000000000; // 0.006995°  ///
        tan_table[14] = 32'b00111011011001010011000000000000; // 0.003497°  ///
        tan_table[15] = 32'b00111010111001010101000000000000; // 0.001749°  ///
        tan_table[16] = 32'b00111010011001010000000000000000; // 0.000874°  ///
        tan_table[17] = 32'b00111001111001010000000000000000; // 0.000437°  ///
        tan_table[18] = 32'b00111001011001100000000000000000; // 0.000219°  ///
        tan_table[19] = 32'b00111000111001000000000000000000; // 0.000109°  ///
    end
    
    
    initial begin
        tanh_table[0]  = 32'b00111111000011001001111101010100; // 0.5493061443
        tanh_table[1]  = 32'b00111110100000101100010101111000; // 0.2554128119
        tanh_table[2]  = 32'b00111110000000001010110001001001; // 0.1256572141
        tanh_table[3]  = 32'b00111101100000000010101011000100; // 0.0625815715
        tanh_table[4]  = 32'b00111101000000000000101010101100; // 0.0312601785 
        tanh_table[5]  = 32'b00111100100000000000001010101011; // 0.0156262718
        tanh_table[6]  = 32'b00111100000000000000000010101011; // 0.0078126590
        tanh_table[7]  = 32'b00111011100000000000000000101011; // 0.0039062699
        tanh_table[8]  = 32'b00111011000000000000000000001011; // 0.0019531275
        tanh_table[9]  = 32'b00111010100000000000000000000011; // 0.0009765628
        tanh_table[10] = 32'b00111010000000000000000000000001; // 0.0004882813
        tanh_table[11] = 32'b00111001011111111111111111111110; // 0.0002441406
        tanh_table[12] = 32'b00111000111111111111111111111110; // 0.0001220703
        tanh_table[13] = 32'b00111000100000000000000000000110; // 0.0000610352
        tanh_table[14] = 32'b00111000000000000000000000000110; // 0.0000305176
        tanh_table[15] = 32'b00110111100000000000000000000110; // 0.0000152588
        tanh_table[16] = 32'b00110111000000000000000000000110; // 0.0000076294
        tanh_table[17] = 32'b00110110100000000000000000000110; // 0.0000038147
        tanh_table[18] = 32'b00110101111111111111111001010100; // 0.0000019073
        tanh_table[19] = 32'b00110101100000000000000011100010; // 0.0000009537
    end
    assign sin_temp=(CHRVE[0])?((z != 32'b01000010101101000000000000000000)?((z!=0)?((count==20)?{y_output[31:23],(y_output[22:0]<<1)}:(0)):(0)):(32'b00111111100000000000000000000000)):(0);
    assign cos_temp=(CHRVE[0])?((z != 32'b01000010101101000000000000000000)?((z !=0)?((count==20)?({x_output[31:23],(x_output[22:0]<<1)}):(0)):(32'b00111111100000000000000000000000)):(0)):(0);
    assign sin=(~(|CAST[3:1]))?(sin_temp):(CAST[3])?({1'b1,cos_temp[30:0]}):(CAST[2])?({1'b1,sin_temp[30:0]}):((CAST[1])?(cos_temp):(0));
    assign cos=(~(|CAST[3:1]))?(cos_temp):(CAST[3])?(sin_temp):(CAST[2])?({1'b1,cos_temp[30:0]}):((CAST[1])?({1'b1,sin_temp[30:0]}):(0));
    assign arctan_y=(CHRVE[3])?((CHRVE[0])?((~(y==32'b00111111100000000000000000000000))?((count==20)?{z_i_1[31:23],(z_i_1[22:0]<<1)}:(0)):(32'b01000010001101000000000000000000)):(0)):(0);
    assign sinh=(CHRVE[1])?((CHRVE[2])?((count1==21)?({(y_output[31:23]),(y_output[22:0]<<1)}):(0)):(0)):(0);
    assign cosh=(CHRVE[1])?((CHRVE[2])?((count1==21)?({(x_output[31:23]),(x_output[22:0]<<1)}):(0)):(0)):(0);
    assign arctanh_y=(CHRVE[1])?((CHRVE[3])?((count1==21)?({(z_i_1[31:23]),(z_i_1[22:0]<<1)}):(0)):(0)):(0);
    assign start=(~CHRVE[1])?((~CHRVE[3])?((z == 32'b01000010101101000000000000000000)?(0):((z==0)?(0):(1))):((y==32'b00111111100000000000000000000000)?(0):(1))):(1);
    assign x_in=(count1 != 21)?(x_in1):((CHRVE[4])?(x_output):(0));
    assign y_in=(count1 != 21)?(y_in1):((CHRVE[4])?(y_output):(0));
    assign exp=(count1==21)?((CHRVE[4])?({floating_out[31:23],(floating_out[22:0]<<1)}):(0)):(0);
    assign input_sync=1;
    //assign x_input={x[31:23],1'b1,x[22:1]};
    assign x_input=(CHRVE[0])?((CHRVE[2])?(32'b00111111010011011001100110011010):((CHRVE[3])?(32'b00111111110000000000000000000000):(0))):(CHRVE[1]?((CHRVE[2])?(32'b00111111110011010100011110000100):(CHRVE[3]?(32'b00111111110000000000000000000000):(0))):(0));
    //assign y_input=y?{y[31:23],1'b1,y[22:1]}:(0);
    assign y_input=(CHRVE[0])?((CHRVE[2])?(0):((CHRVE[3])?((y)?({y[31:23],1'b1,y[22:1]}):(0)):(0))):((CHRVE[1])?((CHRVE[2])?(0):((CHRVE[3])?((y)?({y[31:23],1'b1,y[22:1]}):(0)):(0))):(0));
    //assign angle_input=(Angle != 0)?{Angle[31:23],1'b1,Angle[22:1]}:(0);
    assign angle_input=(~(|CAST[3:1]))?((CHRVE[0])?((CHRVE[2])?((z != 0)?{z[31:23],1'b1,z[22:1]}:(0)):((CHRVE[3])?(0):(0))):((CHRVE[1])?((CHRVE[2])?((z != 0)?{z[31:23],1'b1,z[22:1]}:(0)):((CHRVE[3])?(0):(0))):(0))):(floating_out_);
    assign rotation=(CHRVE[2])?(z_i_1[31]):((CHRVE[3])?(~(y_start[31]^x_start[31])):(0));
    assign x_in_=(CAST[3])?(32'b11000011110000111000000000000000):((CAST[2])?(32'b11000011010110100000000000000000):(CAST[1]?(32'b11000010110110100000000000000000):(0)));
    assign y_in_=CAST[3:1]?({z[31:23],1'b1,z[22:1]}):(0);
    assign fpopmode_bit_i=1;
    /*
    COORDIC_Addition_Unit ALU(
    .x(x_in),
    .y(y_in),
    .cnt_input(input_sync),
    .sum_output(floating_out)
    );
    */
    DSP1 DSP58(
    .clk_i(clk),//ce_i,rst_i;
    . fpopmode_bit_i(fpopmode_bit_i),
    .  x_i(x_in),
    . h_i(y_in),
    . y_o(floating_out),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o)
    
    );
    /*
    COORDIC_Addition_Unit T_CAST(
    .x(x_in_),
    .y(y_in_),
    .cnt_input(input_sync),
    .sum_output(floating_out_)
    );
    */
    DSP1 DSP58_CAST(
    .clk_i(clk),//ce_i,rst_i;
    . fpopmode_bit_i(fpopmode_bit_i),
    .  x_i(x_in_),
    . h_i(y_in_),
    . y_o(floating_out_),
    .invalid_o(invalid_o),
    .overflow_o(overflow_o),
    .underflow_o(underflow_o)
    
    );
    
    always@(*)begin
    if(CHRVE[0]&CHRVE[2])begin
    if(z<=32'b01000010101101000000000000000000)begin
    CAST[0]<=1;
    CAST[3:1]<=0;
    end
    else if(z<=32'b01000011001101000000000000000000)begin
    CAST[0]<=0;
    CAST[1]<=1;
    CAST[3:2]<=2'b00;
    end
    else if(z<=32'b01000011100001110000000000000000)begin
    CAST[0]<=0;
    CAST[1]<=0;
    CAST[2]<=1;
    CAST[3]<=0;
    end
    else if(z<=32'b01000011101101000000000000000000)begin
    CAST[2:0]<=0;
    CAST[3]<=1;
    end
    end
    else
    CAST=0;
    end
    
    
    
    always @(posedge clk)begin 
    $monitor("CAST=%b,sin=%b,cos=%b,input_angle=%b,exp=%b,x_input=%b,CHRVE=%b,rotation=%b,arctan_y=%b,angle=%b,x_start=%b,y_start=%b",CAST,sin,cos,angle_input,exp,x_input,CHRVE,rotation,arctanh_y,z_i_1,x_start,y_start);
    if(start)begin
    case(init_state)
    
    1'b0: begin 
            z_i_1<=angle_input;
            x_start<=x_input;
            y_start<=y_input;
            init_state<=1;
    
            end 
   1'b1: begin 
   
            //circular coordinate system
        if(CHRVE[0])begin
              if(count<20)begin
              case(rotation)
              
          1'b0: begin
                     case(clock)
                     
                     3'b000: begin
                             x_in1<=x_start;
                             y_in1<={(y_start[31]<=(y_start[31]==0?1'b1:1'b0)),y_start[30:23],(y_start[22:0]>>(count))}; 
                             //$display("x_start_temp=%b,y_start=%b",x_start_temp,y_start);
                             temp<=1;
                             if(temp)begin 
                             x_output<=floating_out;
                             //$display("x_output=%b",floating_out);
                             clock<=3'b001;
                             temp<=0;
                             end
                            end
                     3'b001: begin 
                              x_in1<={x_start[31],x_start[30:23],(x_start[22:0]>>(count))};
                              y_in1<=y_start; 
                            // $display("x_start_=%b,y_start_temp=%b",x_start,y_start_temp);
                              temp<=1;
                              if(temp)begin
                              y_output<=floating_out;
                             // $display("y_output=%b",floating_out);
                             
                              clock<=3'b010;
                              temp<=0;
                                end
                            end 
                      3'b010: begin 
                            x_in1<=z_i_1;
                            y_in1<={1'b1,tan_table[count][30:23],1'b1,tan_table[count][22:1]};
                           // $display("z_i_1=%b,y_in1=%b",z_i_1,tan_table[count]);
                            temp<=1;
                            if(temp)begin
                            z_i_1<=floating_out;
                           // $display("output=%b",floating_out);
                           y_start<=y_output;
                           x_start<=x_output;
                            clock<=3'b000;
                            temp<=0;
                            if(count<20)begin
                            count<=count+1;
                            end
                            end
                            end
                     
                     
                     endcase
                     end
         1'b1:begin
                     case(anticlock)
                     
                      3'b000: begin
                                x_in1<=x_start;
                                y_in1<={y_start[31],y_start[30:23],(y_start[22:0]>>(count))};
                                //$display("x,x_start_=%b,y_start_temp=%b,count=%b",x_start,y_start_temp,count);
                                temp<=1;
                                if(temp)begin
                                x_output<=floating_out;
                                // $display("x_output=%b",floating_out);
                                anticlock<=3'b001;
                                temp<=0;
                                end
                            end
                     3'b001: begin 
                                x_in1<={(x_start[31]<=(x_start[31]==0?1'b1:1'b0)),x_start[30:23],(x_start[22:0]>>(count))};
                                y_in1<=y_start;
                               // $display("y,x_start_=%b,y_start_temp=%b,count=%b",x_start,y_start_temp,count);
                                temp<=1;
                                if(temp)begin
                               // $display("y_output=%b",floating_out);
                                y_output<=floating_out;
                               
                                anticlock<=3'b010;
                                temp<=0;
                                end
                            end 
                      3'b010: begin 
                                x_in1<=z_i_1;
                                y_in1<={tan_table[count][31:23],1'b1,tan_table[count][22:1]};
                                temp<=1;
                                if(temp)begin
                                z_i_1<=floating_out;
                                anticlock<=3'b000;
                                temp<=0;
                                y_start<=y_output;
                                x_start<=x_output;
                                if(count<20)begin
                                 count<=count+1;
                                    end
                                end
                            end
                     
                     
                     endcase
                     end
   
                endcase
            end
            end
            
            // hyperbolic coordinate system
            if(CHRVE[1])begin
            
              if(count1<21)begin
              case(rotation)
              
          1'b0: begin
                     case(clock)
                     
                     3'b000: begin
                                 x_in1<=x_start;
                                y_in1<={y_start[31],y_start[30:23],(y_start[22:0]>>(count1))};
                          
                             //$display("x_start_temp=%b,y_start=%b",x_start_temp,y_start);
                             temp<=1;
                             if(temp)begin 
                             x_output<=floating_out;
                             //$display("x_output=%b",floating_out);
                             clock<=3'b001;
                             temp<=0;
                             end
                            end
                     3'b001: begin 
                              x_in1<={x_start[31],x_start[30:23],(x_start[22:0]>>(count1))};
                              y_in1<=y_start; 
                            // $display("x_start_=%b,y_start_temp=%b",x_start,y_start_temp);
                              temp<=1;
                              if(temp)begin
                              y_output<=floating_out;
                             // $display("y_output=%b",floating_out);       
                              clock<=3'b010;
                              temp<=0;
                                end
                            end 
                      3'b010: begin 
                            x_in1<=z_i_1;
                            y_in1<={1'b1,tanh_table[count1-1][30:23],1'b1,tanh_table[count1-1][22:1]};
                           // $display("z_i_1=%b,y_in1=%b",z_i_1,tan_table[count]);
                            temp<=1;
                            if(temp)begin
                            z_i_1<=floating_out;
                           // $display("output=%b",floating_out);
                           y_start<=y_output;
                           x_start<=x_output;
                            clock<=3'b000;
                            temp<=0;
                            if(count1<21)begin
                            count1<=count1+1;
                            end
                            end
                            end
                     
                     
                     endcase
                     end
         1'b1:begin
                     case(anticlock)
                     
                      3'b000: begin
                                  x_in1<=x_start;
                                  y_in1<={(y_start[31]<=(y_start[31]==0?1'b1:1'b0)),y_start[30:23],(y_start[22:0]>>(count1))}; 
                                //$display("x,x_start_=%b,y_start_temp=%b,count=%b",x_start,y_start_temp,count);
                                temp<=1;
                                if(temp)begin
                                x_output<=floating_out;
                                // $display("x_output=%b",floating_out);
                                anticlock<=3'b001;
                                temp<=0;
                                end
                            end
                     3'b001: begin 
                                x_in1<={(x_start[31]<=(x_start[31]==0?1'b1:1'b0)),x_start[30:23],(x_start[22:0]>>(count1))};
                                y_in1<=y_start;
                               // $display("y,x_start_=%b,y_start_temp=%b,count=%b",x_start,y_start_temp,count);
                                temp<=1;
                                if(temp)begin
                               // $display("y_output=%b",floating_out);
                                y_output<=floating_out;
                               
                                anticlock<=3'b010;
                                temp<=0;
                                end
                            end 
                      3'b010: begin 
                                x_in1<=z_i_1;
                                y_in1<={tanh_table[count1-1][31:23],1'b1,tanh_table[count1-1][22:1]};
                                temp<=1;
                                if(temp)begin
                                z_i_1<=floating_out;
                                anticlock<=3'b000;
                                temp<=0;
                                y_start<=y_output;
                                x_start<=x_output;
                                if(count1<21)begin
                                 count1<=count1+1;
                                    end
                                end
                            end
                     
                     
                     endcase
                     end
   
                endcase
            end
            
            
            end
            
            
            
       end
    endcase
    end
    end
    
endmodule
