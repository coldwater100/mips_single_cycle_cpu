module syscall_decoder(
    input        clk,
    input        Enable,
    input	reset,
    input [31:0] v0,
    input [31:0] a0,
    output       Halt,
    output [31:0] Hex
);
    wire dummy1, halt_equal, dummy2;
    reg [31:0] hex_reg;
    comparator #(.DATA_BITS(32), .SIGNED_MODE(1)) halt_comp_inst(v0, 32'ha, dummy1, halt_equal, dummy2);
    mux #(.select_bit(1), .data_bits(1)) halt_mux(Enable,{halt_equal,1'b0},Halt);

    always @(posedge clk or posedge reset) begin
        if (reset)
	    hex_reg <= 32'b0;
        if (Enable)
            hex_reg <= a0;
    
    end

    assign Hex = hex_reg;

endmodule

