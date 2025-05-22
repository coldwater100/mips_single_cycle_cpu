module ALU_decoder(input [5:0] op, output [3:0] ALUop);
//i finished
	assign ALUop[0] = (~op[0]&~op[1]&op[2]&op[3]&~op[4]&op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&op[4]&~op[5]);

	assign ALUop[1] = (~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&~op[4]&~op[5])
| (op[0]&~op[1]&~op[2]&~op[3]&op[4]&op[5])
| (op[0]&~op[1]&op[2]&~op[3]&op[4]&op[5])
| (~op[0]&~op[1]&~op[2]&op[3]&~op[4]&op[5])
| (~op[0]&~op[1]&~op[2]&op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&~op[4]&op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&~op[2]&~op[3]&op[4]&~op[5])
| (~op[0]&~op[1]&~op[2]&~op[3]&op[4]&op[5])
| (~op[0]&op[1]&~op[2]&~op[3]&~op[4]&~op[5]);

	assign ALUop[2] = (~op[0]&~op[1]&op[2]&op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&op[4]&~op[5]);

	assign ALUop[3] = (~op[0]&~op[1]&~op[2]&~op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&~op[4]&~op[5])
| (op[0]&~op[1]&~op[2]&~op[3]&op[4]&op[5])
| (op[0]&~op[1]&op[2]&~op[3]&op[4]&op[5])
| (~op[0]&~op[1]&~op[2]&op[3]&~op[4]&op[5])
| (~op[0]&~op[1]&~op[2]&op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&op[4]&~op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&~op[4]&op[5])
| (~op[0]&~op[1]&op[2]&~op[3]&~op[4]&~op[5])
| (~op[0]&~op[1]&~op[2]&~op[3]&op[4]&~op[5])
| (~op[0]&~op[1]&~op[2]&~op[3]&op[4]&op[5])
| (~op[0]&op[1]&~op[2]&~op[3]&~op[4]&~op[5]);

endmodule


