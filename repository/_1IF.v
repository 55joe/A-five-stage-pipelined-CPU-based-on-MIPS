`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: _1IF
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module _1IF(
    input wire clk,
    input wire rst,
    input wire jumpif,
    input wire [31:0] jumpaddr,
    input wire stall,

    output reg [31:0] pc //register pc
    );

always @(posedge clk) begin
    if(rst) begin
        pc <= 32'h00400000; //reset to default address
    end 
    else if (stall != 1) begin
        if(jumpif) begin
            pc <= jumpaddr;
        end
        else begin
            pc <= pc + 4'h4;
        end
    end
end

endmodule