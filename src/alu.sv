module alu(in_a, in_b, op, out);
    parameter WIDTH = 16;

    input [WIDTH-1:0] in_a, in_b;
    input [1:0] op;
    output [WIDTH-1:0] out;

    wire [WIDTH-1:0] aout, lout;
    au #(.WIDTH(WIDTH)) au1(.in_a(in_a), .in_b(in_b), .rop(op[0]), .out(aout));
    lu #(.WIDTH(WIDTH)) lu1(.in_a(in_a), .in_b(in_b), .rop(op[0]), .out(lout));

    assign out = op[1] ? lout : aout;
endmodule

module au(in_a, in_b, rop, out);
    parameter WIDTH = 16;

    input [WIDTH-1:0] in_a, in_b;
    input rop;
    output [WIDTH-1:0] out;

    assign out = rop ? in_a - in_b : in_a + in_b;
endmodule

module lu(in_a, in_b, rop, out);
    parameter WIDTH = 16;

    input [WIDTH-1:0] in_a, in_b;
    input rop;
    output [WIDTH-1:0] out;

    assign out = rop ? ~in_b : in_a & in_b;
endmodule
