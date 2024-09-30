`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _2ID_jump
// Description:
//////////////////////////////////////////////////////////////////////////////////


module _2ID_jump(
    input wire clk,
    input wire rst,
    input wire [2:0] branchtype,
    input wire [31:0] readdata1,
    input wire [31:0] readdata2,
    input wire [1:0] pcsrc,
    input wire [31:0] imm,

    output wire jumpif,
    output wire [31:0] jumpaddr
    );

assign jumpif = rst? 1'b0
               :(pcsrc == 2'b01)? 
               (((branchtype == 3'b001 && readdata1 != readdata2) || 
               (branchtype == 3'b010 && readdata1 == readdata2) || 
               (branchtype == 3'b011 && readdata1 <= 0) ||
               (branchtype == 3'b100 && readdata1 > 0) ||
               (branchtype == 3'b101 && readdata1 < 0))? 1'b1: 1'b0)
               :((pcsrc == 2'b10 || pcsrc == 2'b11)? 1'b1: 1'b0);
assign jumpaddr = (pcsrc == 2'b01)? 
               (((branchtype == 3'b001 && readdata1 != readdata2) || 
               (branchtype == 3'b010 && readdata1 == readdata2) || 
               (branchtype == 3'b011 && readdata1 <= 0) ||
               (branchtype == 3'b100 && readdata1 > 0) ||
               (branchtype == 3'b101 && readdata1 < 0))? (imm): 32'b0)
               :((pcsrc == 2'b10)? (imm): (pcsrc == 2'b11)? (readdata1): 32'b0);

endmodule
