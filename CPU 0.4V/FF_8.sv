module FF_8 (input logic clk, en, input logic [7:0] in, output logic [7:0] out);

always_ff@(posedge clk && (en == 1)) out = in;

endmodule 