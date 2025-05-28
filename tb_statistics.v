`timescale 1ns / 1ps

module tb_statistics;

    // Inputs
    reg clk;
    reg reset;
    reg [5:0] op;

    // Outputs
    wire [10:0] i;
    wire [10:0] r;
    wire [10:0] j;
    wire [10:0] cnt_clk;

    // Instantiate DUT
    statistics uut (
        .clk(clk),
        .reset(reset),
        .op(op),
        .i(i),
        .r(r),
        .j(j),
        .cnt_clk(cnt_clk)
    );

    // Clock generator
    initial clk = 0;
    always #5 clk = ~clk;

    task apply_op;
        input [5:0] op_val;
        begin
            op = op_val;
            @(posedge clk); #1;
            $display("Time %0t | op = %b | i = %d | r = %d | j = %d | clk = %d",
                     $time, op, i, r, j, cnt_clk);
        end
    endtask

    initial begin
        $display("--- Starting statistics Testbench ---");

        // Reset
        reset = 1;
        op = 6'b000000;
        @(posedge clk); #1;
        reset = 0;

        // R-type instruction
        apply_op(6'b000000);  // R-type

        // I-type instructions (multiple valid types)
        apply_op(6'b100011);  // lw
        apply_op(6'b101011);  // sw
        apply_op(6'b001000);  // addi
        apply_op(6'b001100);  // andi

        // J-type instructions
        apply_op(6'b000010);  // j
        apply_op(6'b000011);  // jal

        // Other NOP or undefined instruction
        apply_op(6'b111111);  // should not be counted

        // Check final result
        @(posedge clk); #1;
        $display("Final Count => i: %d, r: %d, j: %d, clk: %d", i, r, j, cnt_clk);

        $display("--- End of statistics Testbench ---");
        $stop;
    end

endmodule

