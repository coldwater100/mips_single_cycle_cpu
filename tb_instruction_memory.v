`timescale 1ns / 1ps

module tb_instruction_memory;

    reg  [31:0] pc;       // ?? PC ??
    wire [31:0] instr;    // ??? ??

    // DUT (Device Under Test)
    instruction_memory dut (
        .pc(pc),  // PC? 2~10? ??? ?? (?? ?? ??)
        .data(instr)
    );

    integer i;

    initial begin
        $display("----- Starting Instruction Memory Test -----");

        // ?? ??? ?? ??? ?? ??
        for (i = 0; i < 16; i = i + 1) begin
            pc = i * 4; #10; // PC? 4??? ?? ??
            $display("PC = 0x%08h -> Instruction = 0x%08h", pc, instr);
        end

        $display("----- Test Complete -----");
        $stop;
    end

endmodule
