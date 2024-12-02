module binaryToOnehot(in, out);
    parameter SIZE = 8;
    localparam ADDR_WIDTH = $clog2(SIZE);

    input [ADDR_WIDTH-1:0] in;
    output [SIZE-1:0] out;

    assign out = 1 << in + 1;
endmodule