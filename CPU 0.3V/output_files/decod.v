module decod(input [3:0] in1, output[6:0] out1);

  reg [3:0] word = in1;

  case(word)
    case 0: begin
	   assign out1 = [0, 1, 1, 1, 1, 1, 1];
    end
	 case 1:
	   assign out1 = [0, 0, 0, 0, 1, 1, 0];
	 end
	 case 2:
	   assign out1 = [1, 0, 1, 1, 0, 1, 1];
	 end
	 case 3:
	   assign out1 = [1, 0, 0, 1, 1, 1, 1];
	 end
	 case 4:
	   assign out1 = [1, 1, 0, 0, 1, 1, 0];
	 end
	 case 5:
	   assign out1 = [1, 1, 0, 1, 1, 0, 1];
	 end
	 case 6:
	   assign out1 = [1, 1, 1, 1, 1, 0, 1];
	 end
	 case 7:
	   assign out1 = [1, 0, 0, 0, 1, 1, 1];
	 end
	 case 8:
	   assign out1 = [1, 1, 1, 1, 1, 1, 1];
	 end
	 case 9:
	   assign out1 = [1, 1, 0, 1, 1, 1, 1];
	 end
	 case 10:
	   assign out1 = [1, 1, 1, 0, 1, 1, 1];
	 end
	 case 11:
	   assign out1 = [1, 1, 1, 1, 1, 0, 0];
	 end
	 case 12:
	   assign out1 = [0, 1, 1, 1, 0, 0, 1];
	 end
	 case 13:
	   assign out1 = [1, 0, 1, 1, 1, 1, 0];
	 end
	 case 14:
	   assign out1 = [1, 1, 1, 1, 0, 0, 1];
	 end
	 case 15:
	   assign out1 = [1, 1, 1, 0, 0, 0, 1];
	 end


   endcase

endmodule 