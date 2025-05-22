`timescale 1ns / 1ps

module tb_immediate_sign_extend;
    reg  [15:0] in;
    reg         ZeroExtend;
    wire [31:0] out;

    // UUT (Unit Under Test)
    immediate_sign_extend uut (
        .in(in),
        .ZeroExtend(ZeroExtend),
        .out(out)
    );

    initial begin
        $display("--- Starting Extend Testbench ---");

        // Test 1: Positive number (0x0001)
        in = 16'h0001; ZeroExtend = 0; #10;
        $display("<Test 1> Sign Extend");
        $display("Input  = %h, ZeroExtend = %b", in, ZeroExtend);
        $display("Output = %h", out);

        in = 16'h0001; ZeroExtend = 1; #10;
        $display("<Test 2> Zero Extend");
        $display("Input  = %h, ZeroExtend = %b", in, ZeroExtend);
        $display("Output = %h", out);

        // Test 2: Negative number (0xFFFF)
        in = 16'hFFFF; ZeroExtend = 0; #10;
        $display("<Test 3> Sign Extend (Negative)");
        $display("Input  = %h, ZeroExtend = %b", in, ZeroExtend);
        $display("Output = %h", out);

        in = 16'hFFFF; ZeroExtend = 1; #10;
        $display("<Test 4> Zero Extend (Negative Input)");
        $display("Input  = %h, ZeroExtend = %b", in, ZeroExtend);
        $display("Output = %h", out);

        // Test 3: MSB=1 but not negative (e.g., 0x8000)
        in = 16'h8000; ZeroExtend = 0; #10;
        $display("<Test 5> Sign Extend (MSB = 1)");
        $display("Input  = %h, ZeroExtend = %b", in, ZeroExtend);
        $display("Output = %h", out);

        in = 16'h8000; ZeroExtend = 1; #10;
        $display("<Test 6> Zero Extend (MSB = 1)");
        $display("Input  = %h, ZeroExtend = %b", in, ZeroExtend);
        $display("Output = %h", out);

        $display("--- Testbench Complete ---");
        $stop;
    end
endmodule

