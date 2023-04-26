// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module ALU_Control(input [1:0]ALUOp, input [5:0]Func, output reg[3:0] outUla);
    always @(*) begin
        case(ALUOp)
            2'b00:outUla=4'b0000;//addi
            2'b01:outUla=4'b0001;//subi
            2'b10:
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