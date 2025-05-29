module single_cycle_cpu(
	input clk, reset,
	input expsrc0, expsrc1, expsrc2,
	output [10:0] cnt_i, cnt_r, cnt_j, cnt_clk,
	output [31:0] hex
);
	
	// Program Counter
	wire pc_clk;
	reg [31:0] present_pc;
	wire [31:0] next_pc;

	// Instruction Memory
	wire [31:0] instruction;

	// Control Unit
	wire isjal, regwrite, memtoreg, iscop0, memwrite, memread, isjr, branch, bneorbeq, jump,
		alusrc, ischamt, issyscall, regdst, zeroextend, readrs, readrt;
	wire [3:0] aluop;

	// Register File
	wire [4:0] reg1_in;
	wire [4:0] reg2_in;
	wire [4:0] temp_rw;
	wire [4:0] rw;
	wire [31:0] write_data;
	wire we;
	wire [31:0] reg1_out;
	wire [31:0] reg2_out;

	// Sign Extend
	wire [31:0] extend_inst;

	// ALU
	wire [31:0] x_in;
	wire [31:0] y_temp;
	wire [31:0] y_in;
	wire [31:0] alu_out;
	wire equal;

	// Data Memory
	wire [31:0] read_data;
	wire [31:0] mem_out;

	// CP0
	reg [31:0] pc_buf;
	wire [31:0] cp0_pcout;
	wire [31:0] pc_plus4;
	wire [31:0] temp_data;
	wire [31:0] d_out;
	wire exregwrite, iseret, hasexp, expblock;

	// Syscall Decoder
	wire halt;


	// Program Counter


	pc_module my_pc (.PresentPC(present_pc),
		.ExtendInst(extend_inst),
		.Instr(instruction),
		.RegfileR1(reg1_out),
		.EPC(cp0_pcout),
		.Equal(equal),
		.BneOrBeq(bneorbeq),
		.Branch(branch),
		.Jump(jump),
		.IsJR(isjr),
		.IsEret(iseret),
		.IsCOP0(iscop0),
		.HasExp(hasexp),
		.clk(clk),
		.PCOut(next_pc));

	always @(*) begin
    	if (reset)
        	present_pc <= 32'b0;
    	else
        	present_pc <= next_pc;
	end



	// Instruction Memory
	instruction_memory my_instruc (.pc(present_pc),
			.data(instruction));


	// Control Unit
	ctr_unit my_ctrl (.op(instruction[31:26]),
			.func(instruction[5:0]),
			.memread(memread),
			.memwrite(memwrite),
			.alusrc(alusrc),
			.jump(jump),
			.memtoreg(memtoreg),
			.branch(branch),
			.regdst(regdst),
			.regwrite(regwrite),
			.bneorbeq(bneorbeq),
			.isjal(isjal),
			.zeroextend(zeroextend),
			.readrs(readrs),
			.readrt(readrt),
			.issyscall(issyscall),
			.isjr(isjr),
			.isshamt(isshamt),
			.iscop0(iscop0),
			.aluop(aluop));

	// Register File
	assign reg1_in = (issyscall) ? 5'b00010 : instruction[25:21];
	assign reg2_in = (issyscall) ? 5'b00100 : instruction[20:16];
	assign temp_rw = (regdst) ? instruction[15:11] : instruction[20:16];
	assign rw = (isjal) ? 5'b11111 : temp_rw;
	assign we = (iscop0) ? exregwrite : regwrite;

	registerfile my_regfile (.reg1_addr(reg1_in),
				.reg2_addr(reg2_in),
				.write_addr(rw),
				.write_data(write_data),
				.WE(we),
				.clk(clk),
				.reg1_data(reg1_out),
				.reg2_data(reg2_out));
 

	// Sign Extend
	immediate_sign_extend my_signext (.in(instruction[15:0]),
				.ZeroExtend(zeroextend),
				.out(extend_inst));


	// ALU
	assign x_in = (isshamt) ? reg2_out : reg1_out;
	assign y_temp = (alusrc) ? extend_inst : reg2_out;
	assign y_in = (isshamt) ? {{27{1'b0}}, instruction[10:6]} : y_temp;

	alu my_alu (.X(x_in),
		.Y(y_in),
		.S(aluop),
		.Equal(equal),
		.Result(alu_out));


	// Data Memory
	data_memory my_data_mem (.clk(clk),
				.sel(1'b1),
				.str(memwrite),
				.ld(memread),
				.addr(alu_out[11:2]),
				.data_in(reg2_out),
				.data_out(read_data));

	assign mem_out = (memtoreg) ? read_data : alu_out;


	// CP0
	always@(posedge hasexp or posedge reset) begin
		if(reset) pc_buf <= 32'b0;
		else pc_buf <= present_pc;
	end
	CP0 my_cp0 (.Inst(instruction),
		.PCin(pc_buf),
		.Din(reg2_out),
		.ExpSrc0(expsrc0),
		.ExpSrc1(expsrc1),
		.ExpSrc2(expsrc2),
		.clk(clk),
		.reset(reset),
		.enable(iscop0),
		.ExRegWrite(exregwrite),
		.IsEret(iseret),
		.HasExp(hasexp),
		.ExpBlock(expblock),
		.PCout(cp0_pcout),
		.Dout(d_out));

	assign pc_plus4 = present_pc + 32'h00000004;
	assign temp_data = (~isjal) ? mem_out : pc_plus4;
	assign write_data = (~iscop0) ? temp_data : d_out;


	// Syscall Decoder
	syscall_decoder my_sysctrl (.v0(reg1_out),
				.a0(reg2_out),
				.Enable(issyscall),
				.clk(clk),
				.reset(reset),
				.Halt(halt),
				.Hex(hex));

	// Statistics
	statistics my_stat(.clk(clk),
			.reset(reset),
			.op(instruction[31:26]),
			.i(cnt_i),
			.r(cnt_r),
			.j(cnt_j),
			.cnt_clk(cnt_clk));

endmodule

