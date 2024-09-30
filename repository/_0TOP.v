`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _0TOP
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _0TOP(
    input wire clk,
    input wire rst,

	output wire [6:0] leds,
	output wire [3:0] an
    );

wire [31:0] inst;
wire [31:0] memreaddata;
wire [31:0] pc;
wire [31:0] memaddr;
wire [31:0] memwritedata;
wire memread;
wire memwrite;
wire clk_out;
wire locked;
wire reset;

	clk_wiz_0 clkwiz(
		.clk_out1(clk_out),
		.reset(reset),
		.locked(locked),
		.clk_in1(clk)
	);


_0Main Main (
    .clk(clk_out),
    .rst(rst),
    .inst(inst),
    .memreaddata(memreaddata),
    .pc(pc),
    .memaddr(memaddr),
    .memwritedata(memwritedata),
	.MEM_memread(memread),
	.MEM_memwrite(memwrite),
	.leds(leds),
	.an(an)
);

_0InstructionMemory InstructionMemory(
	.Address(pc), 
	.Instruction(inst)
);

_0DataMemory DataMemory(
	.reset(rst), 
	.clk(clk_out),  
	.MemRead(memread),
	.MemWrite(memwrite),
	.Address(memaddr),
	.Write_data(memwritedata),
	.Read_data(memreaddata)
);

endmodule
