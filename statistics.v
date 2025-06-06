module statistics(
    	input clk,
    	input reset,
    	input [5:0] op,
    	output reg [10:0] i,
    	output reg [10:0] r,
    	output reg [10:0] j,
	output reg [10:0] cnt_clk
);

    	wire is_i, is_r, is_j;

   	// i-type
    	assign is_i = ~is_r & ~is_j;

    	// R-type
    	assign is_r = (op == 6'b000000);

    	// J-type
    	assign is_j = (op == 6'b000010) || (op == 6'b000011);
	
    	always @(posedge clk or posedge reset) begin
    		if (reset) begin
    	        	i <= 0;
    	        	r <= 0;
    	        	j <= 0;
			cnt_clk <= 0;
    		end else begin
			cnt_clk <= cnt_clk + 1;
    	    		if (is_i) i <= i + 1;
    	        	if (is_r) r <= r + 1;
    	        	if (is_j) j <= j + 1;
    	    	end
    	end

endmodule