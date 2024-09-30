`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _3EX
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _3EX(
    input wire clk,
    input wire rst,
    input wire [31:0] pc,
    input wire signed [31:0] readdata1,
    input wire signed [31:0] readdata2,
    input wire [31:0] imm,
    input wire [4:0] aluop,
    input wire [4:0] shamt,

    output wire [31:0] aluresult,
    output wire isload
    );

assign aluresult = rst? 31'b0
                  :(aluop == 5'b00001)? readdata1 + readdata2
                  :(aluop == 5'b00010)? readdata1 | readdata2
                  :(aluop == 5'b00011)? readdata1 ^ readdata2
                  :(aluop == 5'b00100)? readdata2 << shamt
                  :(aluop == 5'b11000)? readdata2 >>> readdata1 
                  :(aluop == 5'b00101)? readdata2 >> shamt
                  :(aluop == 5'b00110)? readdata1 & readdata2
                  :(aluop == 5'b00111)? readdata1

                  :(aluop == 5'b01000)? {imm[15:0] , 16'b0}
                  :(aluop == 5'b01001)? readdata1 | imm
                  :(aluop == 5'b01010)? readdata1 + imm
                  :(aluop == 5'b01011)? readdata1 + imm
                  :(aluop == 5'b01100)? readdata1 & imm
                  :(aluop == 5'b01101)? readdata1 + imm
                  :(aluop == 5'b01110)? readdata1 + imm
                  :(aluop == 5'b01111)? readdata1 ^ imm

                  :(aluop == 5'b10000)? readdata1 + readdata2
                  :(aluop == 5'b10001)? readdata1 - readdata2
                  :(aluop == 5'b10010)? readdata1 - readdata2
                  :(aluop == 5'b10011)? ~(readdata1 | readdata2)
                  :(aluop == 5'b10100)? readdata2 >>> shamt
                  :(aluop == 5'b10101)? readdata1 < readdata2
                  :(aluop == 5'b10110)? readdata1 < readdata2
                  :(aluop == 5'b10111)? readdata1
                  :(aluop == 5'b11010)? pc + 5'd8

                  :(aluop == 5'b11000)? readdata1 < imm
                  :(aluop == 5'b11001)? readdata1 < imm

 
                  :31'b0;
assign isload    = rst? 1'b0
                  :(aluop == 5'b01010)? 1'b1
                  :1'b0;
endmodule