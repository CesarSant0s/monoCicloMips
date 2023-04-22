
module i_mem(
	input [31:0]address,
	output [31:0] i_out
);
reg [31:0] result;
reg [7:0]celula[320:0];
assign i_out=result;
always@(*)
begin
	result[31:24]=celula[address];
	result[23:16]=celula[address +1];
	result[15:8]=celula[address+2];
	result[7:0]=celula[address+3];
end
initial begin
	$readmemb("instruction.list",celula);
end
endmodule 
