`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _RegFile
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _RegFile(
    input wire clk,
    input wire rst,
    input wire regwrite,
    input wire [4:0] writeaddr,
    input wire [31:0] writedata,
    input wire regread1,
    input wire regread2,
    input wire [4:0] readaddr1,
    input wire [4:0] readaddr2,

    output wire [31:0] readdata1,
    output wire [31:0] readdata2,
    output wire [6:0] leds,
    output wire [3:0] an
    );

reg [31:0] registers[31:0];
integer i;

always @(posedge clk) begin
    if(rst) begin
        for(i = 0; i <= 31; i = i + 1) begin
            registers[i] <= 31'b0;
        end
    end
    else begin
        if(regwrite && writeaddr != 0) begin
            registers[writeaddr] <= writedata;
        end
    end
end

assign an = rst ? 4'b0
            :(registers[23] == 4'h1) ? 4'b0001
            :(registers[23] == 4'h2) ? 4'b0010
            :(registers[23] == 4'h3) ? 4'b0100
            :(registers[23] == 4'h4) ? 4'b1000
            :4'b0;

assign leds[0] = registers[16][0];
assign leds[1] = registers[17][0];
assign leds[2] = registers[18][0];
assign leds[3] = registers[19][0];
assign leds[4] = registers[20][0];
assign leds[5] = registers[21][0];
assign leds[6] = registers[22][0];

assign readdata1 = rst? 32'b0 
                   :(regread1)? ((regwrite && writeaddr == readaddr1) ? writedata 
                   :((readaddr1 == 0)? 32'b0 
                   :registers[readaddr1]))
                   :32'b0;
assign readdata2 = rst? 32'b0 
                   :(regread2)? ((regwrite && writeaddr == readaddr2) ? writedata 
                   :((readaddr2 == 0)? 32'b0 
                   :registers[readaddr2]))
                   :32'b0;

endmodule