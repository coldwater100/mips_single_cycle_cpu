`timescale 1ns / 1ps

module tb_alu;
    reg [31:0] X;
    reg [31:0] Y;
    reg [3:0]  S;

    wire [31:0] Result;
    wire [31:0] Result2;
    wire        OF;
    wire        CF;
    wire        Equal;

    alu uut (
        .X(X),
        .Y(Y),
        .S(S),
        .Result(Result),
        .Result2(Result2),
        .OF(OF),
        .CF(CF),
        .Equal(Equal)
    );

    initial begin
        $display("--- Starting alu_selector Testbench ---");

        // Shift Tests
        X = 32'h000000FF; Y = 32'd4; S = 4'd0; #10;
        $display("<Test 1>");
        $display("Input  : A = %h (bin : %b), B = %h (dec : %0d), AluOP = %h (Left Logical Shift)", X, X, Y, Y, S);
        $display("Output : Result = %h (bin : %b), Result2 = %h, Signed Overflow = %b, Unsigned Overflow = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        X = 32'hF0000000; Y = 32'd2; S = 4'd1; #10;
        $display("<Test 2>");
        $display("Input  : A = %h (bin : %b), B = %h (dec : %0d), AluOP = %h (Arithmetic Right Shift)", X, X, Y, Y, S);
        $display("Output : Result = %h (bin : %b), Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        X = 32'hF0000000; Y = 32'd2; S = 4'd2; #10;
        $display("<Test 3>");
        $display("Input  : A = %h (bin : %b), B = %h (dec : %0d), AluOP = %h (Logical Right Shift)", X, X, Y, Y, S);
        $display("Output : Result = %h (bin : %b), Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        // Multiplication Tests
        X = 32'd2; Y = 32'd3; S = 4'd3; #10;
        $display("<Test 4>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Multiplication)", X, X, Y, Y, S);
        $display("Output : Result = %h (dec : %0d), Result2(cout) = %h (dec : %0d), OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, Result2, OF, CF, Equal);

        X = 32'h10000000; Y = 32'h10000000; S = 4'd3; #10;
        $display("<Test 4-2>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Multiplication with Cout)", X, X, Y, Y, S);
        $display("Output : Result = %h (%0d), Result2(cout) = %h (dec : %0d), OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, Result2, OF, CF, Equal);

        // Division Tests
        X = 32'd10; Y = 32'd3; S = 4'd4; #10;
        $display("<Test 5>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Division)", X, X, Y, Y, S);
	$display("Output : Result(Quotient) = %h (%0d), Result2(Remainder) = %h (dec : %0d), OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, Result2, OF, CF, Equal);

        X = 32'd9; Y = 32'd3; S = 4'd4; #10;
        $display("<Test 5-2>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Division)", X, X, Y, Y, S);
	$display("Output : Result(Quotient) = %h (%0d), Result2(Remainder) = %h (dec : %0d), OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, Result2, OF, CF, Equal);

        // Addition Tests (OF and CF both visible)
	X = 32'd1; Y = 32'd1; S = 4'd5; #10;
        $display("<Test 6>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Addition)", X, X, Y, Y, S);
        $display("Output : Result = %h (%0d), Result2 = %h, OF(Signed Overflow) = %b, CF(Unsigned Overflow) = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);
        
        X = 32'h7FFFFFFF; Y = 32'd1; S = 4'd5; #10;
        $display("<Test 6-1>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Addition - OF Expect)", X, X, Y, Y, S);
        $display("Output : Result = %h (%0d), Result2 = %h, OF(Signed Overflow) = %b, CF(Unsigned Overflow) = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        X = 32'hFFFFFFFF; Y = 32'd1; S = 4'd5; #10;
        $display("<Test 6-2>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Addition - CF Expect)", X, X, Y, Y, S);
        $display("Output : Result = %h (dec : %0d), Result2 = %h, OF(Signed Overflow) = %b, CF(Unsigned Overflow) = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        // Subtraction Tests (OF and CF both visible)
        X = 32'd5; Y = 32'd3; S = 4'd6; #10;
        $display("<Test 7>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Subtraction)", X, X, Y, Y, S);
        $display("Output : Result = %h (dec : %0d), Result2 = %h, OF(Signed Overflow) = %b, CF(Unsigned Overflow) = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        X = 32'd3; Y = 32'd5; S = 4'd6; #10;
        $display("<Test 7-2>");
        $display("Input  : A = %h (dec : %0d), B = %h (dec : %0d), AluOP = %h (Subtraction - CF Expect)", X, X, Y, Y, S);
        $display("Output : Result = %h (dec : %0d), Result2 = %h, OF(Signed Overflow) = %b, CF(Unsigned Overflow) = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        // Bitwise Logic Tests
        X = 32'hA5A5A5A5; Y = 32'h5A5A5A5A; S = 4'd7; #10;
        $display("<Test 8>");
        $display("Input  : A = %h (bin : %b), B = %h (bin : %b), AluOP = %h (AND)", X, X, Y, Y, S);
        $display("Output : Result = %h (bin : %b), Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        S = 4'd8; #10;
        $display("<Test 9>");
        $display("Input  : A = %h (bin : %b), B = %h (bin : %b), AluOP = %h (OR)", X, X, Y, Y, S);
        $display("Output : Result = %h (bin : %b), Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        S = 4'd9; #10;
        $display("<Test 10>");
        $display("Input  : A = %h (bin : %b), B = %h (bin : %b), AluOP = %h) (XOR)", X, X, Y, Y, S);
        $display("Output : Result = %h (bin : %b), Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        S = 4'd10; #10;
        $display("<Test 11>");
        $display("Input  : A = %h (bin : %b), B = %h (bin : %b), AluOP = %h (NOR)", X, X, Y, Y, S);
        $display("Output : Result = %h (bin : %b), Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result, Result2, OF, CF, Equal);

        // Signed Comparison Tests
        X = -32'd3; Y = -32'd2; S = 4'd11; #10;
        $display("<Test 12>");
        $display("Input  : A = %0h, B = %0h, AluOP = %h (Signed compare)", X, Y, S);
        $display("Output : Result = %h, Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result2, OF, CF, Equal);

        X = 32'd0; Y = -32'd1; S = 4'd11; #10;
        $display("<Test 12-2>");
        $display("Input  : A = %0h, B = %0h, AluOP = %h (Signed compare)", X, Y, S);
        $display("Output : Result = %h, Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result2, OF, CF, Equal);

        // Unsigned Equality and Relational Tests
        X = 32'd3; Y = 32'd2; S = 4'd12; #10;
        $display("<Test 13>");
        $display("Input  : A = %h, B = %h, AluOP = %h (Unsigned compare)", X, Y, S);
        $display("Output : Result = %h, Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result2, OF, CF, Equal);

        X = 32'd0; Y = 32'd1; S = 4'd12; #10;
        $display("<Test 13-2>");
        $display("Input  : A = %h, B = %h, AluOP = %h (Unsigned compare)", X, Y, S);
        $display("Output : Result = %h, Result2 = %h, OF = %b, CF = %b, Equal = %b",
                 Result, Result2, OF, CF, Equal);

        $display("--- Testbench Complete ---");
        $stop;
    end

endmodule

