module tb();
	
	reg clk;
	reg rst;
	
	_0TOP TOP(  
		.clk(clk), 
		.rst(rst)
	);
	
	initial begin
		rst = 0;
		clk = 1;
		#25000 rst = 1;
		#100 rst =0;
	end
	
	always #50 clk = ~clk;
		
endmodule

