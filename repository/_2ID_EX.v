`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _2ID_EX
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _2ID_EX(
    input wire clk,
    input wire rst,
    input wire [4:0] ID_writeaddr,
    input wire [4:0] ID_aluop,
    input wire [31:0] ID_imm,
    input wire [4:0] ID_shamt,
    input wire ID_memwrite,
    input wire ID_memread,
    input wire ID_regwrite,
    input wire ID_memtoreg,
    input wire [31:0] ID_readdata1,
    input wire [31:0] ID_readdata2,
    input wire ID_worb,
    input wire stall,
    input wire [31:0] ID_pc,

    output reg [4:0] EX_writeaddr,
    output reg [4:0] EX_aluop,
    output reg [31:0] EX_imm,
    output reg [4:0] EX_shamt,
    output reg EX_memwrite,
    output reg EX_memread,
    output reg EX_regwrite,
    output reg EX_memtoreg,
    output reg [31:0] EX_swdata,
    output reg [31:0] EX_readdata1,
    output reg [31:0] EX_readdata2,
    output reg EX_worb,
    output reg [31:0] EX_pc
    );

always @(posedge clk) begin
    if(rst) begin
        EX_writeaddr <= 5'b0;
        EX_aluop <= 5'b0;
        EX_imm <= 32'b0;
        EX_shamt <= 5'b0;
        EX_memwrite <= 1'b0;
        EX_memread <= 1'b0;
        EX_regwrite <= 1'b0;
        EX_memtoreg <= 1'b0;
        EX_swdata <= 32'b0;
        EX_readdata1 <= 32'b0;
        EX_readdata2 <= 32'b0;
        EX_worb <= 1'b0;
        EX_pc <= 32'b0;
    end
    else if(stall) begin
        EX_writeaddr <= 5'b0;
        EX_aluop <= 5'b0;
        EX_imm <= 32'b0;
        EX_shamt <= 5'b0;
        EX_memwrite <= 1'b0;
        EX_memread <= 1'b0;
        EX_regwrite <= 1'b0;
        EX_memtoreg <= 1'b0;
        EX_swdata <= 32'b0;
        EX_readdata1 <= 32'b0;
        EX_readdata2 <= 32'b0;
        EX_worb <= 1'b0;
        EX_pc <= 32'b0;
    end
    else begin
        EX_writeaddr <= ID_writeaddr;
        EX_aluop <= ID_aluop;
        EX_imm <= ID_imm;
        EX_shamt <= ID_shamt;
        EX_memwrite <= ID_memwrite;
        EX_memread <= ID_memread;
        EX_regwrite <= ID_regwrite;
        EX_memtoreg <= ID_memtoreg;
        EX_swdata <= ID_readdata2;
        EX_readdata1 <= ID_readdata1;
        EX_readdata2 <= ID_readdata2;
        EX_worb <= ID_worb;
        EX_pc <= ID_pc;
    end
end

endmodule
