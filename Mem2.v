`timescale 1ns / 1ps
// r_nWb -> read/writebar
// addr -> address inputs
// in_data -> data inputs
// out_data -> RAM output

module MEM2(r_nWb, addr, in_data, out_data, rst);
input r_nWb, rst;
input [15:0] addr, in_data;
output reg [15:0] out_data=0;
reg [7:0] mem_data [0:127];

always@(rst or r_nWb or addr or in_data)
begin
if(rst)
//INICIALIZACION MEMORIA 
	begin
		//ADD TEST
		{mem_data[0], mem_data[1]} = 'h1201; //R0+R1-> R0,{R0=3, R1=1, R2=3, R3=4}
		//SUB TEST
		{mem_data[2], mem_data[3]} = 'h1301; //R0-R1->R0,{R0=1, R1=1, R2=3, R3=4}
		//MULT TEST
		{mem_data[4], mem_data[5]} = 'h1421; //R2*R1->R2,{R2=0, R1=6, R2=3, R3=4}
		//ORI TEST
		{mem_data[6], mem_data[7]} = 'h0A01; //R1 | imm -> R0
		{mem_data[8], mem_data[9]} = 'h0108; //{R0=h010E, R1=6, R2=3, R3=4}
		//ANDI TEST
		{mem_data[10], mem_data[11]} = 'h0C21; //R1 & imm ->R2
		{mem_data[12], mem_data[13]} = 'hFFAA; //{R0=h010E, R1=6, R2=h0002, R3=4}
		//BZ TEST1
		{mem_data[14], mem_data[15]} = 'h1461; //R6*R1->{R6=0,R1=0}, {R0=h010E, R1=0, R2=h0002, R3=4}
		{mem_data[16], mem_data[17]} = 'h2102; //BZ->L1
		{mem_data[18], mem_data[19]} = 'h1201; //R0+R1->R0, {R0=h010E, R1=0, R2=h0002, R3=4}
		{mem_data[20], mem_data[21]} = 'h1203; //L1: R0+R3->R0, {R0=h0112, R1=0, R2=h0002, R3=4}
		//BZ TEST2
		{mem_data[22], mem_data[23]} = 'h1430; //R3*R0->{R3=0,R0=448}, {R0=h0448, R1=0, R2=h0002, R3=0}
		{mem_data[24], mem_data[25]} = 'h2102; //BZ->L1
		{mem_data[26], mem_data[27]} = 'h1200; //R0+R0->R0, {R0=h0890, R1=0, R2=h0002, R3=0}
		{mem_data[28], mem_data[29]} = 'h1200; //L1: R0+R0->R0, {R0=h1120, R1=0, R2=h0002, R3=0}
		//J TEST
		{mem_data[30], mem_data[31]} = 'h1210; //R1+R0->R1=R0, {R0=h1120, R1=h1120, R2=h0002, R3=0}
		{mem_data[32], mem_data[33]} = 'h2400; //J
		{mem_data[34], mem_data[35]} = 'h002E; //J->46
		{mem_data[36], mem_data[37]} = 'h1200; //SALTANDO
		{mem_data[38], mem_data[39]} = 'h1200; //SALTANDO
		{mem_data[40], mem_data[41]} = 'h1200; //SALTANDO
		{mem_data[42], mem_data[43]} = 'h1200; //SALTANDO
		{mem_data[44], mem_data[45]} = 'h1200; //SALTANDO
		{mem_data[46], mem_data[47]} = 'h1200; //R0+R0->R0, {R0=h2240, R1=h1120, R2=h0002, R3=0}
		//NOP TEST
		{mem_data[48], mem_data[49]} = 'h0000; //PC+2->PC=h32
		{mem_data[50], mem_data[51]} = 'h0011; //PC+2->PC=h34
		{mem_data[52], mem_data[53]} = 'h00FF; //PC+2->PC=h36 (54)
		//SW TEST
		{mem_data[54], mem_data[55]} = 'h0274; //R7->M[R4 + imm], {R4=100, imm=2, R7=h0003}
		{mem_data[56], mem_data[57]} = 'h0002; //imm
		//LW TEST
		{mem_data[58], mem_data[59]} = 'h0454; //M[R4 + imm]->R5, {R4=100, imm=2, R5=h0003}
		{mem_data[60], mem_data[61]} = 'h0002; //imm
		{mem_data[62], mem_data[63]} = 'h1255; //R5+R5->R5, {R5=h0006}
		//ADDI TEST
		{mem_data[64], mem_data[65]} = 'h1532; //R2+imm->R3, {R2=h0002, imm=h0FFF, R3=h1001}
		{mem_data[66], mem_data[67]} = 'h0FFF; //imm
		//STP TEST
		{mem_data[68], mem_data[69]} = 'hFF00; //STOP, PC=h38 (56)
		{mem_data[70], mem_data[71]} = 'h00FF; //PC NO DEBE INCREMENTARSE, PC=h38 (56)
		//VALORES FINALES DE REGISTROS
		//{R0=h2240 ,R1=h1120 , R2=h0002 , R3=h1001 , R4=h0064 , R5=h0006 , R6=h0000 , R7=h0003 }
		
		//hig_mem
		{mem_data[100], mem_data[101]} = 'h0001;
		{mem_data[102], mem_data[103]} = 'h0000;//EN SW TEST, ESTE VALOR CAMBIA A h0003
		{mem_data[104], mem_data[105]} = 'h0004;
		{mem_data[106], mem_data[107]} = 'h0005;
		{mem_data[108], mem_data[109]} = 'h0006;
		{mem_data[110], mem_data[111]} = 'h0007;
	end	  
else
	begin
		if (r_nWb) out_data={mem_data[addr], mem_data[addr+1]};
		else {mem_data[addr], mem_data[addr+1]}=in_data;
	end
end	  
endmodule