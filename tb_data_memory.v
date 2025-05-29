// tb_ram_module.v - Testbench for ram_module

`timescale 1ns / 1ps

module tb_data_memory;
    // Inputs
    reg clk;
    reg sel;
    reg str;
    reg ld;
    reg clr;
    reg [9:0] addr;
    reg [31:0] data_in;

    // Output
    wire [31:0] data_out;

    // Instantiate the RAM module
    data_memory uut (
        .clk(clk),
        .sel(sel),
        .str(str),
        .ld(ld),
        .clr(clr),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        $display("--- Starting RAM Testbench ---");

        // Clear memory
        clr = 1; sel = 0; str = 0; ld = 0; addr = 0; data_in = 0;
        #10; clr = 0;
	$display("clear memory");
        // Store data at address 10
        sel = 1; str = 1; ld = 0; addr = 10; data_in = 32'hDEADBEEF;
        #10;
	$display("store addr=10: data_in = %h", data_in);
        // Store data at address 20
        addr = 20; data_in = 32'hCAFEBABE;
        #10;
	$display("store addr=20: data_in = %h", data_in);
        // Read from address 10
        str = 0; ld = 1; addr = 10;
        #10;
        $display("Read addr=10: data_out = %h", data_out);

        // Read from address 20
        addr = 20;
        #10;
        $display("Read addr=20: data_out = %h", data_out);

        // Test with sel = 0 (should disable output)
        sel = 0;
        #10;
        $display("Read with sel=0: data_out = %h (should be z)", data_out);

        // Test clear again
        clr = 1; #10; clr = 0;

        // Read from address 10 again
        sel = 1; ld = 1; addr = 10;
        #10;
        $display("After clear, read addr=10: data_out = %h", data_out);

        $display("--- RAM Testbench Complete ---");
        $stop;
    end
endmodule

