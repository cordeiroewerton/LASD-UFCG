module Parallel_In(input logic [7:0] Address, Data_In, MemData, output logic[7:0] RegData);

always_comb begin
	if(Address == 8'hFF) begin
		RegData = Data_In;
	end
	else begin
		RegData = MemData;
	end
	
end

endmodule 