// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module i_mem(address, i_out);
    input [31:0] address;
	output reg [31:0] i_out ;
	
	reg [31:0] instructions [255:0];
	
	initial begin 
        $readmemb("instruction.list",instructions);
	end
	
	always @ (address) begin
		i_out  = instructions[address>>2];
	end
endmodule 