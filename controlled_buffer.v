module controlled_buffer #(
    parameter DATA_BITS = 32
)(
    input  wire [DATA_BITS-1:0] in,     // ??
    input  wire                 enable, // ?? ??
    output wire [DATA_BITS-1:0] out     // ?? (??? ?? Z ?? ???)
);
    assign out = (enable) ? in : {DATA_BITS{1'bz}};
endmodule

