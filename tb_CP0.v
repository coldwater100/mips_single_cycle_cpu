`timescale 1ns / 1ps

module tb_CP0;

    // Input signals
    reg [31:0] Inst;
    reg ExpSrc0, ExpSrc1, ExpSrc2;
    reg clk;
    reg enable;
    reg [31:0] PCin, Din;

    // Output signals
    wire ExRegWrite, IsEret;
    wire ExpBlock, HasExp;
    wire [31:0] PCout, Dout;

    // Instantiate the Device Under Test (DUT)
    CP0 uut (
        .Inst(Inst),
        .ExRegWrite(ExRegWrite),
        .IsEret(IsEret),
        .ExpSrc0(ExpSrc0),
        .ExpSrc1(ExpSrc1),
        .ExpSrc2(ExpSrc2),
        .clk(clk),
        .ExpBlock(ExpBlock),
        .HasExp(HasExp),
        .enable(enable),
        .PCin(PCin),
        .Din(Din),
        .PCout(PCout),
        .Dout(Dout)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // ===== Initialization =====
        Inst     = 32'd0;
        ExpSrc0  = 1'b0;
        ExpSrc1  = 1'b0;
        ExpSrc2  = 1'b0;
        enable   = 1'b0;
        PCin     = 32'h0000_0000;
        Din      = 32'h0000_0000;

        #10;
        $display("==== Initialization Complete ====");

        // ===== Trigger Exception (ExpSrc1) =====
        PCin    = 32'h00400000;
        ExpSrc1 = 1'b1;
        #10;
        ExpSrc1 = 1'b0;
        #10;

        $display("\n[Exception Trigger Test]");
        $display("Inst      = 0x%h", Inst);
        $display("ExpSrc    = %b %b %b", ExpSrc2, ExpSrc1, ExpSrc0);
        $display("HasExp    = %b", HasExp);
        $display("ExpBlock  = %b", ExpBlock);
        $display("PCin      = 0x%h", PCin);
        $display("PCout     = 0x%h", PCout);

        // ===== Write to EPC register =====
        Inst   = 32'b0000_0000_0000_0000_0000_0000_0000_0000; // sel = 2'b00, ExRegWrite = 1
        enable = 1'b1;
        Din    = 32'h1234_5678;
        #10;
        enable = 1'b0;
        #10;

        $display("\n[EPC Write Test]");
        $display("Inst      = 0x%h", Inst);
        $display("sel       = %b", Inst[12:11]);
        $display("enable    = %b", enable);
        $display("ExRegWrite= %b", ExRegWrite);
        $display("Din       = 0x%h", Din);
        $display("PCin      = 0x%h", PCin);
        $display("PCout     = 0x%h", PCout);

        // ===== Read from EPC register =====
        Inst   = 32'b0000_0000_0000_1000_0000_0000_0000_0000; // sel = 2'b00, ExRegWrite = 0
        enable = 1'b1;
        #10;
        enable = 1'b0;

        $display("\n[EPC Read Test]");
        $display("Inst      = 0x%h", Inst);
        $display("sel       = %b", Inst[12:11]);
        $display("ExRegWrite= %b", ExRegWrite);
        $display("Dout      = 0x%h (EPC)", Dout);
        $display("PCout     = 0x%h", PCout);

        // ===== Test ERET instruction =====
        Inst[5:0] = 6'b011000;
        #10;

        $display("\n[ERET Instruction Test]");
        $display("Inst      = 0x%h", Inst);
        $display("IsEret    = %b", IsEret);

        // ===== End of Simulation =====
        $display("\n==== End of Test ====");
        $stop;
    end

endmodule
