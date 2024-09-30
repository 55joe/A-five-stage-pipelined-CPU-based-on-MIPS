`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _2ID_forward
// Description:
//////////////////////////////////////////////////////////////////////////////////


module _2ID_forward(
    input wire clk,
    input wire rst,
    input wire ID_regread1,
    input wire [4:0] ID_regreadaddr1,
    input wire [31:0] ID_regreaddata10,
    input wire ID_regread2,
    input wire [4:0] ID_regreadaddr2,
    input wire [31:0] ID_regreaddata20,
    input wire EX_MEM_regwrite,
    input wire [4:0] EX_MEM_regwriteaddr,
    input wire [31:0] EX_MEM_regwritedata,
    input wire MEM_WB_regwrite,
    input wire [4:0] MEM_WB_regwriteaddr,
    input wire [31:0] MEM_WB_aluresult,
    input wire [31:0] MEM_WB_memreaddata,
    input wire MEM_WB_memtoreg,
    input wire isload,

    output wire [31:0] ID_regreaddata1,
    output wire [31:0] ID_regreaddata2,
    output wire stall
    );

assign stall = isload && ((EX_MEM_regwrite && ID_regread1 && EX_MEM_regwriteaddr == ID_regreadaddr1) || (EX_MEM_regwrite && ID_regread2 && EX_MEM_regwriteaddr == ID_regreadaddr2));
assign ID_regreaddata1 = rst? 31'b0
                        :(EX_MEM_regwrite && ID_regread1 && EX_MEM_regwriteaddr == ID_regreadaddr1) ? EX_MEM_regwritedata
                        :(MEM_WB_regwrite && ID_regread1 && MEM_WB_regwriteaddr == ID_regreadaddr1) ? ((MEM_WB_memtoreg)? MEM_WB_memreaddata: MEM_WB_aluresult)
                        :ID_regreaddata10;
assign ID_regreaddata2 = rst? 31'b0
                        :(EX_MEM_regwrite && ID_regread2 && EX_MEM_regwriteaddr == ID_regreadaddr2) ? EX_MEM_regwritedata
                        :(MEM_WB_regwrite && ID_regread2 && MEM_WB_regwriteaddr == ID_regreadaddr2) ? ((MEM_WB_memtoreg)? MEM_WB_memreaddata: MEM_WB_aluresult)
                        :ID_regreaddata20;

endmodule
