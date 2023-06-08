`default_nettype none //Comando para desabilitar declaração automática de wires
	module Mod_Teste (
//Clocks
input CLOCK_27, CLOCK_50,
//Chaves e Botoes
input [3:0] KEY,
input [17:0] SW,
//Displays de 7 seg e LEDs
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
output [8:0] LEDG,
output [17:0] LEDR,
//Serial
output UART_TXD,
input UART_RXD,
inout [7:0] LCD_DATA,
output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
//GPIO
inout [35:0] GPIO_0, GPIO_1
);
assign GPIO_1 = 36'hzzzzzzzzz;
assign GPIO_0 = 36'hzzzzzzzzz;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;
wire [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,
w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;
LCD_TEST MyLCD (
.iCLK ( CLOCK_50 ),
.iRST_N ( KEY[0] ),
.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),.d0x4(w_d0x4),.d0x5(w_d0x5),
.d1x0(w_d1x0),.d1x1(w_d1x1),.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5),
.LCD_DATA( LCD_DATA ),
.LCD_RW ( LCD_RW ),
.LCD_EN ( LCD_EN ),
.LCD_RS ( LCD_RS )
);
//---------- modifique a partir daqui --------

wire[31:0] w_Inst;
wire[7:0] w_PCBranch, w_m1, w_nPC, w_wd3, w_ULAResultWd3, w_SrcB, w_rd2, w_rd1SrcA, w_PC, w_PCp1, w_RData, w_RegData;
wire[2:0] w_wa3, w_ULAControl;
wire w_We, w_Jump, w_Branch, w_PCSrc, w_zero, w_RegDst, w_RegWrite, w_ULASrc, w_MemWrite, w_MemtoReg, CLOCK_1;

f_div(.clk_in(CLOCK_50), .clk_out(CLOCK_1));
RegisterFile reg1(.ra1(w_Inst[25:21]), .ra2(w_Inst[20:16]), .wa3(w_wa3), .we3(w_RegWrite), .wd3(w_wd3), .clk(CLOCK_1), .rst(~KEY[3]), .rd1(w_rd1SrcA), .rd2(w_rd2),
.S0(w_d0x0), .S1(w_d0x1), .S2(w_d0x2), .S3(w_d0x3), .S4(w_d1x0), .S5(w_d1x1), .S6(w_d1x2), .S7(w_d1x3));
RomInstMem inst_mem1(.address(w_PC), .q(w_Inst), .clock(CLOCK_50));
PC pc1(.rst(KEY[3]), .PCin(w_nPC), .clk(CLOCK_1), .PC(w_PC));
Control_unit C_unit1(.Jump(w_Jump), .OP(w_Inst[31:26]), .Funct(w_Inst[5:0]), .ULAControl(w_ULAControl[2:0]), .ULASrc(w_ULASrc), .RegDst(w_RegDst), .RegWrite(w_RegWrite), .MemtoReg(w_MemtoReg), .MemWrite(w_MemWrite), .Branch(w_Branch));
ULA ula1(.SrcA(w_rd1SrcA), .SrcB(w_SrcB), .ULAResult(w_ULAResultWd3), .ULAControl(w_ULAControl), .Z(w_zero));
RamDataMem data_mem1(.address(w_ULAResultWd3), .clock(CLOCK_50), .wren(w_We), .q(w_RData), .data(w_rd2));
Parallel_In para_in(.MemData(w_RData), .Address(w_ULAResultWd3), .Data_In(SW[7:0]), .RegData(w_RegData));
Parallel_Out para_out(.RegData(w_rd2), .Address(w_ULAResultWd3), .wren(w_We), .clk(CLOCK_1), .we(w_MemWrite), .DataOut(w_d1x4));

assign w_PCSrc = w_Branch & w_zero;
assign w_wd3 = w_MemtoReg ? w_RegData : w_ULAResultWd3;
assign w_wa3 = w_RegDst ? w_Inst[15:11] : w_Inst[20:16];
assign w_SrcB = w_ULASrc ? w_Inst[7:0] : w_rd2;
assign w_d0x4 = w_PC;
assign w_PCp1 = w_PC+1;
assign w_PCBranch = w_PCp1 + w_Inst[7:0];
assign w_m1 = w_PCSrc ? w_PCBranch : w_PCp1;
assign w_nPC = w_Jump ? w_Inst[7:0] : w_m1;
assign LEDG[0] = ~KEY[1];
assign LEDG[2] = ~KEY[3];
assign LEDR[0] = w_MemtoReg;
assign LEDR[1] = 0;
assign LEDR[2] = 0;
assign LEDR[3] = 0;
assign LEDR[6:4] = w_ULAControl;
assign LEDR[7] = w_ULASrc;
assign LEDR[8] = w_RegDst;
assign LEDR[9] = w_RegWrite;
assign w_d1x5 = w_Jump;
endmodule


/*

assign w_d0x5 = w_rd1SrcA;
assign w_d1x5 = w_SrcB;
assign w_d1x4 = w_ULAResultWd3;

Instr_Mem inst_mem1(.A(w_PC), .RD(w_Inst));

RST = ~KEY[2]

wire[7:0] w_rd1SrcA, w_rd2; 
reg [7:0] w_SrcB;

RegisterFile reg1(.ra1(SW[13:11]), .ra2(3'b010), .wa3(SW[16:14]), .we3(1'b1), .wd3(SW[7:0]), .clk(KEY[1]), .rst(~KEY[2]), .rd1(w_rd1SrcA), .rd2(w_rd2));

always@(SW[17]) begin

  if(SW[17] == 1) begin
    w_SrcB = 8'h07;
  end
  else begin
    w_SrcB = w_rd2;
  end
end
ULA ula1(.SrcA(w_rd1SrcA), .SrcB(w_SrcB), .ULAControl(SW[10:8]), .Z(LEDG[0]), .ULAResult(w_d0x4));

assign w_d0x0 = w_rd1SrcA;
assign w_d1x0 = w_rd2;
assign w_d1x1 = w_SrcB;
assign LEDG[1] = KEY[1];

decod decod1(.in1(SW[3:0]), .out1(HEX0[6:0]));
decod decod2(.in1(SW[7:4]), .out1(HEX1[6:0]));*/
