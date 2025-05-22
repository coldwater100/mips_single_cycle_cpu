`timescale 1ns / 1ps

module tb_syscall_decoder;

    reg clk;
    reg Enable;
    reg [31:0] v0;
    reg [31:0] a0;
    wire Halt;
    wire [31:0] Hex;

    // DUT
    syscall_decoder uut (
        .clk(clk),
        .Enable(Enable),
        .v0(v0),
        .a0(a0),
        .Halt(Halt),
        .Hex(Hex)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("--- Starting syscall_unit Testbench ---");

        // Test 1: v0 != 10 (no halt)
        v0 = 32'h00000005;
        a0 = 32'hDEADBEEF;
        Enable = 1'b1;
        #1;
        $display("<Test 1>");
        $display("Input  : v0 = %h, Enable = %h", v0, Enable);
        $display("Output : Halt = %h", Halt);
        $display("Before clk : a0 = %h, Hex = %h", a0, Hex);
        #9;
        $display("After clk  : a0 = %h, Hex = %h", a0, Hex);

        // Test 2: v0 == 10 (halt expected)
        v0 = 32'h0000000A;
        a0 = 32'hCAFEBABE;
        Enable = 1'b1;
        #1;
        $display("<Test 2>");
        $display("Input  : v0 = %h, Enable = %h", v0, Enable);
        $display("Output : Halt = %h", Halt);
        $display("Before clk : a0 = %h, Hex = %h", a0, Hex);
        #9;
        $display("After clk  : a0 = %h, Hex = %h", a0, Hex);

        // Test 3: Enable = 0 (Hex should not update)
        v0 = 32'h0000000A;
        a0 = 32'h12345678;
        Enable = 1'b0;
        #1;
        $display("<Test 3>");
        $display("Input  : v0 = %h, Enable = %h", v0, Enable);
        $display("Output : Halt = %h", Halt);
        $display("Before clk : a0 = %h, Hex = %h", a0, Hex);
        #9;
        $display("After clk  : a0 = %h, Hex = %h", a0, Hex);

        $display("--- Testbench Complete ---");
        $stop;
    end
endmodule

