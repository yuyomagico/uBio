`timescale 1ns / 1ps
////////////////////////////////
//ALU uBio
////////////////////////////////
`define ADD 		8'h12
`define SUB 		8'h13
`define MUL 		8'h14
`define ORI 		8'h0A
`define ANDI 		8'h0C
`define NOP 		8'h00
`define ADDI 		8'h15

module ALU(opa, opb, iv16, alu_ctl, result, result2, C, V, Z, N);
input [15:0] opa, opb, iv16;
input [7:0] alu_ctl;
output reg [15:0] result=0, result2=0;
output reg C=0, V=0, Z=0, N=0;

always@(*)
begin
	case(alu_ctl)
		`ADD: begin
				result=opa+opb;
				C=(opa>=0 && opb>=0) ? !result[15] & (opa[15] ^ opb[15]) | (opa[15] & opb[15]):0;
				V=0;//al ser suma la primera pregunta no va yo creo, pq siempre seran positivos, si no lo toma como resta.
				Z = (result==0);
				N = result[15];
				end
		`SUB: begin
				result = opa - opb;
				V = (opa[15] & opb[15] & ~result[15]) | ~(opa[15] & opb[15]) & result[15] ;
				C = 0;// carry se da solo en unsigned(suma), el overflow se da en signed
				Z = (result==0);
				N = result[15];
				end
		`MUL: begin
				{result2, result}= opa * opb;
				{C, V} = 0;
				Z = (result==0);
				N = (opa[15]) || (opb[15]);	
				end
		`ORI:	begin
				result = opb | iv16;
				{C, V, N, Z} = 0;
				end
		`ANDI:begin
				result = opb & iv16;
				{C, V, N, Z} = 0;
				end		
		`ADDI:begin
				result = opb + iv16;
				C=(iv16>=0 && opb>=0) ? !result[15] & (iv16[15] ^ opb[15]) | (iv16[15] & opb[15]):0;
				V=0;//al ser suma la primera pregunta no va yo creo, pq siempre seran positivos, si no lo toma como resta.
				Z = (result==0);
				N = result[15];
				end
		default: begin end
	endcase
end
//initial begin #10;alu_ctl=`ADD; #10;opa=10; #5; opb=5; #10; alu_ctl=`MUL; end
endmodule