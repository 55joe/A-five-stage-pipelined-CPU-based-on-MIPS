`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _4MEM_WB
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _4MEM_WB(
    input wire clk,
    input wire rst,
    input wire MEM_regwrite,
    input wire MEM_memtoreg,
    input wire [4:0] MEM_writeaddr,
    input wire [31:0] MEM_aluresult,
    input wire [31:0] MEM_memreaddata,
    input wire stall,

    output reg WB_regwrite,
    output reg WB_memtoreg,
    output reg [4:0] WB_writeaddr,
    output reg [31:0] WB_aluresult,
    output reg [31:0] WB_memreaddata
    );

always @(posedge clk) begin
    if(rst) begin
        WB_regwrite <= 1'b0;
        WB_memtoreg <= 1'b0;
        WB_writeaddr <= 5'b0;
        WB_aluresult <= 32'b0;
        WB_memreaddata <= 32'b0;
    end
    else begin
        WB_regwrite <= MEM_regwrite;
        WB_memtoreg <= MEM_memtoreg;
        WB_writeaddr <= MEM_writeaddr;
        WB_aluresult <= MEM_aluresult;
        WB_memreaddata <= MEM_memreaddata;
    end
end

endmodule
