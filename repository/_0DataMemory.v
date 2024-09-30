module _0DataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [31:0] Address    ,
	input  [31:0] Write_data ,
	output [31:0] Read_data
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 256;
	parameter RAM_SIZE_BIT  = 8;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];
	reg [7:0] num [3:0];

	// read data from RAM_data as Read_data
	assign Read_data = MemRead? Address == 32'h40000014 ? num[0]: Address == 32'h40000018 ? num[1]: Address == 32'h4000001c ? num[2]: Address == 32'h40000020 ? num[3] : RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)begin
		if (reset) begin
			RAM_data[0] <= 32'h00000014;

			RAM_data[1] <= 32'h000041A8;
			RAM_data[2] <= 32'h00003AF2;
			RAM_data[3] <= 32'h0000ACDA;
			RAM_data[4] <= 32'h00000C2B;
			RAM_data[5] <= 32'h0000B783;
			RAM_data[6] <= 32'h0000DAC9;
			RAM_data[7] <= 32'h00008ED9;
			RAM_data[8] <= 32'h000009FF;
			RAM_data[9] <= 32'h00002F44;
			RAM_data[10] <= 32'h0000044E;
			RAM_data[11] <= 32'h00009899;
			RAM_data[12] <= 32'h00003C56;
			RAM_data[13] <= 32'h0000128D;
			RAM_data[14] <= 32'h0000DBE3;
			RAM_data[15] <= 32'h0000D4B4;
			RAM_data[16] <= 32'h00003748;
			RAM_data[17] <= 32'h00003918;
			RAM_data[18] <= 32'h00004112;
			RAM_data[19] <= 32'h0000C399;
			RAM_data[20] <= 32'h00004955;

			for (i = 21; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
				
		end
		else if (MemWrite) begin
			if (Address == 32'h40000010)
			begin
			    num[0] <= Write_data[3:0];
			    num[1] <= Write_data[7:4];
			    num[2] <= Write_data[11:8];
			    num[3] <= Write_data[15:12];
			end
			else
			    RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end
			
endmodule
