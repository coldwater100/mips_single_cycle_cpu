module immediate_sign_extend(
    input  wire [15:0] in,
    input  wire       ZeroExtend,  // 1?? Zero Extend, 0?? Sign Extend
    output wire [31:0] out
);
    wire [31:0] sign_ext_out;
    wire [31:0] zero_ext_out;

    sign_extend_16to32 sign_ext_inst(.in(in), .out(sign_ext_out));
    zero_extend_16to32 zero_ext_inst(.in(in), .out(zero_ext_out));

    assign out = ZeroExtend ? zero_ext_out : sign_ext_out;
endmodule

