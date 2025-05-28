module ctr_unit(
	input [5:0] op,
	input [5:0] func,
	output memread, memwrite, alusrc, jump, memtoreg, branch, regdst, regwrite, bneorbeq, isjal, zeroextend,
		readrs, readrt,
		issyscall, isjr, isshamt, iscop0,
	output [3:0] aluop
);
	// OP Decoding Area
	Opcode_decoder op_dec (op,
		memread, memwrite, alusrc, jump, memtoreg, branch, regdst, regwrite, bneorbeq, isjal, zeroextend);

	RegisterRead_detector reg_dec (op, func, readrs, readrt);


	// ALU Decoding Area
	wire [3:0] ALU_4b;
	wire [3:0] ALUop;
	wire temp_syscall, temp_jr, temp_shamt;
	wire isspecial;

	Funct_decoder func_dec (func, ALU_4b, temp_jr, temp_syscall, temp_shamt);
	ALU_decoder alu_dec (op, ALUop);

	assign isspecial = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];

	assign issyscall = (isspecial) ? temp_syscall : 0;
	assign isjr = (isspecial) ? temp_jr : 0;
	assign isshamt = (isspecial) ? temp_shamt : 0;
	assign aluop = (~isspecial) ? ALUop : ALU_4b;


	// Exception Handler
	assign iscop0 = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];

endmodule

module Opcode_decoder(
	input [5:0] op,
	output memread, memwrite, alusrc, jump, memtoreg, branch, regdst, regwrite, bneorbeq, isjal, zeroextend);
	
	wire [7:0] jud_alusrc;
	wire [1:0] jud_jump;
	wire [1:0] jud_branch;
	wire [9:0] jud_regwrite;
	wire [1:0] jud_zeroextend;

	assign memread = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];

	assign memwrite = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];

	assign jud_alusrc[0] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_alusrc[1] = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_alusrc[2] = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
	assign jud_alusrc[3] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_alusrc[4] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];
	assign jud_alusrc[5] = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
	assign jud_alusrc[6] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
	assign jud_alusrc[7] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign alusrc = |jud_alusrc;

	assign jud_jump[0] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];
	assign jud_jump[1] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jump = |jud_jump;

	assign memtoreg = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];

	assign jud_branch[0] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
	assign jud_branch[1] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
	assign branch = |jud_branch;

	assign regdst = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];

	assign jud_regwrite[0] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_regwrite[1] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_regwrite[2] = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_regwrite[3] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_regwrite[4] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];
	assign jud_regwrite[5] = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
	assign jud_regwrite[6] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
	assign jud_regwrite[7] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_regwrite[8] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_regwrite[9] = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	assign regwrite = |jud_regwrite;

	assign bneorbeq = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];

	assign isjal = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];

	assign jud_zeroextend[0] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1];
	assign jud_zeroextend[1] = ~op[5] & ~op[4] & op[3] & op[2] & op[1] & ~op[0];
	assign zeroextend = |jud_zeroextend;

endmodule

module RegisterRead_detector(
	input [5:0] op,
	input [5:0] func,
	output readrs, readrt);

	wire [9:0] jud_readrs;
	wire [8:0] jud_readrs_func;

	wire [4:0] jud_readrt;
	wire [10:0] jud_readrt_func;

	//ReadRs
	assign jud_readrs_func[0] = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
	assign jud_readrs_func[1] = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
	assign jud_readrs_func[2] = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & func[0];
	assign jud_readrs_func[3] = func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_readrs_func[4] = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0];
	assign jud_readrs_func[5] = func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0];
	assign jud_readrs_func[6] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_readrs_func[7] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & func[0];
	assign jud_readrs_func[8] = ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];
	and(jud_readrs[0], ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], |jud_readrs_func);
	
	assign jud_readrs[1] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_readrs[2] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
	assign jud_readrs[3] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_readrs[4] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];
	assign jud_readrs[5] = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_readrs[6] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_readrs[7] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
	assign jud_readrs[8] = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
	assign jud_readrs[9] = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
	assign readrs = |jud_readrs;
	

	// ReadRt
	assign jud_readrt_func[0] = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
	assign jud_readrt_func[1] = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & func[0];
	assign jud_readrt_func[2] = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
	assign jud_readrt_func[3] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
	assign jud_readrt_func[4] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];
	assign jud_readrt_func[5] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_readrt_func[6] = func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_readrt_func[7] = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0];
	assign jud_readrt_func[8] = func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0];
	assign jud_readrt_func[9] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_readrt_func[10] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & func[0];
	and(jud_readrt[0], ~op[5], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0], |jud_readrt_func);

	assign jud_readrt[1] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_readrt[2] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
	assign jud_readrt[3] = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_readrt[4] = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
	assign readrt = |jud_readrt;
	
endmodule

module Funct_decoder(
	input [5:0] func,
	output [3:0] ALU_4b,
	output isjr, issyscall, isshamt);

	wire [3:0] jud_alu0;
	wire [3:0] jud_alu1;
	wire [4:0] jud_alu2;
	wire [3:0] jud_alu3;
	wire [2:0] jud_shamt;

	assign jud_alu0[0] = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0];
	assign jud_alu0[1] = func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0];
	assign jud_alu0[2] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_alu0[3] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & func[0];
	assign ALU_4b[3] = |jud_alu0;

	assign jud_alu1[0] = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1];
	assign jud_alu1[1] = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[0];
	assign jud_alu1[2] = func[5] & ~func[4] & ~func[3] & ~func[1] & ~func[0];
	assign jud_alu1[3] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & func[0];
	assign ALU_4b[2] = |jud_alu1;

	assign jud_alu2[0] = func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_alu2[1] = func[5] & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
	assign jud_alu2[2] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_alu2[3] = func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0];
	assign jud_alu2[4] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0];
	assign ALU_4b[1] = |jud_alu2;

	assign jud_alu3[0] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];
	assign jud_alu3[1] = func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1];
	assign jud_alu3[2] = func[5] & ~func[4] & ~func[3] & ~func[1] & ~func[0];
	assign jud_alu3[3] = func[5] & ~func[4] & func[3] & ~func[2] & func[1] & ~func[0];
	assign ALU_4b[0] = |jud_alu3;

	assign isjr = ~func[5] & ~func[4] & func[3] & ~func[2] & ~func[1] & ~func[0];

	assign issyscall = ~func[5] & ~func[4] & func[3] & func[2] & ~func[1] & ~func[0];

	assign jud_shamt[0] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];
	assign jud_shamt[1] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
	assign jud_shamt[2] = ~func[5] & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
	assign isshamt = |jud_shamt;

endmodule

module ALU_decoder(
	input [5:0] op,
	output [3:0] ALUop);

	wire [1:0] jud_aluop0;
	wire [11:0] jud_aluop1;
	wire [1:0] jud_aluop2;
	wire [12:0] jud_aluop3;

	assign jud_aluop0[0] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & op[0];
	assign jud_aluop0[1] = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
	assign ALUop[3] = |jud_aluop0;

	assign jud_aluop1[0] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_aluop1[1] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_aluop1[2] = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_aluop1[3] = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
	assign jud_aluop1[4] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
	assign jud_aluop1[5] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_aluop1[6] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_aluop1[7] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
	assign jud_aluop1[8] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_aluop1[9] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];
	assign jud_aluop1[10] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_aluop1[11] = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	assign ALUop[2] = |jud_aluop1;

	assign jud_aluop2[0] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_aluop2[1] = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
	assign ALUop[1] = |jud_aluop2;

	assign jud_aluop3[0] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_aluop3[1] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_aluop3[2] = op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_aluop3[3] = op[5] & ~op[4] & op[3] & ~op[2] & op[1] & op[0];
	assign jud_aluop3[4] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & op[0];
	assign jud_aluop3[5] = ~op[5] & ~op[4] & ~op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_aluop3[6] = ~op[5] & ~op[4] & op[3] & op[2] & ~op[1] & ~op[0];
	assign jud_aluop3[7] = ~op[5] & ~op[4] & op[3] & ~op[2] & op[1] & ~op[0];
	assign jud_aluop3[8] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & op[0];
	assign jud_aluop3[9] = ~op[5] & ~op[4] & op[3] & ~op[2] & ~op[1] & ~op[0];
	assign jud_aluop3[10] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & ~op[0];
	assign jud_aluop3[11] = ~op[5] & ~op[4] & ~op[3] & ~op[2] & op[1] & op[0];
	assign jud_aluop3[12] = ~op[5] & op[4] & ~op[3] & ~op[2] & ~op[1] & ~op[0];
	assign ALUop[0] = |jud_aluop3;

endmodule
