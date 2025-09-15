module microprocessor (input logic rst, input logic clk, input logic KEY0, input logic SW1, input logic SW2, input logic SW3, input logic SW4, input logic SW5, input logic SW6, input logic SW7,
				output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2, output logic [6:0] HEX3, output logic [5:0] LED);

(* ram_init_file = "instructions.mif" *) logic [11:0] mem[63:0];

logic [2:0] opcode;
logic [2:0] RAAddress;
logic [2:0] RBAddress;
logic [2:0] RDAddress;
logic [2:0] RFAddress;

logic [5:0] RAContents;
logic [5:0] RBContents;
logic [5:0] RDContents;
logic [5:0] RFContents;
logic [5:0] aluOut;

logic [11:0] instructionCode;
logic [11:0] debugDisplay;
logic [5:0] programCounter;
logic [5:0] nextProgramCounter;

logic [2:0] display3;
logic [2:0] display2;
logic [2:0] display1;
logic [2:0] display0;

logic [25:0] debugTime;
logic debugClk;
logic globalClk;

assign instructionCode = mem[programCounter];
assign {opcode, RAAddress, RBAddress, RDAddress} = instructionCode;
assign RFAddress = {SW7, SW6, SW5};

//Registers
ourRegister OR1(.opcode(opcode), .RAAddress(RAAddress), .RBAddress(RBAddress), .RFAddress(RFAddress), .RDAddress(RDAddress), .RDContents(aluOut), .RAContents(RAContents), .RBContents(RBContents), .RFContents(RFContents), .clk(globalClk), .rst);

//ALU
always_comb begin
	unique case (opcode)
		3'b001 : aluOut = {RAAddress, RBAddress};
		3'b010 : aluOut = RAContents + RBContents;
		3'b011 : aluOut = RAContents + RBAddress;
		3'b100 : aluOut = RAContents * RBContents;
		3'b101 : aluOut = (RAContents >= RBContents) ? (programCounter + RDAddress) : programCounter + 1'b1;
		3'b110 : aluOut = {RAAddress, RBAddress};
		default: aluOut = '0;
	endcase
end

//PC Counter

assign nextProgramCounter = (opcode == 5 || opcode == 6) ? aluOut : (programCounter + 1'b1);

ourDff #(6) PCdff(.clk(globalClk), .rst, .d(nextProgramCounter), .q(programCounter), .en(opcode != '0)); //maybe disable enable for halt?

//Debug MUX
always_comb begin
	unique case({SW4,SW3,SW2}) 
		3'b000 : debugDisplay = RFContents;
		3'b001 : debugDisplay = instructionCode;
		3'b010 : debugDisplay = programCounter;
		3'b011 : debugDisplay = opcode;
		3'b100 : debugDisplay = aluOut;
		3'b101 : debugDisplay = nextProgramCounter;
		default : debugDisplay = 12'b111111111111;
	endcase
end

//Hex Displays

assign {display3, display2, display1, display0} = debugDisplay;

ourHex d0(.s(display0), .z(HEX0));
ourHex d1(.s(display1), .z(HEX1));
ourHex d2(.s(display2), .z(HEX2));
ourHex d3(.s(display3), .z(HEX3));

counter #(50_000_000) c1(.inc(1'b1), .dec('0), .clk, .rst, .cnt(debugTime));

assign debugClk = (debugTime == '0);

assign globalClk = SW1 ? (debugClk && !KEY0) : clk;

assign LED = programCounter;

endmodule
