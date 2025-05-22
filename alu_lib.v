// full_adder.v
module full_adder(input X, input Y, input cin, output Result, output CF);
    assign Result = X ^ Y ^ cin;
    assign CF = (X & Y) | (Y & cin) | (X & cin);
endmodule

// full_subtractor.v
module full_subtractor(input X, input Y, input cin, output Result, output CF);
    assign Result = X ^ Y ^ cin;
    assign CF = (~X & Y) | ((~X | Y) & cin);
endmodule

// adder32.v
module adder_32bit(input [31:0] X, input [31:0] Y, input cin, output [31:0] Result, output CF, output OF);
    wire [32:0] carry;
    assign carry[0] = cin;
    genvar i;
    generate for (i = 0; i < 32; i = i + 1) begin: adders
        full_adder fa(X[i], Y[i], carry[i], Result[i], carry[i+1]);
    end endgenerate
    assign CF = carry[32];
    assign OF = carry[31] ^ carry[32];
endmodule

// subtractor32.v
module subtractor_32bit(input [31:0] X, input [31:0] Y, input cin, output [31:0] Result, output CF, output OF);
    wire [32:0] borrow;
    assign borrow[0] = cin;
    genvar i;
    generate for (i = 0; i < 32; i = i + 1) begin: subtractors
        full_subtractor fs(X[i], Y[i], borrow[i], Result[i], borrow[i+1]);
    end endgenerate
    assign CF = borrow[32];
    assign OF = borrow[31] ^ borrow[32];
endmodule

// left_shift.v
module left_shift(input [31:0] data, input [4:0] dist, output [31:0] result);
    assign result = data << dist;
endmodule

// right_shift.v
module right_shift(input [31:0] data, input [4:0] dist, output [31:0] result);
    assign result = data >> dist;
endmodule

// right_arithmetic_shift.v
module right_arithmetic_shift(input [31:0] data, input [4:0] dist, output [31:0] result);
    assign result = $signed(data) >>> dist;
endmodule

// cascadable_multiplier.v
module cascadable_multiplier(input [31:0] X, input [31:0] Y, input [31:0] cin, output [31:0] Result, output [31:0] Cout);
    wire [63:0] product_full;
    assign product_full = (X * Y) + cin;
    assign Result = product_full[31:0];
    assign Cout = product_full[63:32];
endmodule

// cascadable_divider.v
module cascadable_divider(input [31:0] upper, input [31:0] lower, input [31:0] divisor, output [31:0] quotient, output [31:0] remainder);
    wire [63:0] dividend = {upper, lower};
    wire [31:0] safe_divisor = (divisor == 0) ? 32'd1 : divisor;
    assign quotient = dividend / safe_divisor;
    assign remainder = dividend % safe_divisor;
endmodule

// and_32bit.v
module and_32bit(input [31:0] X, input [31:0] Y, output [31:0] Result);
    assign Result = X & Y;
endmodule

// or_32bit.v
module or_32bit(input [31:0] X, input [31:0] Y, output [31:0] Result);
    assign Result = X | Y;
endmodule

// xor_32bit.v
module xor_32bit(input [31:0] X, input [31:0] Y, output [31:0] Result);
    assign Result = X ^ Y;
endmodule

// nor_32bit.v
module nor_32bit(input [31:0] X, input [31:0] Y, output [31:0] Result);
    assign Result = ~(X | Y);
endmodule

// comparator.v
module comparator #(
    parameter DATA_BITS = 32,
    parameter SIGNED_MODE = 0
)(
    input  wire [DATA_BITS-1:0] X,
    input  wire [DATA_BITS-1:0] Y,
    output wire                 greater,
    output wire                 equal,
    output wire                 less
);

    generate
        if (SIGNED_MODE == 1) begin : signed_comparison
            assign greater = ($signed(X) >  $signed(Y));
            assign equal   = ($signed(X) == $signed(Y));
            assign less    = ($signed(X) <  $signed(Y));
        end else begin : unsigned_comparison
            assign greater = (X >  Y);
            assign equal   = (X == Y);
            assign less    = (X <  Y);
        end
    endgenerate

endmodule

// extender_1to32.v
module extender_1to32(input in, output [31:0] out);
    assign out = {31'b0, in};
endmodule

