`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _0Main
// Description: 
// To-Do: 1.It seems ALUsrc signals are useless? Check it.
//////////////////////////////////////////////////////////////////////////////////


module _0Main(
    input wire clk,
    input wire rst,
    input wire [31:0] inst, //instruction from memory
    input wire [31:0] memreaddata, //data from memory
    
    output wire [31:0] pc, //pc address to memory
    output wire [31:0] memaddr, //address to memory(write&read)
    output wire [31:0] memwritedata, //data to memory
    output wire MEM_memread,
    output wire MEM_memwrite,
    output wire [6:0] leds,
    output wire [3:0] an
    );

//Stage1: IF
wire stall;
wire jumpif;
wire [31:0] jumpaddr;

_1IF IF(
    .clk(clk),
    .rst(rst),
    .jumpif(jumpif),
    .jumpaddr(jumpaddr),
    .stall(stall),

    .pc(pc)
    );

wire [31:0] ID_pc;
wire [31:0] ID_inst;

_1IF_ID IF_ID(
    .clk(clk),
    .rst(rst),
    .IF_pc(pc),
    .IF_inst(inst),
    .stall(stall),

    .ID_pc(ID_pc),
    .ID_inst(ID_inst)
    );
    
//Stage2: ID
wire [4:0] readaddr1;
wire [4:0] readaddr2;
wire [4:0] writeaddr;
wire [4:0] aluop;
wire [31:0] imm;
wire [4:0] shamt;
wire regwrite;
wire regread1;
wire regread2;
wire memtoreg;
wire memread;
wire memwrite;
wire [2:0] branchtype;
wire [1:0] pcsrc;

_2ID ID(
    .clk(clk),
    .rst(rst),
    .pc(ID_pc),
    .inst(ID_inst),

    .readaddr1(readaddr1),
    .readaddr2(readaddr2),
    .writeaddr(writeaddr),
    .aluop(aluop),
    .imm(imm),
    .shamt(shamt),
    .memwrite(memwrite),
    .memread(memread),
    .regwrite(regwrite),
    .regread1(regread1),
    .regread2(regread2),
    .memtoreg(memtoreg),
    .branchtype(branchtype),
    .pcsrc(pcsrc)
    );
    
wire WB_regwrite;
wire [4:0] WB_writeaddr;
wire [31:0] readdata1;
wire [31:0] readdata2;
wire [31:0] writedata;

_RegFile RegFile(
    .clk(clk),
    .rst(rst),
    .regwrite(WB_regwrite),
    .writeaddr(WB_writeaddr),
    .writedata(writedata),
    .regread1(regread1),
    .regread2(regread2),
    .readaddr1(readaddr1),
    .readaddr2(readaddr2),

    .readdata1(readdata1),
    .readdata2(readdata2),
    .leds(leds),
    .an(an)
    );

wire isload;
wire [31:0] ID_regreaddata1;
wire [31:0] ID_regreaddata2;
wire stall_load;

wire [4:0] EX_writeaddr;
wire EX_regwrite;
wire [31:0] MEM_aluresult;
wire [4:0] MEM_writeaddr;
wire MEM_regwrite;
wire [31:0] aluresult;
wire MEM_memtoreg;

_2ID_forward ID_forward(
    .clk(clk),
    .rst(rst),
    .ID_regread1(regread1),
    .ID_regreadaddr1(readaddr1),
    .ID_regreaddata10(readdata1),
    .ID_regread2(regread2),
    .ID_regreadaddr2(readaddr2),
    .ID_regreaddata20(readdata2),
    .EX_MEM_regwrite(EX_regwrite),
    .EX_MEM_regwriteaddr(EX_writeaddr),
    .EX_MEM_regwritedata(aluresult),
    .MEM_WB_regwrite(MEM_regwrite),
    .MEM_WB_regwriteaddr(MEM_writeaddr),
    .MEM_WB_aluresult(MEM_aluresult),
    .MEM_WB_memreaddata(memreaddata),
    .MEM_WB_memtoreg(MEM_memtoreg),
    .isload(isload),

    .ID_regreaddata1(ID_regreaddata1),
    .ID_regreaddata2(ID_regreaddata2),
    .stall(stall_load)
    );
    
_2ID_jump ID_jump(
    .clk(clk),
    .rst(rst),
    .branchtype(branchtype),
    .readdata1(ID_regreaddata1),
    .readdata2(ID_regreaddata2),
    .pcsrc(pcsrc),
    .imm(imm),

    .jumpif(jumpif),
    .jumpaddr(jumpaddr)
    );
    
wire [4:0] EX_aluop;
wire [31:0] EX_imm;
wire [4:0] EX_shamt;
wire EX_memwrite;
wire EX_memread;
wire EX_memtoreg;
wire [1:0] EX_pcsrc;
wire [31:0] EX_swdata;
wire [31:0] EX_readdata1;
wire [31:0] EX_readdata2;
wire [31:0] EX_pc;

_2ID_EX ID_EX(
    .clk(clk),
    .rst(rst),
    .ID_writeaddr(writeaddr),
    .ID_aluop(aluop),
    .ID_imm(imm),
    .ID_shamt(shamt),
    .ID_memwrite(memwrite),
    .ID_memread(memread),
    .ID_regwrite(regwrite),
    .ID_memtoreg(memtoreg),
    .ID_readdata1(ID_regreaddata1),
    .ID_readdata2(ID_regreaddata2),
    .stall(stall),
    .ID_pc(ID_pc),

    .EX_writeaddr(EX_writeaddr),
    .EX_aluop(EX_aluop),
    .EX_imm(EX_imm),
    .EX_shamt(EX_shamt),
    .EX_memwrite(EX_memwrite),
    .EX_memread(EX_memread),
    .EX_regwrite(EX_regwrite),
    .EX_memtoreg(EX_memtoreg),
    .EX_swdata(EX_swdata),
    .EX_readdata1(EX_readdata1),
    .EX_readdata2(EX_readdata2),
    .EX_pc(EX_pc)
    );

//Stage3: EX
wire [31:0] pcbranch;

_3EX EX(
    .clk(clk),
    .rst(rst),
    .readdata1(EX_readdata1),
    .readdata2(EX_readdata2),
    .imm(EX_imm),
    .aluop(EX_aluop),
    .shamt(EX_shamt),
    .pc(EX_pc),

    .aluresult(aluresult),
    .isload(isload)
    );
    
wire MEM_branch;
wire [31:0] MEM_swdata;
wire [4:0] MEM_aluop;

_3EX_MEM EX_MEM(
    .clk(clk),
    .rst(rst),
    .EX_aluresult(aluresult),
    .EX_writeaddr(EX_writeaddr),
    .EX_memwrite(EX_memwrite),
    .EX_memread(EX_memread),
    .EX_regwrite(EX_regwrite),
    .EX_memtoreg(EX_memtoreg),
    .EX_swdata(EX_swdata),
    .EX_aluop(EX_aluop),
    .stall(stall),

    .MEM_aluresult(MEM_aluresult),
    .MEM_writeaddr(MEM_writeaddr),
    .MEM_memwrite(MEM_memwrite),
    .MEM_memread(MEM_memread),
    .MEM_regwrite(MEM_regwrite),
    .MEM_memtoreg(MEM_memtoreg),
    .MEM_swdata(MEM_swdata),
    .MEM_aluop(MEM_aluop)
    );
    
//Stage4: MEM
_4MEM MEMM(
    .clk(clk),
    .rst(rst),
    .aluresult(MEM_aluresult),
    .memread(MEM_memread),
    .memwrite(MEM_memwrite),
    .swdata(MEM_swdata),
    .aluop(MEM_aluop),

    .memaddr(memaddr),
    .memwritedata(memwritedata)
    );

wire WB_memtoreg;
wire [31:0] WB_memreaddata;
wire [31:0] WB_aluresult;

_4MEM_WB MEM_WB(
    .clk(clk),
    .rst(rst),
    .MEM_regwrite(MEM_regwrite),
    .MEM_memtoreg(MEM_memtoreg),
    .MEM_writeaddr(MEM_writeaddr),
    .MEM_aluresult(MEM_aluresult),
    .MEM_memreaddata(memreaddata),
    .stall(stall),
    
    .WB_regwrite(WB_regwrite),
    .WB_memtoreg(WB_memtoreg),
    .WB_writeaddr(WB_writeaddr),
    .WB_aluresult(WB_aluresult),
    .WB_memreaddata(WB_memreaddata)
);

_stall stalll(
    .clk(clk),
    .rst(rst),
    .stall_load(stall_load),

    .stall(stall)
    );

//Stage5: WB
assign writedata = (WB_memtoreg)? WB_memreaddata: WB_aluresult;

endmodule
