module cp0 (
    input  wire        clk,
    input  wire        enable,
    input  wire        ExpRegWrite,   // ???? ?? ??
    input  wire        ExpBlock,      // ?? ???? ?? ??
    input  wire        IsEret,
    input  wire        HasExp,        // ?? ?? ??
    input  wire [1:0]  Sel,           // ???? ?? (00: EPC, 01: Cause, 10: Status, 11: Block)
    input  wire [31:0] PCin,
    input  wire [31:0] Dim,           // ?? ??
    input  wire [31:0] ExpSrc0, ExpSrc1, ExpSrc2, // Cause ???? ??
    output wire [31:0] PCout,         // EPC ??
    output wire [31:0] Dout,          // ??? ???? ??
    output wire [31:0] BlockSrc0, BlockSrc1, BlockSrc2 // ?? ???? ??
);

    // ?? ????
    reg [31:0] EPC, Cause, Status, Block;

    // EPC ??: ?? ?? ? PCin ??
    always @(posedge clk) begin
        if (HasExp)
            EPC <= PCin;
    end

    assign PCout = EPC;

    // Cause ????: ExpSrc ??
    wire [63:0] cause_mux_in = {ExpSrc2, ExpSrc1, ExpSrc0, 32'b0};
    mux #(.select_bit(2), .data_bits(32)) cause_mux(
        .sel(Sel),
        .data_in(cause_mux_in),
        .data_out(Cause)
    );

    // Status ????: ExpRegWrite && enable ? ????
    always @(posedge clk) begin
        if (ExpRegWrite && enable && Sel == 2'b10)
            Status <= Dim;
    end

    // Block ????: ExpBlock ? ????
    always @(posedge clk) begin
        if (ExpBlock)
            Block <= Dim;
    end

    // ?? ??
    assign BlockSrc0 = 32'h00000001;
    assign BlockSrc1 = 32'h00000003;
    assign BlockSrc2 = 32'h00000007;

    // ?? ?? MUX (EPC, Cause, Status, Block)
    wire [127:0] out_bus = {Block, Status, Cause, EPC};
    mux #(.select_bit(2), .data_bits(32)) out_mux (
        .sel(Sel),
        .data_in(out_bus),
        .data_out(Dout)
    );

endmodule

