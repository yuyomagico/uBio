`timescale 1ns / 1ps
`define IDLE 		0
`define FETCH 		1
`define DECODE 	2
`define EXECUTE 	3
`define WBACK 		4
`define ADD 		8'h12
`define SUB 		8'h13
`define MUL 		8'h14
`define ADDI 		8'h15
`define BZ 			8'h21
`define BNZ 		8'h22
`define ORI 		8'h0A
`define ANDI 		8'h0C
`define SW 			8'h02
`define LW 			8'h04
`define J			8'h24
`define STP 		8'hFF
`define NOP 		8'h00
////////////////////////////////
//CPU uBio
////////////////////////////////
module uBio_full();
reg clk=0, rst=0;
reg [15:0] R[0:15];
reg [15:0] data_to_mem=0, opa=0, opb=0, iv16=0, address=0, pc=0;
reg [7:0] ri=0, alu_ctl=0;
reg [3:0] rai=0, rbi=0;
reg r_nWb=1;

wire [15:0] result, result2, data_from_mem;
wire [7:0] iv8;
wire [2:0] state;
wire Z, C, V, S, N;

////////////////////////////////
//SUBMODULOS
ALU ALU(opa, opb, iv16, alu_ctl, result, result2, C, V, Z, N);
CYCLE CYCLE(clk, rst, state, S);
MEM2 MEM2(r_nWb, address, data_to_mem, data_from_mem, rst);
////////////////////////////////

assign iv8={rai, rbi};
assign S=(ri==`STP);

always@(posedge clk or posedge rst)
begin
//INICIALIZACION DE REGISTROS PARA EL TEST
if(rst) begin 	R[0]<=1; R[1]<=2; R[2]<=3;
					R[3]<=4; R[4]<=100; R[5]<=0;
					R[6]<=0; R[7]<=3; R[8]<=0;
					R[9]<=0; R[10]<=0; R[11]<=0; 
					R[12]<=0; R[13]<=0; R[14]<=0; 
					R[15]<=0; pc<=0; address<=0;
					opa<=0; opb<=0;
					end
else
//COMPORTAMIENTO DE LA LOGICA
	begin
		case(state)
		`FETCH:	begin
					{rai, rbi}<=data_from_mem[7:0];
					ri<=data_from_mem[15:8];
					pc<=pc+2;
					address<=pc+2;
					end
		`DECODE:	begin
					case(ri)
					`ADD: begin opa<=R[rai]; opb<=R[rbi]; alu_ctl<=`ADD; end
					`SUB: begin opa<=R[rai]; opb<=R[rbi]; alu_ctl<=`SUB; end
					`MUL: begin opa<=R[rai]; opb<=R[rbi]; alu_ctl<=`MUL; end
					`ORI: begin opa<=R[rai]; opb<=R[rbi]; alu_ctl<=`ORI; iv16<=data_from_mem; pc<=pc+2; address<=pc+2; end
					`ANDI:begin opa<=R[rai]; opb<=R[rbi]; alu_ctl<=`ANDI; iv16<=data_from_mem; pc<=pc+2; address<=pc+2; end
					`ADDI:begin opa<=R[rai]; opb<=R[rbi]; alu_ctl<=`ADDI; iv16<=data_from_mem; pc<=pc+2; address<=pc+2; end
					`BZ:	begin pc<=Z?(pc + (iv8*2) - 2):pc; address<=Z?(pc + (iv8*2) - 2):pc; end
					`BNZ:	begin pc<=!Z?(pc + (iv8*2) - 2):pc; address<=Z?(pc + (iv8*2) - 2):pc; end
					`J:	begin iv16<=data_from_mem; end
					`NOP:	begin end
					`STP:	begin end
					`LW:	begin address<=data_from_mem+R[rbi]; pc<=pc+2; end
					`SW:	begin address<=data_from_mem+R[rbi]; pc<=pc+2; r_nWb<=0; end
					endcase
					end
		`EXECUTE:begin if(!r_nWb)data_to_mem<=R[rai]; end //ESPERAR CALCULOS DE LA ALU
		`WBACK:	begin 
					case(ri)
					`ADD: begin R[rai]<=result; end
					`SUB: begin R[rai]<=result; end
					`MUL: begin R[rbi]<=result; R[rai]<=result2; end
					`ORI: begin R[rai]<=result; end
					`ANDI:begin R[rai]<=result; end
					`ADDI:begin R[rai]<=result; end
					`BZ:	begin  end
					`BNZ:	begin  end
					`J:	begin pc<=(iv16 & 16'hFFFE); address<=(iv16 & 16'hFFFE); end
					`NOP:	begin  end
					`STP:	begin  end
					`LW:	begin R[rai]<=data_from_mem; address<=pc; end
					`SW:	begin r_nWb<=1; address<=pc;end
					endcase
				end
		endcase
	end
end

initial 
begin 
rst=0;#10;rst=1;#10;rst=0;#5;
end

always begin #10; clk=~clk; end
///////
endmodule