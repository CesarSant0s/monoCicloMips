
module ula
(
	input [31:0]In1,In2,
	input [3:0]OP,
	output [31:0]result,
	output reg Zero_flag
);

reg [31:0] o_result;
assign result =o_result;  // Aqui será enviado o valor da função escolhida

always @ (*)
begin	
case(OP)
	4'b0000:o_result= In1+In2; // soma
	4'b0001:o_result= In1-In2; // subtração
	4'b0010:o_result= In1*In2; // multiplicação
	4'b0011:o_result= In1/In2; // divisão
	4'b0100:o_result= In1&In2; // and
	4'b0101:o_result= In1|In2; // or
	4'b0110:o_result= In1^In2; // xor
	4'b0111:
	begin
		if(In1<In2)
		begin
			o_result=1;
		end
		else o_result=0;
	end
	4'b1000:o_result= In1%In2;
	default: o_result= 0; 
endcase
end
always@(o_result) begin
	if(o_result==0)Zero_flag=1;
	else Zero_flag=0;
end
endmodule 