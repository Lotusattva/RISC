module shifter(in, shift, out);
    parameter WIDTH = 16;

    input [WIDTH-1:0] in;
    input [1:0] shift;
    output [WIDTH-1:0] out;

    assign out = shift[1] ? {{in[WIDTH-1] & shift[0]}, in[WIDTH-1:1]} : in << shift[0];
endmodule
