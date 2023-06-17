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


logic [31:0] w_Inst, w_Insta, w_data;
logic [2:0] w_wa3, w_ULAControl;
logic [1:0] w_ULASrcB, w_PCSrc;
logic [7:0] w_nPC, w_ULAOut, w_ULAResult, w_wd3, w_rd1a, w_rd2a, w_rd1d, w_rd2d, w_adr, w_PC, w_SrcA, w_SrcB;
logic w_PCEn, w_zero, w_Branch, w_PCWrite, w_ULASrcA, w_RegWrite, w_IorD, w_MemWrite, w_IRWrite, w_MemtoReg, w_RegDst, w_BNZ;

RegisterFile reg1(.ra1(w_Inst[25:21]), .ra2(w_Inst[20:16]), .wa3(w_wa3), .wd3(w_ULAOut), .clk(CLOCK_50), .we3(w_RegWrite), .rd1(w_rd1a), .rd2(w_rd2a));
ULA ula1(.SrcA(w_SrcA), .SrcB(w_SrcB), .ULAResult(w_ULAResult), .ULAControl(w_ULAControl), .Z(w_zero));
FF_8 FF_rd1(.clk(CLOCK_50), .en(1), .in(w_rd1a), .out(w_rd1d)), FF_rd2(.clk(CLOCK_50), .en(1), .in(w_rd2a), .out(w_rd2d)), FF_data(.clk(CLOCK_50), .en(1), .in(w_Insta[7:0]), .out(w_data));
PC pc1(.en(w_PCEn), .PCin(w_nPC), .PC(w_PC), .clk(CLOCK_50), .rst(KEY[3]));
RamDataMem data_mem1(.clock(CLOCK_50), .address(w_ULAResult), .data(w_ULAResult), .q(w_ULAOut), .wren(w_MemWrite));
RomInstMem Inst_mem1(.address(w_adr), .clock(CLOCK_50), .q(w_Insta));
FF_32 FF_Inst(.clk(CLOCK_50), .en(w_IRWrite), .in(w_Insta), .out(w_Inst));
Control_unit unidade1(.Op(w_Inst[31:26]), .Funct(w_Inst[5:0]), .IorD(w_IorD), .MemWrite(w_MemWrite), .IRWrite(w_IRWrite), .PCWrite(w_PCWrite), .Branch(w_Branch), .PCSrc(w_PCSrc), .ULAControl(w_ULAControl), .ULASrcB(w_ULASrcB), .ULASrcA(w_ULASrcA), .RegWrite(w_RegWrite), .MemtoReg(w_MemtoReg), .RegDst(w_RegDst));

assign w_BNZ = w_zero & w_Branch;
assign w_PCEn = w_BNZ | w_PCWrite;
assign w_SrcA = w_ULASrcA ? w_rd1d : w_PC;
assign w_adr = w_IorD ? w_ULAOut : w_PC;
assign w_wd3 = w_MemtoReg ? w_data : w_ULAOut;
assign w_wa3 = w_RegDst ? w_Inst[20:16] : w_Inst[15:11];


//mux SrcB LEMBRAR DE MUDAR PARA W_ULASRCB
always@(*) begin
	if(w_ULASrcB == 2'b00) w_SrcB = w_rd2d;
	else if(w_ULASrcB == 2'b01) w_SrcB = 1;
	else if(w_ULASrcB == 2'b10) w_SrcB = w_Inst[7:0];
	else w_SrcB = w_Inst[7:0];
end



//mux w_nPC
always@(*) begin
	if(w_PCSrc == 2'b00) w_nPC = w_ULAResult;
	else if(w_PCSrc == 2'b01) w_nPC = w_ULAOut;
	else w_nPC = w_Inst[7:0];
end

assign LEDG[0] = ~KEY[1];
assign LEDG[2] = ~KEY[3];
assign LEDR[0] = w_MemtoReg;
assign LEDR[1] = 0;
assign LEDR[2] = 0;
assign LEDR[3] = 0;
assign LEDR[6:4] = w_ULAControl;
assign LEDR[8] = w_RegDst;
assign LEDR[9] = w_RegWrite;

endmodule



/*
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
endmodule */