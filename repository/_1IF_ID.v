`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _1IF_ID 
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _1IF_ID(
    input wire clk,
    input wire rst,
    input wire [31:0] IF_pc,
    input wire [31:0] IF_inst,
    input wire stall,

    output reg [31:0] ID_pc,
    output reg [31:0] ID_inst
    );

always @(posedge clk) begin
    if(rst) begin
        ID_pc <= 32'h80000000;
        ID_inst <= 1'b0;
    end
    else if (stall!=1) begin
        ID_pc <= IF_pc;
        ID_inst <= IF_inst;
    end
end

endmodule
