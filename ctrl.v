// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module ctrl(input [5:0] Instruction, output reg RegWrite,MemWrite, output reg MemRead,MemtoReg, output reg RegDst, output reg ALUScr, output reg [1:0]ALUOp, output reg Branch, output reg selMuxPC2);
	always@(*) begin
		case(Instruction)
			0://tipo R
			begin
				ALUOp=2'b10;
				RegWrite=1;
				MemtoReg=1;
				ALUScr=0;
				RegDst=1;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end

			//Type J
			6'd2://J jump
			begin
				ALUOp=2'b00;
				RegWrite=0; 
				MemtoReg=1;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end

			//Type I
			6'd4://beq
			begin
				ALUOp=2'b01;
				RegWrite=0; 
				MemtoReg=1;
				ALUScr=0;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=1;
			end

			6'd8://addi 
			begin
				ALUOp=2'b00;
				RegWrite=1;
				MemtoReg=1;
				ALUScr=1; 
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end

			6'd10: //slti
			begin
				ALUOp=2'b10;
				RegWrite=1;
				MemtoReg=1;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
		
			end

			6'd9: //subi
			begin
				ALUOp=2'b10;
				RegWrite=1;
				MemtoReg=1;  
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
				
			end

			6'd12: //andi
			begin
				ALUOp=2'b10;
				RegWrite=1;
				MemtoReg=1;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end

			6'd13: //ori
			begin
				ALUOp=2'b10;
				RegWrite=1;
				MemtoReg=1;
				ALUScr=1; 
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end
			
            6'd14://xori
			begin
				ALUOp=2'b10;
				RegWrite=1;
				MemtoReg=1;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			
			end
			
            6'b100011: //lw
			begin
				ALUOp=2'b00;
				RegWrite=1;
				MemtoReg=0;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=1;
				Branch=0;
		
			end
			
            6'b101011://sw
			begin
				ALUOp=2'b00;
				RegWrite=0;
				MemtoReg=1;  
				ALUScr=1;
				RegDst=0;
				MemWrite=1;
				MemRead=0;
				Branch=0;
			
			end
			default:
            begin
				ALUOp=2'b11;
				RegWrite=0;
				MemtoReg=0;  
				ALUScr=0;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end
		endcase
	end
endmodule 