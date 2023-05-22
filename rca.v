`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:33:24 05/22/2023 
// Design Name: 
// Module Name:    rca 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module rca_tb();
reg [3:0]x;
reg [3:0]y;
reg ci;
wire [3:0]s;
wire co;
rca DUT(.x(x),.y(y),.ci(ci),.s(s),.co(co));
initial begin 
$monitor("x=%b y=%b ci=%b s=%b co=%b",x,y,ci,s,co);
x = 4'b0001;
y = 4'b0010;
ci=1'b0;    
# 100$finish;                                                                                                                                                                                                                                                                                                                                                  
end 
endmodule

module rca(x,y,s,ci,co);
input[3:0]x,y;
input ci;
output[3:0]s;
output co;
wire w1,w2,w3;
fulladder u1(x[0],y[0],ci,s[0],w1);
fulladder u2(x[1],y[1],w1,s[1],w2);
fulladder u3(x[2],y[2],w2,s[2],w3);
fulladder u4(x[3],y[3],w3,s[3],co);
endmodule


module fulladder(x,y,ci,s,co);
input x,y,ci;
output s,co;
wire w1,w2,w3;
xor g1(w1,x,y);
xor g2(s,w1,ci);
and g3(w2,w1,ci);
and g4(w3,x,y);
or g5(co,w2,w3);
endmodule


