// MOV immediate: [vsel=sximm8, write]
// MOV: [asel, loadb] -> [loadc] -> [vsel=C, write]
// ADD: [loada, loadb] -> [loadc] -> [vsel=C, write]
// CMP: [loada, loadb] -> [loads]
// AND: [loada, loadb] -> [loadc] -> [vsel=C, write]
// MVN: [asel, loadb] -> [loadc] -> [vsel=C, write]



`define S_WAIT 4'b0000
`define S_DECODE 4'b0001
`define S_WRITE_IMM 4'b0010
`define S_LOAD_AB 4'b0011
`define S_LOAD_B 4'b0100
`define S_LOAD_C 4'b0101
`define S_WRITE_C 4'b0110
`define S_LOAD_S 4'b0111

`define INSTR_MOV_IMM 5'b11010
`define INSTR_MOV 5'b11000
`define INSTR_ADD 5'b10100
`define INSTR_CMP 5'b10101
`define INSTR_AND 5'b10110
`define INSTR_MVN 5'b10111

module fsm(clk,s,reset,instruction,state,w);

    input clk, s, reset;
    input [15:0] instruction;

    output reg [3:0] state;
    output w;

    wire [4:0] instr;
    assign instr = instruction[15:11];

    always_ff @(posedge clk)
        if (reset)
            state <= `S_WAIT;
        else
            case(state)
                `S_WAIT:
                    if (s)
                        state <= `S_DECODE;
                    else
                        state <= `S_WAIT;
                `S_DECODE:
                    if (instr == `INSTR_MOV_IMM)
                        state <= `S_WRITE_IMM;
                    else if (instr == `INSTR_MOV || instr == `INSTR_MVN)
                        state <= `S_LOAD_B;
                    else if (instr == `INSTR_ADD || instr == `INSTR_CMP || instr == `INSTR_AND)
                        state <= `S_LOAD_AB;
                    else
                        state <= `S_WAIT; // invalid instruction
                `S_LOAD_AB:
                    if (instr == `INSTR_CMP)
                        state <= `S_LOAD_S;
                    else
                        state <= `S_LOAD_C;
                `S_LOAD_B:
                    state <= `S_LOAD_C;
                `S_LOAD_C:
                    state <= `S_WRITE_C;
                default:
                    state <= `S_WAIT;
            endcase

    assign w = (state == `S_WAIT);
                    
endmodule
