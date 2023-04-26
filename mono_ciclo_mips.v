// Universidade Federal Rural de Pernambuco
// Curso: Licenciatura em Computação
// Disciplina: Arquitetura de Computadores
// Professor: Victor Coutinho
// Alunos: César Henrique, Kleyton Clementino, Huan Christopher
// Atividade Prática 2 VA

module mono_ciclo_mips (clk,resetRegFile, DR1, DR2, AluResul, FlagZero, instruction_memory_out,program_counter,ulaControlResult,
readAddr1_debug, readAddr2_debug, writeAddr_debug, writeData_debug, regWrite_debug);

	input clk, resetRegFile;

	output [31:0] DR1, DR2;
	output [31:0] AluResul;
	output FlagZero;
	output [31:0] instruction_memory_out;
    output [31:0] program_counter;
    output [3:0] ulaControlResult;
    output [4:0] readAddr1_debug, readAddr2_debug, writeAddr_debug;
    output [31:0] writeData_debug;
    output regWrite_debug;

    assign DR1 = readData1;
    assign DR2 = readData2;
    assign AluResul = ulaResult;
    assign FlagZero = zero_flag;
    assign instruction_memory_out = i_mem_out;
    assign program_counter = pcOut;

    assign ulaControlResult = ulaControlOut;
    assign readAddr1_debug = readAddr1; 
    assign readAddr2_debug = readAddr2; 
    assign writeAddr_debug = writeAddr; 
    assign writeData_debug = writeData; 
    assign regWrite_debug  = regWrite; 

	wire [31:0] pcOut;
	wire [31:0] i_mem_out;
    wire [31:0] entradaPc;

	// module PC (input [31:0] nextPC,input clock,output reg [31:0]PC);
	PC pc (entradaPc, clk, pcOut);

	wire [31:0] pcMais4Out;

	// module somador4(input [31:0]in, output reg [31:0]out);
	somador4 pcMais4 (pcOut, pcMais4Out);

	// module i_mem(input [31:0]address, output [31:0] i_out);
	i_mem instruction_memorie (pcOut,i_mem_out);

	wire [5:0] opCode;
    wire [4:0] readAddr1;
	wire [4:0] readAddr2;
    wire [4:0] rd_Inst;
    wire [15:0] extensorSinalIn;
    wire [5:0] aluFunc;
	
    assign opCode = i_mem_out[31:26];
	assign readAddr1 = i_mem_out[25:21];
	assign readAddr2 = i_mem_out[20:16];
	assign rd_Inst = i_mem_out[15:11];
    assign extensorSinalIn = i_mem_out[15:0];
    assign aluFunc = i_mem_out[5:0];

    wire [4:0] rt_Inst;
    assign rt_Inst = readAddr2;

	wire regWrite, memWrite;
	wire memRead, memtoReg;
	wire regDst;
	wire ALUScr;
	wire [1:0] ALUOp;
	wire branch;
	wire selMuxPC2;

	// module ctrl(input [5:0] Instruction, output reg RegWrite,MemWrite, output reg MemRead,MemtoReg, output reg RegDst, output reg ALUScr, output reg [3:0]ALUOp, output reg Branch, output reg selMuxPC2);
	ctrl controle (opCode, regWrite, memWrite, memRead, memtoReg, regDst, ALUScr, ALUOp, branch, selMuxPC2);

	wire [4:0] writeAddr;
    assign writeAddr = regDst ? rd_Inst : rt_Inst;

	wire [31:0] writeData;
	wire [31:0] readData1;
	wire [31:0] readData2;

	// module regfile(input [4:0] ReadAddr1,ReadAddr2,input [4:0] WriteAddr, input [31:0] WriteData,input RegWrite,input Clock,input Reset,output reg [31:0] ReadData1,ReadData2);
	regfile bancoDeRegistradores (readAddr1, readAddr2, writeAddr, writeData, regWrite, clk, resetRegFile, readData1, readData2);

	wire [31:0] extensorSinalOut;

	// module ExtSinal( input [15:0]in, output reg[31:0]out);
	ExtSinal extensorDeSinal (extensorSinalIn,extensorSinalOut);

	wire [31:0] somadorComShiftLeftOut;

	// module SomadorShiftLeft(input [31:0]inSomador,inShiftLeft, output reg [31:0]out);
	SomadorShiftLeft somadorComShiftLeft (pcMais4Out, extensorSinalOut, somadorComShiftLeftOut);

	wire branchFlag;
	assign branchFlag = branch & zero_flag;

    wire [31:0] mux1Out;
    assign mux1Out = branchFlag ? somadorComShiftLeftOut: pcMais4Out;
    assign entradaPc = mux1Out;

	wire [31:0] muxRegfile_ULA_Ext_out;
    assign muxRegfile_ULA_Ext_out = ALUScr ? extensorSinalOut : readData2;

    wire [3:0] ulaControlOut;
    assign aluFunc = i_mem_out[5:0];
    
	// module ALU_Control(input [1:0]ALUOp, input [5:0]Func, output reg[3:0] outUla);
	ALU_Control alu_Control_MOD (ALUOp, aluFunc, ulaControlOut);

	wire [31:0] ulaResult;
	wire zero_flag;

	// module ula (input [31:0]In1,In2, input [3:0]OP, output [31:0]result, output reg Zero_flag);
	ula ula_mod (readData1, muxRegfile_ULA_Ext_out, ulaControlOut, ulaResult, zero_flag);

	wire [31:0] readData;
	// module d_mem(input [31:0] WriteData,Address, input MemWrite,MemRead, output reg [31:0] ReadData );
	d_mem dataMemory(readAddr2, ulaResult, memWrite, memRead, readData);

    assign writeData = memtoReg ? readData : ulaResult ;

endmodule