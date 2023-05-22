`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:31:57 05/22/2023 
// Design Name: 
// Module Name:    orgate 
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

module orgate_tb();
reg a,b;
wire c;
orgate DUT(.a(a),.b(b),.c(c));
initial begin 
$monitor("a=%b b=%b c=%b",a,b,c);
a=0;
b=0;
#10;
a=0;
b=1;
#10;
a=1;
b=0;
#10;
a=1;
b=1;
#10 $finish;
end 
endmodule
module orgate(a,b,c);
input a,b;
output c;
assign c= a | b;
endmodule