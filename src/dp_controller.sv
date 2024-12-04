`define SEL_C 2'b00
`define SEL_IMM 2'b01

`define S_WAIT 4'b0000
`define S_DECODE 4'b0001
`define S_WRITE_IMM 4'b0010
`define S_LOAD_AB 4'b0011
`define S_LOAD_B 4'b0100
`define S_LOAD_C 4'b0101
`define S_WRITE_C 4'b0110
`define S_LOAD_S 4'b0111

module dp_controller(state,write,loada,loadb,loadc,loads,vsel);
    parameter NUM_SEL = 4; // number of inputs to datapath
    localparam SEL_WIDTH = $clog2(NUM_SEL);


    input [3:0] state;
    output write, loada, loadb, loadc, loads;
    output tri [SEL_WIDTH-1:0] vsel;

    assign write = (state == `S_WRITE_IMM || state == `S_WRITE_C);
    assign loada = (state == `S_LOAD_AB);
    assign loadb = (state == `S_LOAD_AB || state == `S_LOAD_B);
    assign loadc = (state == `S_LOAD_C);
    assign loads = (state == `S_LOAD_S);

    always_comb
    case(state)
        `S_WRITE_IMM: vsel = `SEL_IMM;
        `S_WRITE_C: vsel = `SEL_C;
        default: vsel = 2'bzz;
    endcase

endmodule