module datapath(out, vsel, writenum, write, readnum1, readnum2, clk, loada, loadb, asel, bsel, shift, aluop, loadc, loads, Z, sximm5, sximm8, PC, mdata);
    parameter WIDTH = 16;
    parameter SIZE = 8;
    localparam ADDR_WIDTH = $clog2(SIZE);

    input [WIDTH-1:0] sximm5, sximm8, mdata;
    input [WIDTH/2-1:0] PC;
    input [ADDR_WIDTH-1:0] writenum, readnum1, readnum2;
    input clk, write, loada, loadb, asel, bsel, loadc, loads;
    input [1:0] shift, aluop, vsel;

    output [WIDTH-1:0] out;
    output Z;

    wire [WIDTH-1:0] regfile_in, regAin, regBin, regAout, regBout, sout, in_a, in_b, aluout, regCout;

    wire [WIDTH-1:0] data_in [0:3];
    assign data_in[0] = regCout;
    assign data_in[1] = sximm8;
    assign data_in[2] = {8'h00, PC};
    assign data_in[3] = mdata;
    mux #(.WIDTH(WIDTH), .SIZE(4)) muxRegfile (.data_in(data_in), .sel(vsel), .data_out(regfile_in));

    regfile #(.WIDTH(WIDTH), .SIZE(SIZE)) rf (.data_in(regfile_in), .writenum(writenum), .write(write), .readnum1(readnum1), .readnum2(readnum2), .clk(clk), .data_out1(regAin), .data_out2(regBin));

    vDFFE #(.WIDTH(WIDTH)) regA (.clk(clk), .en(loada), .in(regAin), .out(regAout));
    vDFFE #(.WIDTH(WIDTH)) regB (.clk(clk), .en(loadb), .in(regBin), .out(regBout));

    shifter #(.WIDTH(WIDTH)) shifter (.in(regBout), .shift(shift), .out(sout));

    assign in_a = asel ? regAout : 16'h0000;
    assign in_b = bsel ? sout : sximm5;

    alu #(.WIDTH(WIDTH)) alu (.in_a(in_a), .in_b(in_b), .op(aluop), .out(aluout));

    vDFFE #(.WIDTH(WIDTH)) regC (.clk(clk), .en(loadc), .in(aluout), .out(regCout));

    wire Z_in;
    assign Z_in = aluout == {WIDTH{1'b0}};
    vDFFE #(.WIDTH(1)) regS (.clk(clk), .en(loads), .in(Z_in), .out(Z));

    assign out = regCout;
endmodule