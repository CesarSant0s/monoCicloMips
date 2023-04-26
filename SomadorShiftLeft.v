// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module SomadorShiftLeft(input [31:0]inSomador,inShiftLeft, output reg [31:0]out);
    always@(*) begin
        out=inSomador+(inShiftLeft <<2);
    end
    initial out=0;
endmodule 