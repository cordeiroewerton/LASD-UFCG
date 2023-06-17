module Control_unit(input logic [5:0] Op, Funct, input logic clk, rst, output logic [2:0] ULAControl, output logic [1:0] ULASrcB, PCSrc, 
output logic IRWrite, MemWrite, IorD, PCWrite, Branch, ULASrcA, RegWrite, RegDst, MemtoReg);

	parameter [3:0] s0 = 4'b0000; //Fetch
	parameter [3:0] s1 = 4'b0001; //Decode
	parameter [3:0] s2 = 4'b0010; //MemAdr
	parameter [3:0] s3 = 4'b0011; //MemRead
	parameter [3:0] s4 = 4'b0100; //MemWriteBack
	parameter [3:0] s5 = 4'b0101; //MemWrite
	parameter [3:0] s6 = 4'b0110; //Execute
	parameter [3:0] s7 = 4'b0111; //ULAWriteback
	parameter [3:0] s8 = 4'b1000; //Branch
	parameter [3:0] s9 = 4'b1001; //ADDIExecute
	parameter [3:0] s10 = 4'b1010; //ADDIWriteback
	parameter [3:0] s11 = 4'b1011; //Jump
	
	parameter [5:0] R_TYPE = 000000;
	parameter [5:0] LW = 100011;
	parameter [5:0] SW = 101011;
	parameter [5:0] BEQ = 000100;
	parameter [5:0] ADDI = 001000;
	parameter [5:0] J = 000010;
	
	logic [3:0] current_state, next_state;
	//Logica proximo estado
	always_comb begin
		case(current_state)
			s0: next_state = s1;
			s1: begin 
				if((Op == LW) || (Op == SW)) next_state = s2;
				else if (Op == R_TYPE) next_state = s6;
				else if (Op == BEQ) next_state = s8;
				else if (Op == ADDI) next_state = s9;
				else if (Op == J) next_state = s11;
				else next_state = s0;
			end
			s2: begin
				if(Op == LW) next_state = s3;
				else if(Op == SW) next_state = s5;
				else next_state = s0;
			end
			s3: next_state = s4;
			s4: next_state = s0;
			s5: next_state = s0;
			s6: next_state = s7;
			s7: next_state = s0;
			s8: next_state = s0;
			s9: next_state = s10;
			s10: next_state = s0;
			s11: next_state = s0;
			default: next_state = s0;
		endcase
	end
	
	// Reset
	always_ff @(posedge clk) begin
	  current_state <= (rst == 0) ? s0 : next_state;
	end

	
	// logica de saida
	always_comb begin
		case(current_state)
			s0: begin
				IorD = 0;
				ULASrcA = 0;
				ULASrcB = 2'b01;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s1: begin
				IorD = 0;
				ULASrcA = 0;
				ULASrcB = 2'b11;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s2: begin
				IorD = 0;
				ULASrcA = 1;
				ULASrcB = 2'b10;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s3: begin
				IorD = 1;
				ULASrcA = 0;
				ULASrcB = 2'b01;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s4: begin
				IorD = 0;
				ULASrcA = 0;
				ULASrcB = 2'b01;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 1;
				RegDst = 0;
				MemtoReg = 1;
			end
			s5: begin
				IorD = 1;
				ULASrcA = 0;
				ULASrcB = 2'b01;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 1;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s6: begin
				IorD = 0;
				ULASrcA = 1;
				ULASrcB = 2'b00;
				ULAControl = 2'b10;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s7: begin
				IorD = 0;
				ULASrcA = 0;
				ULASrcB = 2'b01;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 1;
				RegDst = 1;
				MemtoReg = 0;
			end
			s8: begin
				IorD = 0;
				ULASrcA = 1;
				ULASrcB = 2'b00;
				ULAControl = 2'b01;
				PCSrc = 2'b01;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 1;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s9: begin
				IorD = 0;
				ULASrcA = 1;
				ULASrcB = 2'b10;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			s10: begin
				IorD = 0;
				ULASrcA = 0;
				ULASrcB = 2'b01;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 1;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 1;
				RegDst = 0;
				MemtoReg = 0;
			end
			s11: begin
				IorD = 0;
				ULASrcA = 0;
				ULASrcB = 2'b00;
				ULAControl = 2'b00;
				PCSrc = 2'b10;
				IRWrite = 0;
				PCWrite = 1;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
			default: begin
				IorD = 0;
				ULASrcA = 0;
				ULASrcB = 2'b00;
				ULAControl = 2'b00;
				PCSrc = 2'b00;
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 0;
				Branch = 0;
				RegWrite = 0;
				RegDst = 0;
				MemtoReg = 0;
			end
		endcase // Faltava esse "end"
	end

endmodule 