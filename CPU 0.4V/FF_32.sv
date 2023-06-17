module FF_32(input logic [31:0] in, input logic en, clk, output logic [31:0] out);

always_ff@(posedge clk && (en == 1)) out = in;

endmodule 