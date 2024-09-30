`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _4MEM
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _4MEM(
    input wire clk,
    input wire rst,
    input wire [31:0] aluresult,
    input wire memread,
    input wire memwrite,
    input wire [31:0] swdata,
    input wire [4:0] aluop,
    
    output wire [31:0] memaddr,
    output wire [31:0] memwritedata
    );

assign memaddr        = rst?32'b0
                       :(aluop == 5'b01010 || aluop == 5'b01011)?aluresult
                       :32'b0;
assign memwritedata   = rst?32'b0
                       :(memread || memwrite)? swdata
                       :32'b0;
endmodule
