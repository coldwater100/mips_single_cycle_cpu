module registerfile (
    input wire clk,
    input wire WE,  // Write Enable
    input wire [4:0] reg1_addr,  // Read register 1 address
    input wire [4:0] reg2_addr,  // Read register 2 address
    input wire [4:0] write_addr, // Write register address
    input wire [31:0] write_data,
    output wire [31:0] reg1_data,
    output wire [31:0] reg2_data,
    output wire a0,
    output wire v0
);

    // 32?? 32?? ???? ??
    reg [31:0] registers [0:31];

    // Read operations (???)
    assign reg1_data = registers[reg1_addr];
    assign reg2_data = registers[reg2_addr];

    // Write operation (??)
    always @(posedge clk) begin
        if (WE && write_addr != 0) begin
            registers[write_addr] <= write_data;
        end
    end

endmodule

