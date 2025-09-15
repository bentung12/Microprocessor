module ourRegister #(m = 3, n = 6)
	(input logic [m-1:0] opcode, input logic clk, input logic rst, input logic [n-1:0] RDContents, input logic [m-1:0] RDAddress, output logic [n-1:0] RAContents, input logic [m-1:0] RAAddress, 
		output logic [n-1:0] RBContents, input logic [m-1:0] RBAddress,  output logic [n-1:0] RFContents, input logic [m-1:0] RFAddress);

		// add clock conditional
		
		logic[m-1:0] writeEn;
		logic[n-1:0] register0, register1, register2, register3, register4, register5, register6, register7; 
		
		assign writeEn = opcode < 3'd5 && opcode != '0;
		
		ourDff #(6) R0 (.clk, .rst, .d(RDContents), .en(RDAddress == '0 && writeEn), .q(register0));
		ourDff #(6) R1 (.clk, .rst, .d(RDContents), .en(RDAddress == 3'd1 && writeEn), .q(register1));
		ourDff #(6) R2 (.clk, .rst, .d(RDContents), .en(RDAddress == 3'd2 && writeEn), .q(register2));
		ourDff #(6) R3 (.clk, .rst, .d(RDContents), .en(RDAddress == 3'd3 && writeEn), .q(register3));
		ourDff #(6) R4 (.clk, .rst, .d(RDContents), .en(RDAddress == 3'd4 && writeEn), .q(register4));
		ourDff #(6) R5 (.clk, .rst, .d(RDContents), .en(RDAddress == 3'd5 && writeEn), .q(register5));
		ourDff #(6) R6 (.clk, .rst, .d(RDContents), .en(RDAddress == 3'd6 && writeEn), .q(register6));
		ourDff #(6) R7 (.clk, .rst, .d(RDContents), .en(RDAddress == 3'd7 && writeEn), .q(register7));
		
		always_comb begin
		 unique case (RAAddress)
			3'd0: RAContents = register0;
			3'd1: RAContents = register1;
			3'd2: RAContents = register2;
			3'd3: RAContents = register3;
			3'd4: RAContents = register4;
			3'd5: RAContents = register5;
			3'd6: RAContents = register6;
			3'd7: RAContents = register7;
			default: RAContents = '0;
		 endcase
		end
		
		always_comb begin
		 unique case (RBAddress)
			3'd0: RBContents = register0;
			3'd1: RBContents = register1;
			3'd2: RBContents = register2;
			3'd3: RBContents = register3;
			3'd4: RBContents = register4;
			3'd5: RBContents = register5;
			3'd6: RBContents = register6;
			3'd7: RBContents = register7;
			default: RBContents = '0;
		 endcase
		end
		
		always_comb begin
		 unique case (RFAddress)
			3'd0: RFContents = register0;
			3'd1: RFContents = register1;
			3'd2: RFContents = register2;
			3'd3: RFContents = register3;
			3'd4: RFContents = register4;
			3'd5: RFContents = register5;
			3'd6: RFContents = register6;
			3'd7: RFContents = register7;
			default: RFContents = '0;
		 endcase
		end		

endmodule
		

		
