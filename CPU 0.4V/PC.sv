module PC(input logic en, rst, clk, input logic [7:0] PCin, output logic[7:0] PC);

	always_ff@(posedge clk && (en == 1)) begin
		PC = rst ? PCin : 0;
	end

endmodule 