module sign_extend_16to32(
    input  wire [15:0] in,
    output wire [31:0] out
);
    assign out = {{16{in[15]}}, in};  // 16?? ?? ??
endmodule

module zero_extend_16to32(
    input  wire [15:0] in,
    output wire [31:0] out
);
    assign out = {16'b0, in};  // 16?? 0?? ??
endmodule
