module CP0 (
    input  wire [31:0] Inst,
    input  wire [31:0] PCin,
    input  wire [31:0] Din,
    input  wire ExpSrc0,
    input  wire ExpSrc1,
    input  wire ExpSrc2,
    input  wire clk,
    input  wire enable,
    input  wire reset,
    output wire ExRegWrite,
    output wire IsEret,
    output wire HasExp,
    output wire ExpBlock,
    output wire [31:0] PCout,
    output reg  [31:0] Dout
);

    // Instruction decoding
    wire [1:0] sel = Inst[12:11];
    assign ExRegWrite = ~Inst[23];
    assign IsEret = (Inst[5:0] == 6'b011000);

    // Block logic
    reg [31:0] EPC_out, Status_out, Block_out, Cause_out;
    assign PCout = EPC_out;
    assign ExpBlock = Status_out[0];
    wire [2:0] BlockSrc = Block_out[2:0];

    // Exception check
    wire [2:0] ExpSel = {
        (BlockSrc[2]) ? 1'b0 : ExpSrc2,
        (BlockSrc[1]) ? 1'b0 : ExpSrc1,
        (BlockSrc[0]) ? 1'b0 : ExpSrc0
    };
    wire ExpClick = (|ExpSel) & ~ExpBlock;

    // Simple 1-bit toggle counters
    reg counter1_out = 0, counter2_out = 0;
    assign HasExp = clk & counter1_out;

    always @(posedge ExpClick or posedge counter2_out)
        counter1_out <= (counter2_out) ? 1'b0 : 1'b1;

    always @(posedge HasExp or negedge counter1_out)
        counter2_out <= (!counter1_out) ? 1'b0 : 1'b1;

    // Register write enable logic
    wire enable_write = enable & ~ExRegWrite;
    wire EPC_en    = HasExp | (enable_write & (sel == 2'b00));
    wire Status_en = enable_write & (sel == 2'b01);
    wire Block_en  = enable_write & (sel == 2'b10);
    wire Cause_en  = ExpClick;

    // EPC input mux
    wire [31:0] EPC_in = HasExp ? PCin : Din;

    // Register update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EPC_out    <= 32'd0;
            Status_out <= 32'd0;
            Block_out  <= 32'd0;
        end else begin
            if (EPC_en)    EPC_out    <= EPC_in;
            if (Status_en) Status_out <= Din;
            if (Block_en)  Block_out  <= Din;
        end
    end

    // Cause register
    wire [31:0] Cause_in = ExpSrc0 ? 32'h00000001 :
                           ExpSrc1 ? 32'h00000003 :
                           ExpSrc2 ? 32'h00000007 :
                                     32'b0;

    always @(posedge ExpClick) begin
        Cause_out <= Cause_in;
    end

    // Read MUX
    always @(*) begin
        case (sel)
            2'b00: Dout = EPC_out;
            2'b01: Dout = Status_out;
            2'b10: Dout = Block_out;
            2'b11: Dout = Cause_out;
            default: Dout = 32'd0;
        endcase
    end

endmodule

