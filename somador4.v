// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module somador4(input [31:0]in, output reg [31:0]out);
    always@(*) begin
        out=in+4;
    end
    initial out=0;
endmodule 