module cpu(clk, instruction_in, out, load_instr, s, reset);
    input clk, load_instr, s, reset;
    input [15:0] instruction_in;
    output [15:0] out;

    localparam SIZE = 8;
    localparam WIDTH = 16;
    localparam ADDR_WIDTH = $clog2(SIZE);

    wire [WIDTH-1:0] instruction, sximm5, sximm8, mdata;
    wire [WIDTH/2-1:0] PC;
    wire [ADDR_WIDTH-1:0] writenum, readnum1, readnum2;
    wire [1:0] shift, aluop, vsel;
    wire write, loada, loadb, asel, bsel, loadc, loads, Z;

    vDFFE #(.WIDTH(WIDTH)) regInstr (.clk(clk), .en(load_instr), .in(instruction_in), .out(instruction));

    wire [3:0] state;
    wire w;
    fsm fsm (.clk(clk), .s(s), .reset(reset), .instruction(instruction), .state(state), .w(w));
    dp_controller #(.NUM_SEL(4)) dp_ctrl (.state(state), .write(write), .loada(loada), .loadb(loadb), .loadc(loadc), .loads(loads), .vsel(vsel));

    // temporary signals
    assign mdata = 16'h0000;
    assign PC = 8'h00;

    instruction_decoder #(.WIDTH(WIDTH)) decoder (.instruction(instruction), .sximm5(sximm5), .sximm8(sximm8), .writenum(writenum), .readnum1(readnum1), .readnum2(readnum2), .shift(shift), .aluop(aluop), .vsel(vsel), .asel(asel), .bsel(bsel));

    datapath #(.WIDTH(WIDTH), .SIZE(SIZE)) dp (.out(out), .vsel(vsel), .writenum(writenum), .write(write), .readnum1(readnum1), .readnum2(readnum2), .clk(clk), .loada(loada), .loadb(loadb), .asel(asel), .bsel(bsel), .shift(shift), .aluop(aluop), .loadc(loadc), .loads(loads), .Z(Z), .sximm5(sximm5), .sximm8(sximm8), .PC(PC), .mdata(mdata));
endmodule