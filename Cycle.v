`timescale 1ns / 1ps
////////////////////////////////
//CYCLE uBio
////////////////////////////////
`define IDLE 0
`define FETCH 1
`define DECODE 2
`define EXECUTE 3
`define WBACK 4
module CYCLE(clk, reset, state, S);

input clk, reset, S; 
output reg [2:0] state=0;

always@(posedge clk or posedge reset)
begin
	if (reset) state <= `IDLE;
	else if (S) state <= `IDLE;
	else 
		case(state)
		`FETCH: state <= `DECODE;
		`DECODE: state <= `EXECUTE;
		`EXECUTE: state <= `WBACK;
		`WBACK: state <= `FETCH;
		default: state <= `FETCH;
		endcase
end

endmodule