`timescale 1ns / 1ps

module tb_pc_module;

    // Inputs
    reg clk;
    reg HasExp;
    reg IsEret;
    reg IsCOP0;
    reg [31:0] next_pc;
    reg [31:0] epc;

    // Output
    wire [31:0] pc_out;

    // Instantiate the Unit Under Test (UUT)
    pc_module uut (
        .clk(clk),
        .HasExp(HasExp),
        .IsEret(IsEret),
        .IsCOP0(IsCOP0),
        .next_pc(next_pc),
        .epc(epc),
        .pc_out(pc_out)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $display("--- Starting pc_module Testbench ---");

        // Initialize inputs
        clk     = 0;
        next_pc = 32'h00000004;
        epc     = 32'h00001234;

        // Test 1: Normal PC (no exception, no eret)
        HasExp  = 0;
        IsEret  = 0;
        IsCOP0  = 0;
        #10;
        $display("<Test 1: Normal PC>");
        $display("Input  : HasExp = %b, IsEret = %b, IsCOP0 = %b", HasExp, IsEret, IsCOP0);
        $display("Output : PC = %h (Expected: next_pc = %h)\n", pc_out, next_pc);

        // Test 2: Only IsCOP0 = 1 (no eret)
        HasExp  = 0;
        IsEret  = 0;
        IsCOP0  = 1;
        #10;
        $display("<Test 2: Only IsCOP0 = 1>");
        $display("Input  : HasExp = %b, IsEret = %b, IsCOP0 = %b", HasExp, IsEret, IsCOP0);
        $display("Output : PC = %h (Expected: next_pc = %h)\n", pc_out, next_pc);

        // Test 3: Only IsEret = 1 (no cop0)
        HasExp  = 0;
        IsEret  = 1;
        IsCOP0  = 0;
        #10;
        $display("<Test 3: Only IsEret = 1>");
        $display("Input  : HasExp = %b, IsEret = %b, IsCOP0 = %b", HasExp, IsEret, IsCOP0);
        $display("Output : PC = %h (Expected: next_pc = %h)\n", pc_out, next_pc);

        // Test 4: Eret + COP0 (should use EPC)
        HasExp  = 0;
        IsEret  = 1;
        IsCOP0  = 1;
        #10;
        $display("<Test 4: Eret + COP0>");
        $display("Input  : HasExp = %b, IsEret = %b, IsCOP0 = %b", HasExp, IsEret, IsCOP0);
        $display("Output : PC = %h (Expected: EPC = %h)\n", pc_out, epc);

        // Test 5: Exception (override all)
        HasExp  = 1;
        IsEret  = 0;
        IsCOP0  = 0;
        #10;
        $display("<Test 5: Exception>");
        $display("Input  : HasExp = %b, IsEret = %b, IsCOP0 = %b", HasExp, IsEret, IsCOP0);
        $display("Output : PC = %h (Expected: 0x00000800)\n", pc_out);

        // Test 6: Eret + COP0 + Exception (exception takes priority)
        HasExp  = 1;
        IsEret  = 1;
        IsCOP0  = 1;
        #10;
        $display("<Test 6: Eret + COP0 + Exception>");
        $display("Input  : HasExp = %b, IsEret = %b, IsCOP0 = %b", HasExp, IsEret, IsCOP0);
        $display("Output : PC = %h (Expected: 0x00000800)\n", pc_out);

        $display("--- End of Testbench ---");
        $stop;
    end

endmodule
