module pc_module (
    input  wire        clk,
    input  wire        HasExp,       // ?? ?? ?? ??
    input  wire        IsEret,       // ERET ?? ??
    input  wire        IsCOP0,       // CP0 ?? ?? ??
    input  wire [31:0] next_pc,      // ???? PC ??
    input  wire [31:0] epc,          // ?? ?? ??
    output reg  [31:0] pc_out        // ?? PC
);

    // mux1: IsEret && IsCOP0 ?? epc ??
    wire [63:0] mux1_in = {epc, next_pc};
    wire [31:0] after_mux1;
    wire        select1 = IsEret & IsCOP0;

    mux #(.select_bit(1), .data_bits(32)) mux1 (
        .sel(select1),
        .data_bus(mux1_in),
        .out(after_mux1)
    );

    // mux2: HasExp?? ?? ?? 0x800 ??
    wire [31:0] exp_addr = 32'h00000800;
    wire [63:0] mux2_in = {exp_addr, after_mux1};
    wire [31:0] after_mux2;

    mux #(.select_bit(1), .data_bits(32)) mux2 (
        .sel(HasExp),
        .data_bus(mux2_in),
        .out(after_mux2)
    );

    // ?? ???
    wire [1:0] clk_mux_in = {~clk, clk}; // 2?? ??
    wire       gated_clk;

    mux #(.select_bit(1), .data_bits(1)) clk_mux (
        .sel(select1 | HasExp),
        .data_bus(clk_mux_in),
        .out(gated_clk)
    );

    // PC ???? ??
    always @(posedge gated_clk) begin
        pc_out <= after_mux2;
    end

endmodule

