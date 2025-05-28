
`timescale 1ns / 1ps

module tb_registerfile;

    // Inputs
    reg clk;
    reg WE;
    reg [4:0] reg1_addr;
    reg [4:0] reg2_addr;
    reg [4:0] write_addr;
    reg [31:0] write_data;

    // Outputs
    wire [31:0] reg1_data;
    wire [31:0] reg2_data;
    wire [31:0] a0;
    wire [31:0] v0;

    // Instantiate DUT
    registerfile uut (
        .clk(clk),
        .WE(WE),
        .reg1_addr(reg1_addr),
        .reg2_addr(reg2_addr),
        .write_addr(write_addr),
        .write_data(write_data),
        .reg1_data(reg1_data),
        .reg2_data(reg2_data),
        .a0(a0),
        .v0(v0)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("--- Starting registerfile Testbench ---");
        clk = 0;
        WE = 0;
        write_addr = 0;
        write_data = 0;
        reg1_addr = 0;
        reg2_addr = 0;

        // Test 1: Write to $2 (v0)
        #10;
        WE = 1;
        write_addr = 5'd2;  // $v0
        write_data = 32'h12345678;
        #10;

        // Test 2: Write to $4 (a0)
        write_addr = 5'd4;  // $a0
        write_data = 32'hABCDEF01;
        #10;

        // Test 3: Read from $2 and $4
        WE = 0;
        reg1_addr = 5'd2;
        reg2_addr = 5'd4;
        #10;

        $display("Read reg1_data ($v0): %h (Expected: 12345678)", reg1_data);
        $display("Read reg2_data ($a0): %h (Expected: ABCDEF01)", reg2_data);
        $display("Direct output v0:     %h (Expected: 12345678)", v0);
        $display("Direct output a0:     %h (Expected: ABCDEF01)", a0);

        // Test 4: Attempt to write to $0 (should not change)
        WE = 1;
        write_addr = 5'd0;
        write_data = 32'hFFFFFFFF;
        #10;
        WE = 0;
        reg1_addr = 5'd0;
        #10;

        $display("Read reg1_data ($0):  %h (Expected: 00000000)", reg1_data);

        $display("--- End of registerfile Testbench ---");
        $stop;
    end

endmodule
