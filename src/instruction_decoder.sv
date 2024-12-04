module instruction_decoder(instruction, shift, aluop, sximm5, sximm8, writenum, readnum1, readnum2, asel, bsel, vsel);
    parameter WIDTH = 16;

    input [15:0] instruction;

    output [1:0] shift, aluop;
    output reg [2:0] writenum;
    output [2:0] readnum1, readnum2;
    output [WIDTH-1:0] sximm5, sximm8;
    output tri asel;
    output bsel;
    output tri [1:0] vsel;

    // shift disabled for LDR, STR, and BXX
    assign shift = ^instruction[15:13] ? 2'b00 : instruction[4:3];
    // aluop always at instruction[12:11]
    assign aluop = instruction[12:11];
    // sign extend immediate values
    assign sximm5 = {{WIDTH-5{instruction[4]}}, instruction[4:0]};
    assign sximm8 = {{WIDTH-8{instruction[7]}}, instruction[7:0]};

    always_comb
    casex(instruction[15:12])
        4'b1101: writenum = instruction[10:8]; // write to Rn for MOV immediate
        4'b1xxx: writenum = instruction[7:5]; // write to Rd
        default: writenum = 3'bzzz; // TBD for BXX
    endcase

    // always load Rn to regA
    assign readnum1 = instruction[10:8];
    // load Rm to regB, except for STR (load Rd to regB)
    assign readnum2 = instruction[14:13] == 2'b00 ? instruction[7:5] : instruction[2:0];

    always_comb
    casex(instruction[15:13])
        3'b110: asel = 1; // MOV and MOV immediate
        3'b101: asel = 0; // ADD, CMP, AND, MVn
        3'b011: asel = 0; // LDR
        default: asel = 1'bz; // STR, BXX
    endcase

    assign bsel = (instruction[15:13] == 3'b011 || instruction[15:13] == 3'b100);

    always_comb
    casex(instruction[15:12])
        4'b1101: vsel = 2'b10; // MOV immediate
        4'b0110: vsel = 2'b11; // LDR
        4'b1xxx: vsel = 2'b00; // MOV, ADD, AND, CMP, MVN, STR
        default: vsel = 2'bzz; // BXX
    endcase
endmodule