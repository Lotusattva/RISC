module datapath(in, out, vsel, writenum, write, readnum1, readnum2, clk, loada, loadb, asel, bsel, shift, aluop, loadc, loads, Z);
    parameter WIDTH = 16;
    parameter SIZE = 8;
    localparam ADDR_WIDTH = $clog2(SIZE);

    input [WIDTH-1:0] in;
    input [ADDR_WIDTH-1:0] writenum, readnum1, readnum2;
    input clk, vsel, write, loada, loadb, asel, bsel, loadc, loads;
    input [1:0] shift, aluop;

    output [WIDTH-1:0] out;
    output Z;

    wire [WIDTH-1:0] regfile_in, regfile_out1, regfile_out2;
    assign regfile_in = vsel ? in : out;

    regfile #(.WIDTH(WIDTH), .SIZE(SIZE)) rf (.data_in(regfile_in), .writenum(writenum), .write(write), .readnum1(readnum1), .readnum2(readnum2), .clk(clk), .data_out1(regfile_out1), .data_out2(regfile_out2));

    wire [WIDTH-1:0] regAout, regBout;
    vDFFE #(.WIDTH(WIDTH)) regA (.clk(clk), .en(loada), .in(regfile_out1), .out(regAout));
    vDFFE #(.WIDTH(WIDTH)) regB (.clk(clk), .en(loadb), .in(regfile_out2), .out(regBout));

    wire [WIDTH-1:0] sout;
    shifter #(.WIDTH(WIDTH)) shifter (.in(regBout), .shift(shift), .out(sout));

    wire [WIDTH-1:0] in_a, in_b;
    assign in_a = asel ? regAout : 16'h0; // placeholder
    assign in_b = bsel ? sout : 16'h0;    // placeholder

    wire [WIDTH-1:0] aluout;
    alu #(.WIDTH(WIDTH)) alu (.in_a(in_a), .in_b(in_b), .op(aluop), .out(aluout));

    vDFFE #(.WIDTH(WIDTH)) regC (.clk(clk), .en(loadc), .in(aluout), .out(out));

    wire Z_in;
    assign Z_in = aluout == {WIDTH{1'b0}};
    vDFFE #(.WIDTH(1)) regS (.clk(clk), .en(loads), .in(Z_in), .out(Z));
endmodule