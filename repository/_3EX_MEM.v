`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _3EX_MEM
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _3EX_MEM(
    input wire clk,
    input wire rst,
    input wire [31:0] EX_aluresult,
    input wire [4:0] EX_writeaddr,
    input wire EX_memwrite,
    input wire EX_memread,
    input wire EX_regwrite,
    input wire EX_memtoreg,
    input wire [31:0] EX_swdata,
    input wire [4:0] EX_aluop,
    input wire stall,

    output reg [31:0] MEM_aluresult,
    output reg [4:0] MEM_writeaddr,
    output reg MEM_memwrite,
    output reg MEM_memread,
    output reg MEM_regwrite,
    output reg MEM_memtoreg,
    output reg [31:0] MEM_swdata,
    output reg [4:0] MEM_aluop
);

    always @(posedge clk) begin
        if (rst) begin
            MEM_aluresult <= 32'b0;
            MEM_writeaddr <= 5'b0;
            MEM_memwrite <= 1'b0;
            MEM_memread <= 1'b0;
            MEM_regwrite <= 1'b0;
            MEM_memtoreg <= 1'b0;
            MEM_swdata <= 32'b0;
            MEM_aluop <= 5'b0;
        end 
        else begin
            MEM_aluresult <= EX_aluresult;
            MEM_writeaddr <= EX_writeaddr;
            MEM_memwrite <= EX_memwrite;
            MEM_memread <= EX_memread;
            MEM_regwrite <= EX_regwrite;
            MEM_memtoreg <= EX_memtoreg;
            MEM_swdata <= EX_swdata;
            MEM_aluop <= EX_aluop;
        end
    end

endmodule