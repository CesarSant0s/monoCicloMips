// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module ExtSinal( input [15:0]in, output reg[31:0]out);
    always@(*) begin
        if(in[15]==1)
        begin
            out[31:16]=16'd65535;
            out[15:0]=in;
        end
        else
        begin
            out[31:16]=16'd0;
            out[15:0]=in;
        end
    end
endmodule 