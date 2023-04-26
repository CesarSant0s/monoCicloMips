// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module d_mem (writeData, address, memWrite, memRead, readData);
    //parametros
	parameter dataWidth = 32;
	parameter memorySize = 256;
	parameter addrWidth = 10;
    // in out
    input wire memWrite, memRead;
    input wire [31:0] address, writeData;
    output reg [31:0] readData;

    reg [dataWidth-1:0] memoria [memorySize-1:0] ;

    always @ (memWrite) begin
        if(memWrite == 1'b1) begin
            memoria[address] <= writeData;
        end 
    end    
    always @ (memRead) begin
        if (memRead == 1'b1) begin
            readData <= memoria[address];
        end
    end
endmodule