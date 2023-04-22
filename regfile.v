
module regfile(
	input [4:0] ReadAddr1,ReadAddr2,//direcionado à leitura
	input [4:0] WriteAddr,	//direcionado à escrita
	input [31:0] WriteData,
	input RegWrite,
	input Clock,
	input Reset,
	output reg [31:0] ReadData1,ReadData2
);
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