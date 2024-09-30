`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _2ID
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _2ID(
    input wire clk,
    input wire rst,
    input wire [31:0] pc,
    input wire [31:0] inst,

    output wire [4:0] readaddr1,
    output wire [4:0] readaddr2,
    output wire [4:0] writeaddr,
    output wire [4:0] aluop,
    output wire [31:0] imm,
    output wire [4:0] shamt,
    output wire memwrite,          //0:write disable       1:write enable
    output wire memread,           //0:read disable        1:read enable
    output wire regwrite,          //0:write disable       1:write enable
    output wire regread1,          //0:read disable        1:read enable
    output wire regread2,          //0:read disable        1:read enable
    output wire memtoreg,          //0:from ALU result     1:from MEM            x:memwrite=0
    output wire [2:0] branchtype,  //1:bne                 2:beq                 3:blez                4:bgtz          5:bltz
    output wire [1:0] pcsrc       //0:PC+4                 1:PC+4+BrAddr         2:JumpAddr            3:rs
    );

/*
opcode = inst [31:26]
rs = inst [25:21]
rt = inst [20:16]
rd = inst [15:11]
shamt = inst [10:6]
funct = inst [5:0]
imm = inst [15:0]
addr = inst [25:0]
*/

assign shamt     = (rst)? 5'b0
                   :inst[10:6];
assign readaddr1 = (rst)? 5'b0
                   :inst[25:21];//rs
assign readaddr2 = (rst)? 5'b0
                   :inst[20:16];//rt
assign writeaddr = (rst)? 5'b0
                   :(inst[31:26] == 6'h03 || (inst[31:26] == 6'h00 && inst[5:0] == 6'h09))? 5'b11111
                   :(inst[31:26] == 6'h00 && inst[5:0] != 6'h08)? inst[15:11]
                   :(inst[31:26] == 6'h0f || inst[31:26] == 6'h0d || inst[31:26] == 6'h23 || inst[31:26] == 6'h0c || inst[31:26] == 6'h09 || inst[31:26] == 6'h20 || inst[31:26] == 6'h08 || inst[31:26] == 6'h0e)? inst[20:16]
                   :5'b0;
assign aluop     = (rst)? 5'b0
                   :(inst[31:0] == 32'b0)? 5'b00000
                   :(inst[31:26] == 6'h00)? ((inst[5:0] == 6'h21)? 5'b00001
                                           :(inst[5:0] == 6'h25)? 5'b00010
                                           :(inst[5:0] == 6'h26)? 5'b00011
                                           :(inst[5:0] == 6'h00)? 5'b00100
                                           :(inst[5:0] == 6'h07)? 5'b11000
                                           :(inst[5:0] == 6'h02)? 5'b00101
                                           :(inst[5:0] == 6'h24)? 5'b00110
                                           :(inst[5:0] == 6'h08)? 5'b00111

                                           :(inst[5:0] == 6'h20)? 5'b10000
                                           :(inst[5:0] == 6'h22)? 5'b10001
                                           :(inst[5:0] == 6'h23)? 5'b10010
                                           :(inst[5:0] == 6'h27)? 5'b10011
                                           :(inst[5:0] == 6'h03)? 5'b10100
                                           :(inst[5:0] == 6'h2a)? 5'b10101
                                           :(inst[5:0] == 6'h2b)? 5'b10110
                                           :(inst[5:0] == 6'h09)? 5'b11010
                                           :5'b00000)

                   :(inst[31:26] == 6'h0f)? 5'b01000
                   :(inst[31:26] == 6'h0d)? 5'b01001
                   :(inst[31:26] == 6'h23)? 5'b01010
                   :(inst[31:26] == 6'h2b)? 5'b01011
                   :(inst[31:26] == 6'h0c)? 5'b01100
                   :(inst[31:26] == 6'h09)? 5'b01101
                   :(inst[31:26] == 6'h08)? 5'b01110
                   :(inst[31:26] == 6'h0e)? 5'b01111
                   :(inst[31:26] == 6'h02)? 5'b00000

                   :(inst[31:26] == 6'h0a)? 5'b11000
                   :(inst[31:26] == 6'h0b)? 5'b11001
                   :(inst[31:26] == 6'h03)? 5'b11010

                   :5'b00000;
assign imm       = (rst)? 32'b0
                   :(inst[31:26] == 6'h0f || inst[31:26] == 6'h0d || inst[31:26] == 6'h0c || inst[31:26] == 6'h0e)? {16'b0 , inst[15:0]}
                   :(inst[31:26] == 6'h23 || inst[31:26] == 6'h2b || inst[31:26] == 6'h09 || inst[31:26] == 6'h20 || inst[31:26] == 6'h28 || inst[31:26] == 6'h08 || inst[31:26] == 6'h0a || inst[31:26] == 6'h0b)? {{16{inst[15]}} , inst[15:0]}
                   :(inst[31:26] == 6'h05 || inst[31:26] == 6'h04 || inst[31:26] == 6'h06 || inst[31:26] == 6'h07 || inst[31:26] == 6'h01)? pc + 4 + {{14{inst[15]}} , inst[15:0], 2'b00}
                   :(inst[31:26] == 6'h02 || inst[31:26] == 6'h03)? {{{pc[31:28]}} , inst[25:0], 2'b00}
                   :32'b0;

assign memwrite  = (rst)? 1'b0
                   :((inst[31:26] == 6'h2b)? 1'b1 : 1'b0);
assign memread   = (rst)? 1'b0
                   :((inst[31:26] == 6'h23)? 1'b1 : 1'b0);
assign regwrite  = (rst)? 1'b0
                   :((inst[31:26] == 6'h05 || inst[31:26] == 6'h2b || inst[31:26] == 6'h04 || inst[31:26] == 6'h07 || inst[31:26] == 6'h01 || inst[31:26] == 6'h06
                   || inst[31:26] == 6'h02 || (inst[31:26] == 6'h00 && inst[5:0] == 6'h08))? 1'b0 : 1'b1);
assign regread1  = (rst)? 1'b0
                   :(inst[31:0] == 32'b0)? 1'b0
                   :((inst[31:26] == 6'h0f || (inst[31:26] == 6'h00 && (inst[5:0] == 6'h00 || inst[5:0] == 6'h02 || inst[5:0] == 6'h03)) || inst[31:26] == 6'h02 || inst[31:26] == 6'h03)? 1'b0 : 1'b1);
assign regread2  = (rst)? 1'b0
                   :(((inst[31:26] == 6'h00 && inst[5:0] != 6'h08 && inst[5:0] != 6'h09) || inst[31:26] == 6'h05 || inst[31:26] == 6'h2b || inst[31:26] == 6'h04 || inst[31:26] == 6'h0e)? 1'b1 : 1'b0);
assign memtoreg  = (rst)? 1'b0
                   :((inst[31:26] == 6'h23)? 1 : 0);
assign branchtype= (rst)? 3'b000
                   :(inst[31:26] == 6'h05)? 3'b001
                   :(inst[31:26] == 6'h04)? 3'b010
                   :(inst[31:26] == 6'h06)? 3'b011
                   :(inst[31:26] == 6'h07)? 3'b100
                   :(inst[31:26] == 6'h01)? 3'b101
                   :3'b000;
assign pcsrc     = (rst)? 2'b00
                   :((inst[31:26] == 6'h05 || inst[31:26] == 6'h04 || inst[31:26] == 6'h06 || inst[31:26] == 6'h07 || inst[31:26] == 6'h01)? 2'b01
                   :(inst[31:26] == 6'h02 || inst[31:26] == 6'h03)? 2'b10
                   :(inst[31:26] == 6'h00 && (inst[5:0] == 6'h08 || inst[5:0] == 6'h09))? 2'b11
                   :2'b00);

endmodule
