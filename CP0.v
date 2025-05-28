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

    wire [1:0] sel = Inst[12:11];
    assign ExRegWrite = ~Inst[23];
    assign IsEret = (Inst[5:0] == 6'b011000);

    // Block Source
    wire [2:0] BlockSrc;

    // Exception logic
    wire [2:0] ExpSel;
    assign ExpSel[0] = (BlockSrc[0]) ? 1'b0 : ExpSrc0;
    assign ExpSel[1] = (BlockSrc[1]) ? 1'b0 : ExpSrc1;
    assign ExpSel[2] = (BlockSrc[2]) ? 1'b0 : ExpSrc2;

    wire ExpClick = |ExpSel & ~ExpBlock;
    reg counter1_out, counter2_out;

    assign HasExp = clk & counter1_out;

    always @(posedge ExpClick or posedge counter2_out) begin
        if (counter2_out)
            counter1_out <= 1'b0;
        else
            counter1_out <= 1'b1;
    end

    always @(posedge HasExp or negedge counter1_out) begin
        if (!counter1_out)
            counter2_out <= 1'b0;
        else
            counter2_out <= 1'b1;
    end

    // Register write control
    wire [3:0] reg_sel;
    wire enable_write = enable & ~ExRegWrite;

    assign reg_sel[0] = (sel == 2'b00);
    assign reg_sel[1] = (sel == 2'b01);
    assign reg_sel[2] = (sel == 2'b10);
    assign reg_sel[3] = (sel == 2'b11);

    wire EPC_en    = HasExp | (enable_write & reg_sel[0]);
    wire Status_en = enable_write & reg_sel[1];
    wire Block_en  = enable_write & reg_sel[2];

    wire [31:0] EPC_in = HasExp ? PCin : Din;
    reg [31:0] EPC_out, Status_out, Block_out, Cause_out;

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

    assign ExpBlock = Status_out[0];
    assign BlockSrc = Block_out[2:0];
    assign PCout = EPC_out;

    wire [31:0] Cause_in;
    assign Cause_in = ExpSrc0 ? 32'h00000001 :
                      ExpSrc1 ? 32'h00000003 :
                      ExpSrc2 ? 32'h00000007 :
                                  32'bz;

    always @(posedge ExpClick) begin
        Cause_out <= Cause_in;
    end

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

