
module car;
reg clk,pw;
wire out;

car TBV(out,pw,clk);
always #5 clk = ~clk;

initial begin
#5 clk = 1'b0;
#10 pw=  3'b0001;
end
initial begin
  $display ($time,"pw: %b", out);
  end
endmodule

module car(out,pw,clk);
input clk;
input [3:0]pw;
output out;
parameter state0=0,state1=1;
reg curstate, nextstate;
reg Frontsensor, Backsensor;

always @(posedge clk)
begin
case(curstate)
s0: if(pw == 3'b0001)
begin
nextstate <= state0;
out <= Backsensor;  // correct pw
end
else
begin
nextstate <= s1;
out <= Frontsensor; // need to reenter the pw
end
state1:if(pw == 3'b0000)
begin
nextstate <= state1;
out <= Frontsensor;  // need to reenter the pw
end
else
begin
nextstate <= state0;
out <= Backsensor; // correct pw
end
default: begin
nextstate <= state1; //by default pw is correct and backsensor indicates car is parked
out=Backsensor;
end

endcase

end
endmodule






