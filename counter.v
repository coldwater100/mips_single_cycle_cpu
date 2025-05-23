module counter #(
    parameter DATA_BITS = 8,
    parameter MAX_VALUE = 255
)(
    input wire clk,
    input wire clr,
    input wire load,   // ?? ??
    input wire count,  // ?? ??
    input wire [DATA_BITS-1:0] D, // ?? ???
    output reg [DATA_BITS-1:0] Q, // ?? ?
    output wire carry             // ????? ??
);

    // ?? ?? ? ?? ??
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            Q <= 0;
        end else begin
            case ({load, count})
                2'b00: Q <= Q; // ??
                2'b01: Q <= (Q == MAX_VALUE) ? 0 : Q + 1; // ??
                2'b10: Q <= D; // ?? ? ??
                2'b11: Q <= (Q == 0) ? MAX_VALUE : Q - 1; // ??
            endcase
        end
    end

    // Carry ??: ?? ? MAX, ?? ? 0?? wrap-around ?
    assign carry = (load == 1'b0 && count == 1'b1 && Q == MAX_VALUE) ||
                   (load == 1'b1 && count == 1'b1 && Q == 0);

endmodule

