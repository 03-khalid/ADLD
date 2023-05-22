// Code your testbench here
// or browse Examples
module regfile_test;
reg [4:0] sr1, sr2, dr;
reg[31:0] wrData;
reg write, reset, clk;
wire [31:0] rdData1, rdData2;
integer k;
regbank_v4 REG (rdData1, rdData2, wrData, sr1, sr2, dr, write, reset, clk);
initial clk = 0;
always #5 clk = !clk;
initial
begin
$dumpfile ("regfile.vcd"); $dumpvars (0, regfile_test);
#1 reset = 1; write = 0;
#5 reset = 0;
end
  initial
begin
#7
for (k=0; k<32; k=k+1)
begin
dr = k; wrData = 10* k; write = 1;
#10 write = 0;
end
#20
for (k=0; k<32; k=k+2)
begin
sr1 = k; sr2 = k+1;
#5;
$display ("reg[%2d] = %d, reg[%2d] = %d", sr1, rdData1, sr2, rdData2);
end
#2000 $finish;
end
endmodule

module regbank_v4 (rdData1, rdData2, wrData, sr1, sr2, dr, write, reset, clk);
input clk, write, reset;
input [4:0] sr1, sr2, dr; // Source and destination registers
input [31:0] wrData;
output [31:0] rdData1, rdData2;
integer k;
reg [31:0] regfile[0:31];
assign rdData1 = regfile [sr1];
assign rdData2 = regfile [sr2];
  
  always @(posedge clk)
begin
if (reset) begin
for (k=0; k<32; k=k+1) begin
regfile[k] <= 0;
end
end
else begin
if (write)
regfile[dr] <= wrData;
end
end
endmodule
