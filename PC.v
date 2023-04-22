
module PC
(input [31:0] nextPC,
 input clock,
 output reg [31:0]PC);
always@(posedge clock)
begin
	PC = nextPC;
end
//initial clock=0;
endmodule 