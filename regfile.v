// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module regfile(input [4:0] ReadAddr1,ReadAddr2,input [4:0] WriteAddr,	input [31:0] WriteData,input RegWrite,input Clock,input Reset,output [31:0] ReadData1,ReadData2);
    reg [31:0]registradores[31:0];

    assign ReadData1 = registradores[ReadAddr1];
    assign ReadData2 = registradores[ReadAddr2];

    always @(posedge Clock) begin
        if (RegWrite==1'b1)	
        begin		
            registradores[WriteAddr] <= WriteData;
        end
    end
endmodule 
