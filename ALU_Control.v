module ALU_Control(
	input [3:0]ALUOp,
	input [5:0]Func,
	output reg[3:0] outUla
);
always @(*)
begin
	case(ALUOp)
		4'd0:outUla=0;//addi
		4'd1:outUla=1;//subi
		4'd2:outUla=4;//andi
		4'd3:outUla=5;//ori
		4'd4:outUla=6;//xori
		4'd5:outUla=7;//slti
		
		4'd8://se ALUOp=8 faz funções Func
		begin
			case(Func)
				6'd0:outUla=0;//add
				6'd2:outUla=1;//sub
				6'd8:outUla=2;//mult
				6'b011010:outUla=3;//div
				6'd4:outUla=4;//and
				6'd5:outUla=5;//or
				6'd6:outUla=6;//xor
				6'b101010:outUla=7;//slt
				6'd7:outUla=8;//mod
				default:outUla=0;
			endcase
		end
		default:outUla=0;
	endcase		
end
endmodule 