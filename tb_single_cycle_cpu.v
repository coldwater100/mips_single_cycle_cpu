`timescale 1ns/1ps

module tb_single_cycle_cpu;

	reg clk, reset;
	reg expesrc0, expsrc1, expsrc2;
	wire [10:0] cnt_i, cnt_r, cnt_j, cnt_clk;
	wire [31:0] syscall_decoder_output;

	// 1clk? 10ns
	always #5 clk = ~clk;

	initial begin 
		clk = 0;
		reset = 1;
		expesrc0 = 0; 
		expsrc1 = 0;
		expsrc2 = 0;

		#5 reset = 0;

		#16450 $stop;
	end

	single_cycle_cpu cpu_inst(
		.clk(clk),
		.reset(reset),
		.expsrc0(expesrc0),
		.expsrc1(expsrc1),
		.expsrc2(expsrc2),
		.cnt_i(cnt_i),
		.cnt_r(cnt_r),
		.cnt_j(cnt_j),
		.cnt_clk(cnt_clk),
		.syscall_decoder_output(syscall_decoder_output)
	);

endmodule

