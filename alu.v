module alu(
    input  wire [31:0] X,
    input  wire [31:0] Y,
    input  wire [3:0]  S,
    output wire [31:0] Result,
    output wire [31:0] Result2,
    output wire       OF,
    output wire       CF,
    output wire       Equal
);
    // Operation results
    wire [31:0] lshift_result, rshift_result, arshift_result;
    wire [31:0] add_result, sub_result, and_result, or_result, xor_result, nor_result;
    wire [31:0] mul_result, mul_cout, div_quotient, div_remainder;
    wire signed_less, unsigned_less, unsigned_eq, dummy1, dummy2;
    wire OF_add, CF_add, OF_sub, CF_sub;

    // Operation modules
    left_shift             lshift_inst(X, Y[4:0], lshift_result);
    right_arithmetic_shift arshift_inst(X, Y[4:0], arshift_result);
    right_shift            rshift_inst(X, Y[4:0], rshift_result);
    cascadable_multiplier  mul_inst(X, Y, 32'b0, mul_result, mul_cout);
    cascadable_divider     div_inst(32'b0, X, Y, div_quotient, div_remainder);
    adder_32bit            add_inst(X, Y, 1'b0, add_result, CF_add, OF_add);
    subtractor_32bit       sub_inst(X, Y, 1'b0, sub_result, CF_sub, OF_sub);
    and_32bit              and_inst(X, Y, and_result);
    or_32bit               or_inst(X, Y, or_result);
    xor_32bit              xor_inst(X, Y, xor_result);
    nor_32bit              nor_inst(X, Y, nor_result);
    comparator #(.DATA_BITS(32), .SIGNED_MODE(1)) signed_comp_inst(X, Y, dummy1, dummy2, signed_less);
    comparator #(.DATA_BITS(32), .SIGNED_MODE(0)) unsigned_comp_inst(X, Y, dummy1, unsigned_eq, unsigned_less);

    wire [31:0] signed_less_ext, unsigned_less_ext;
    extender_1to32 signed_ext_inst(.in(signed_less), .out(signed_less_ext));
    extender_1to32 unsigned_ext_inst(.in(unsigned_less), .out(unsigned_less_ext));

    // Result MUX
    wire [511:0] result_bus = {
        32'b0, 32'b0, 32'b0,
        unsigned_less_ext, signed_less_ext,
        nor_result, xor_result, or_result, and_result,
        sub_result, add_result,
        div_quotient, mul_result,
        rshift_result, arshift_result, lshift_result
    };
    mux #(.select_bit(4), .data_bits(32)) result_mux(S, result_bus, Result);

    // Result2 MUX
    wire [511:0] result2_bus = {
        32'b0, 32'b0, 32'b0, 32'b0,
        32'b0, 32'b0, 32'b0,
        32'b0, 32'b0, 32'b0, 32'b0,
        div_remainder, mul_cout,
        32'b0, 32'b0, 32'b0
    };
    mux #(.select_bit(4), .data_bits(32)) result2_mux(S, result2_bus, Result2);

    wire [32:0] OF_CF = {
        2'b0,2'b0,2'b0,2'b0,
	2'b0,2'b0,2'b0,2'b0,
	2'b0,{OF_sub,CF_sub},{OF_add,CF_add},2'b0,
	2'b0,2'b0,2'b0,2'b0
    };
    mux #(.select_bit(4), .data_bits(2)) OF_CF_mux(S, OF_CF, {OF,CF});

    // Equal output
    assign Equal = unsigned_eq;

endmodule
