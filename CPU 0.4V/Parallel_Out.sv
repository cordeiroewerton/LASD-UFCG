module Parallel_Out(input logic we, clk, input logic [7:0] RegData, Address, output logic wren, output logic [7:0] DataOut);

logic [7:0] registrador;
logic fioA, fioB;

assign fioA = (Address == 8'hFF) ? 1:0;
assign fioB = (fioA) & we;
assign wren = (~fioA) & we;

always_ff@(posedge clk) begin
	if(fioB == 1) begin
		registrador <= RegData;
	end
end

assign DataOut = registrador;
endmodule 