
module d_mem(
	input [31:0] WriteData,Address,
	input MemWrite,MemRead,
	output reg [31:0] ReadData
);
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