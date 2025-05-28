module pc_module (
    input  wire        clk,
    input  wire        HasExp,
    input  wire        IsEret,
    input  wire        IsCOP0,
    input  wire        IsJR,
    input  wire        Jump,
    input  wire        Branch,
    input  wire        BneOrBeq,
    input  wire        Equal,
    input  wire [31:0] Instr,
    input  wire [31:0] PresentPC,
    input  wire [31:0] ExtendInst,
    input  wire [31:0] RegfileR1,
    input  wire [31:0] EPC,
    output reg  [31:0] PCOut
);

    // 1. PC + 4
    wire [31:0] PC4 = PresentPC + 32'd4;

    // 2. Branch Target: (Equal ^ BneOrBeq) & Branch
    wire isBranchTaken = (Equal ^ BneOrBeq) & Branch;
    wire [31:0] BranchAddr = PC4 + (ExtendInst << 2);

    // Mux1: Branch decision
    wire [63:0] mux1_in = {BranchAddr, PC4};
    wire [31:0] after_mux1;
    mux #(.select_bit(1), .data_bits(32)) mux1 (
        .sel(isBranchTaken),
        .data_bus(mux1_in),
        .out(after_mux1)
    );

    // 3. Jump Address
    wire [31:0] JumpAddr = {PC4[31:28], Instr[25:0], 2'b00};

    // Mux2: Jump or Not
    wire [63:0] mux2_in = {JumpAddr, after_mux1};
    wire [31:0] after_mux2;
    mux #(.select_bit(1), .data_bits(32)) mux2 (
        .sel(Jump),
        .data_bus(mux2_in),
        .out(after_mux2)
    );

    // Mux3: JR or normal
    wire [63:0] mux3_in = {RegfileR1, after_mux2};
    wire [31:0] after_mux3;
    mux #(.select_bit(1), .data_bits(32)) mux3 (
        .sel(IsJR),
        .data_bus(mux3_in),
        .out(after_mux3)
    );

    // Mux4: ERET or JR
    wire [63:0] mux4_in = {EPC, after_mux3};
    wire [31:0] after_mux4;
    wire isEretCond = IsEret & IsCOP0;
    mux #(.select_bit(1), .data_bits(32)) mux4 (
        .sel(isEretCond),
        .data_bus(mux4_in),
        .out(after_mux4)
    );

    // Mux5: Exception or not
    wire [63:0] mux5_in = {32'h00000800, after_mux4};
    wire [31:0] final_pc;
    mux #(.select_bit(1), .data_bits(32)) mux5 (
        .sel(HasExp),
        .data_bus(mux5_in),
        .out(final_pc)
    );

    // Optional gated clock if you use it in practice
    // For now, use normal clk
    always @(posedge clk) begin
        PCOut <= final_pc;
    end

endmodule

