
module mono_ciclo_mips (clk,out,resetRegFile);
	input clk, resetRegFile;
	output out;
	
    wire [31:0] pcOut;
    wire [31:0] nextPc;
    wire [31:0] i_mem_out;

    // module PC (input [31:0] nextPC,input clock,output reg [31:0]PC);
    PC pc (nextPc,clk,pcOut);

    wire [31:0] pcMais4Out;

    // module somador4(input [31:0]in, output reg [31:0]out);
    somador4 pcMais4 (pcOut, pcMais4Out);

    // module i_mem(input [31:0]address, output [31:0] i_out);
    i_mem instruction_memorie (pcOut,i_mem_out);

    wire [5:0] instruction;
    assign instruction = i_mem_out[31:26];

    wire regWrite, memWrite;
    wire memRead, memtoReg;
    wire regDst;
    wire ALUScr;
    wire [3:0] ALUOp;
    wire branch;
    wire selMuxPC2;

    // module ctrl(input [5:0] Instruction, output reg RegWrite,MemWrite, output reg MemRead,MemtoReg, output reg RegDst, output reg ALUScr, output reg [3:0]ALUOp, output reg Branch, output reg selMuxPC2);
    ctrl controle (instruction, regWrite, memWrite, memRead, memtoReg, regDst, ALUScr, ALUOp, branch, selMuxPC2);

    wire [4:0] readAddr1;
    wire [4:0] readAddr2;

    assign readAddr1 = i_mem_out[25:21];
    assign readAddr2 = i_mem_out[20:16];

    wire [4:0] rt_Inst;
    wire [4:0] rd_Inst;

    assign rt_Inst = readAddr2;
    assign rd_Inst = i_mem_out[15:11];

    wire [4:0] writeAddr;

    // module MuxIMem_Regfile( input [4:0] rt_Inst,rd_Inst, input RegDst, output reg[4:0] outRegfile);
    MuxIMem_Regfile mux0 (rt_Inst,rd_Inst, regDst, writeAddr);

    wire [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;

    // module regfile(input [4:0] ReadAddr1,ReadAddr2,input [4:0] WriteAddr, input [31:0] WriteData,input RegWrite,input Clock,input Reset,output reg [31:0] ReadData1,ReadData2);
    regfile bancoDeRegistradores (readAddr1, readAddr2, writeAddr, writeData, regWrite, clk, resetRegFile, readData1, readData2);

    wire [15:0] extensorSinalIn;
    wire [31:0] extensorSinalOut;

    assign extensorSinalIn = i_mem_out[15:0];

    // module ExtSinal( input [15:0]in, output reg[31:0]out);
    ExtSinal extensorDeSinal (extensorSinalIn,extensorSinalOut);

    wire [31:0] somadorComShiftLeftOut;

    // module SomadorShiftLeft(input [31:0]inSomador,inShiftLeft, output reg [31:0]out);
    SomadorShiftLeft somadorComShiftLeft (pcMais4Out, extensorSinalOut, somadorComShiftLeftOut);

    wire branchFlag;
    assign branchFlag = branch & zero_flag;

    //module MuxSomadorShiftLeft_somador4_PC(input [31:0] somadorShiftLeft,somador4,input controlSignal,output reg [31:0] nextPC);
    MuxSomadorShiftLeft_somador4_PC mux1 (somadorComShiftLeftOut, pcMais4Out, branchFlag, nextPC);

    wire [31:0] muxRegfile_ULA_Ext_out;
    // module MuxRegfile_ULA_Ext(input [31:0] ReadData2,inExtSinal,input ALUSrc,output reg [31:0] outULA);
    MuxRegfile_ULA_Ext mux2 (readData2,extensorSinalOut,ALUScr,muxRegfile_ULA_Ext_out);

    wire [5:0] aluFunc;
    wire [3:0] ulaControlOut;
    
    assign aluFunc = i_mem_out[5:0];

    // module ALU_Control(input [3:0]ALUOp, input [5:0]Func, output reg[3:0] outUla);
    ALU_Control alu_Control_MOD (ALUOp, aluFunc, ulaControlOut);

    wire [31:0] ulaResult;
    wire zero_flag;

    // module ula (input [31:0]In1,In2, input [3:0]OP, output [31:0]result, output reg Zero_flag);
    ula ula_mod (readData1, readData2, ulaControlOut, ulaResult, zero_flag);

    wire [31:0] readData;
    // module d_mem(input [31:0] WriteData,Address, input MemWrite,MemRead, output reg [31:0] ReadData );
    d_mem dataMemory(readAddr2, ulaResult, memWrite, memRead, readData);

    // module MuxDMem_Regfile_ULA(input [31:0] ReadData,ALUResult, input MemtoReg, output reg [31:0] outRegfile);
    MuxDMem_Regfile_ULA mux3 (readData, ulaResult, memtoReg, writeData);

endmodule

module ALU_Control(input [3:0]ALUOp, input [5:0]Func, output reg[3:0] outUla);
    always @(*) begin
        case(ALUOp)
            4'd0:outUla=0;//addi
            4'd1:outUla=1;//subi
            4'd2:outUla=4;//andi
            4'd3:outUla=5;//ori
            4'd4:outUla=6;//xori
            4'd5:outUla=7;//slti
            
            4'd8://se ALUOp=8 faz funções Func
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

module ctrl(input [5:0] Instruction, output reg RegWrite,MemWrite, output reg MemRead,MemtoReg, output reg RegDst, output reg ALUScr, output reg [3:0]ALUOp, output reg Branch, output reg selMuxPC2);
	always@(*) begin
		case(Instruction)
			0://tipo R
			begin
				ALUOp=4'b1000;
				RegWrite=0;
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
				ALUOp=0;
				RegWrite=1; 
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
				ALUOp=1;
				RegWrite=1; 
				MemtoReg=1;
				ALUScr=0;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=1;
			end

			6'd8://addi 
			begin
				ALUOp=0;
				RegWrite=0;
				MemtoReg=1;
				ALUScr=1; 
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end

			6'd10: //slti
			begin
				ALUOp=4'd5;
				RegWrite=0;
				MemtoReg=1;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
		
			end

			6'd9:		//subi
			begin
				ALUOp=1;
				RegWrite=0;
				MemtoReg=1;  
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
				
			end

			6'd12: //andi
			begin
				ALUOp=4'd2;
				RegWrite=0;
				MemtoReg=1;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end

			6'd13: //ori
			begin
				ALUOp=4'd3;
				RegWrite=0;
				MemtoReg=1;
				ALUScr=1; 
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			end
			
            6'd14://xori
			begin
				ALUOp=4'd4;
				RegWrite=0;
				MemtoReg=1;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=0;
				Branch=0;
			
			end
			
            6'b100011: //lw
			begin
				ALUOp=4'd0;
				RegWrite=0;
				MemtoReg=0;
				ALUScr=1;
				RegDst=0;
				MemWrite=0;
				MemRead=1;
				Branch=0;
		
			end
			
            6'b101011://sw
			begin
				ALUOp=4'd0;
				RegWrite=1;
				MemtoReg=1;  
				ALUScr=1;
				RegDst=0;
				MemWrite=1;
				MemRead=0;
				Branch=0;
			
			end
			default:ALUOp=4'b1111;
		endcase
	end
endmodule 

module d_mem(input [31:0] WriteData,Address, input MemWrite,MemRead, output reg [31:0] ReadData );
    reg [31:0]celula[1023:0];
    always@(Address)
    begin
        if(MemWrite && !MemRead)			//opção de escritura
        begin
            celula[Address]=WriteData;
        end 
        if(MemRead && !MemWrite)			//opção de leitura
        begin
            ReadData=celula[Address];
        end
    end
endmodule 

module i_mem(input [31:0]address, output [31:0] i_out);
    reg [31:0] result;
    reg [7:0]celula[320:0];
    assign i_out=result;
    always@(*)
    begin
        result[31:24]=celula[address];
        result[23:16]=celula[address +1];
        result[15:8]=celula[address+2];
        result[7:0]=celula[address+3];
    end
    initial begin
        $readmemb("instruction.list",celula);
    end
endmodule 

module PC (input [31:0] nextPC,input clock,output reg [31:0]PC);
    always@(posedge clock)
    begin
        PC = nextPC;
    end
    //initial clock=0;
endmodule 

module regfile(input [4:0] ReadAddr1,ReadAddr2,input [4:0] WriteAddr,	input [31:0] WriteData,input RegWrite,input Clock,input Reset,output reg [31:0] ReadData1,ReadData2);
    reg [31:0]celula[31:0];
    always @(*)
    begin
        if (RegWrite==0)	
        begin		
            celula[WriteAddr]=WriteData;
        end
        ReadData1=celula[ReadAddr1];
        ReadData2=celula[ReadAddr2];
    end
endmodule 

module ula (input [31:0]In1,In2, input [3:0]OP, output [31:0]result, output reg Zero_flag);
    reg [31:0] o_result;
    assign result =o_result;  // Aqui será enviado o valor da função escolhida

    always @ (*)begin	
        case(OP)
            4'b0000:o_result= In1+In2; // soma
            4'b0001:o_result= In1-In2; // subtração
            4'b0010:o_result= In1*In2; // multiplicação
            4'b0011:o_result= In1/In2; // divisão
            4'b0100:o_result= In1&In2; // and
            4'b0101:o_result= In1|In2; // or
            4'b0110:o_result= In1^In2; // xor
            4'b0111:
            begin
                if(In1<In2)
                begin
                    o_result=1;
                end
                else o_result=0;
            end
            4'b1000:o_result= In1%In2;
            default: o_result= 0; 
        endcase
    end

    always@(o_result) begin
        if(o_result==0)Zero_flag=1;
        else Zero_flag=0;
    end
endmodule 

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

module MuxDMem_Regfile_ULA(input [31:0] ReadData,ALUResult, input MemtoReg, output reg [31:0] outRegfile);
    always@(*) begin
        if(MemtoReg==0) outRegfile=ReadData;
        else outRegfile=ALUResult;
    end
endmodule 

module MuxIMem_Regfile( input [4:0] rt_Inst,rd_Inst, input RegDst, output reg[4:0] outRegfile);
    always @(*) begin
        if(RegDst == 1) outRegfile=rd_Inst;
        else outRegfile=rt_Inst;
    end
endmodule 

module MuxRegfile_ULA_Ext(input [31:0] ReadData2,inExtSinal,input ALUSrc,output reg [31:0] outULA);
    always@(*) begin
        if(ALUSrc==1) outULA=inExtSinal;
        else outULA=ReadData2;
    end
endmodule

module MuxSomadorShiftLeft_somador4_PC(input [31:0] somadorShiftLeft,somador4,input controlSignal,output reg [31:0] nextPC);
    always@(*) begin
        if(controlSignal==1) nextPC=somadorShiftLeft;
        else nextPC=somador4;
    end
endmodule

module somador4(input [31:0]in, output reg [31:0]out);
    always@(*) begin
        out=in+4;
    end
    initial out=0;
endmodule 

module SomadorShiftLeft(input [31:0]inSomador,inShiftLeft, output reg [31:0]out);
    always@(*) begin
        out=inSomador+(inShiftLeft <<2);
    end
    initial out=0;
endmodule 
