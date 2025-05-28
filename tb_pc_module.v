`timescale 1ns/1ps

module tb_pc_module;

    reg clk;
    reg HasExp, IsEret, IsCOP0, IsJR, Jump, Branch, BneOrBeq, Equal;
    reg [31:0] Instr, PresentPC, ExtendInst, RegfileR1, EPC;
    wire [31:0] PCOut;

    // DUT instantiation
    pc_module uut (
        .clk(clk),
        .HasExp(HasExp),
        .IsEret(IsEret),
        .IsCOP0(IsCOP0),
        .IsJR(IsJR),
        .Jump(Jump),
        .Branch(Branch),
        .BneOrBeq(BneOrBeq),
        .Equal(Equal),
        .Instr(Instr),
        .PresentPC(PresentPC),
        .ExtendInst(ExtendInst),
        .RegfileR1(RegfileR1),
        .EPC(EPC),
        .PCOut(PCOut)
    );

    initial begin
        $display("Time | HasExp IsEret IsCOP0 IsJR Jump Branch BneOrBeq Equal | PCOut");
        $monitor("%4t |    %b      %b      %b     %b    %b      %b       %b      %b  | %h",
                 $time, HasExp, IsEret, IsCOP0, IsJR, Jump, Branch, BneOrBeq, Equal, PCOut);

        // ???
        clk = 0;
        PresentPC = 32'h00400000;
        ExtendInst = 32'd4;
        Instr = 32'h08000004; // jump target: 0x00000010 (<<2)
        RegfileR1 = 32'h10000000;
        EPC = 32'h00001234;

        // ??? ??? 1: ?? PC+4
        HasExp = 0; IsEret = 0; IsCOP0 = 0; IsJR = 0;
        Jump = 0; Branch = 0; BneOrBeq = 0; Equal = 0;
        #10 clk = ~clk; #10 clk = ~clk;

        // ??? ??? 2: Branch ??? ??
        HasExp = 0; IsEret = 0; IsCOP0 = 0; IsJR = 0;
        Jump = 0; Branch = 1; BneOrBeq = 1; Equal = 1;
        #10 clk = ~clk; #10 clk = ~clk;

        // ??? ??? 3: Jump
        HasExp = 0; IsEret = 0; IsCOP0 = 0; IsJR = 0;
        Jump = 1; Branch = 0; BneOrBeq = 0; Equal = 0;
        #10 clk = ~clk; #10 clk = ~clk;

        // ??? ??? 4: JR
        HasExp = 0; IsEret = 0; IsCOP0 = 0; IsJR = 1;
        Jump = 0; Branch = 0; BneOrBeq = 0; Equal = 0;
        #10 clk = ~clk; #10 clk = ~clk;

        // ??? ??? 5: ERET
        HasExp = 0; IsEret = 1; IsCOP0 = 1; IsJR = 0;
        #10 clk = ~clk; #10 clk = ~clk;

        // ??? ??? 6: ?? ??
        HasExp = 1; IsEret = 0; IsCOP0 = 0; IsJR = 0;
        #10 clk = ~clk; #10 clk = ~clk;

        $stop;
    end

endmodule

