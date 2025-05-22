module instruction_memory (
    input  wire [31:0] pc,      // ???? ??? ??
    output wire [31:0] data     // ?? ???
);
    wire sel = pc[11];                 // ?? 1??? ROM ??
    wire [8:0] word_addr = pc[10:2];   // 9?? word index (512? word)

    wire [8:0] addr_rom0, addr_rom1;
    wire [31:0] data0, data1;

    // DEMUX: word_addr ? ? ROM ? ???? ??
    wire [17:0] addr_bus = {word_addr, word_addr}; // 2×9??
    dmx #(.select_bit(1), .data_bits(9)) addr_dmx (
        .sel(sel),
        .in(addr_bus),
        .data_bus({addr_rom1, addr_rom0})
    );

    // ? ?? ROM ??
    rom0 inst_rom0 (
        .addr(addr_rom0),
        .data(data0)
    );

    rom1 inst_rom1 (
        .addr(addr_rom1),
        .data(data1)
    );

    // MUX: data0 or data1 ? ??
    wire [63:0] data_bus = {data1, data0}; // 2×32??
    mux #(.select_bit(1), .data_bits(32)) data_mux (
        .sel(sel),
        .data_bus(data_bus),
        .out(data)
    );

endmodule


module rom0 (
    input  wire [8:0] addr,
    output wire [31:0] data
);
    reg [31:0] mem [0:511];
    initial begin
        $readmemh("rom0.mem", mem);
    end
    assign data = mem[addr];
endmodule

module rom1 (
    input  wire [8:0] addr,
    output wire [31:0] data
);
    reg [31:0] mem [0:511];
    initial begin
        $readmemh("rom1.mem", mem);
    end
    assign data = mem[addr];
endmodule
