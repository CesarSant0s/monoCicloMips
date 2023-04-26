// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module PC (input [31:0] nextPC,input clock,output reg [31:0]PC);
    always@(posedge clock)
    begin
        PC = nextPC;
    end
endmodule 
