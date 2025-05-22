module statistics(
    input  [5:0] op,
    output       i,
    output       r,
    output       j
    
);

    assign r = (op == 6'b000000);  // R-type
    assign j = (op == 6'b000010) || (op == 6'b000011);  // j, jal
    assign i = ~r & ~j;  // ??? ?? I-type

endmodule

