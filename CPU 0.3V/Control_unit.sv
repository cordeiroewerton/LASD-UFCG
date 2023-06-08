module Control_unit(input logic [5:0] OP, Funct, output logic [2:0] ULAControl, output logic Jump, MemtoReg, MemWrite, Branch, ULASrc, RegDst, RegWrite);

  always_comb begin
    case(OP)
	   7'b0000000: begin
		  case(Funct)
		  7'b100000: begin
		    RegWrite = 1;
		    RegDst = 1;
		    ULASrc = 0;
		    ULAControl = 010;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		  end
		  7'b100010: begin
		    RegWrite = 1;
		    RegDst = 1;
		    ULASrc = 0;
		    ULAControl = 110;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		  end
		  7'b100100: begin
		    RegWrite = 1;
		    RegDst = 1;
		    ULASrc = 0;
		    ULAControl = 000;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		  end
		  7'b100101: begin
		    RegWrite = 1;
		    RegDst = 1;
		    ULASrc = 0;
		    ULAControl = 001;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		  end
		  7'b100111: begin
		    RegWrite = 1;
		    RegDst = 1;
		    ULASrc = 0;
		    ULAControl = 011;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		  end
		  7'b101010: begin
		    RegWrite = 1;
		    RegDst = 1;
		    ULASrc = 0;
		    ULAControl = 111;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		  end
		  default: begin
		    RegWrite = 0;
		    RegDst = 0;
		    ULASrc = 0;
		    ULAControl = 000;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		  end
		
		  endcase
		end
		
		7'b001000: begin
		  RegWrite = 1;
		  RegDst = 0;
		  ULASrc = 1;
		  ULAControl = 010;
		  Branch = 0;
		  MemWrite = 0;
		  MemtoReg = 0;
		  Jump = 0;
		end
		
		7'b100011: begin
		  RegWrite = 1;
		  RegDst = 0;
		  ULASrc = 1;
		  ULAControl = 010;
		  Branch = 0;
		  MemWrite = 0;
		  MemtoReg = 1;
		  Jump = 0;
		end
		
		7'b101011: begin
		  RegWrite = 0;
		  RegDst = 0;
		  ULASrc = 1;
		  ULAControl = 010;
		  Branch = 0;
		  MemWrite = 1;
		  MemtoReg = 1;
		  Jump = 0;
		end
		
		7'b000100: begin
		  RegWrite = 0;
		  RegDst = 0;
		  ULASrc = 0;
		  ULAControl = 110;
		  Branch = 1;
		  MemWrite = 0;
		  MemtoReg = 1;
		  Jump = 0;
		end
		
		7'b100011: begin
		  RegWrite = 0;
		  RegDst = 0;
		  ULASrc = 1;
		  ULAControl = 010;
		  Branch = 0;
		  MemWrite = 0;
		  MemtoReg = 1;
		  Jump = 0;
		end
		
		7'b000010: begin
		  RegWrite = 0;
		  RegDst = 0;
		  ULASrc = 1;
		  ULAControl = 010;
		  Branch = 0;
		  MemWrite = 0;
		  MemtoReg = 1;
		  Jump = 1;
		end
		
		default: begin
		    RegWrite = 0;
		    RegDst = 0;
		    ULASrc = 0;
		    ULAControl = 000;
		    Branch = 0;
		    MemWrite = 0;
		    MemtoReg = 0;
		   Jump = 0;
		end
		
	  endcase
  
  end

endmodule 