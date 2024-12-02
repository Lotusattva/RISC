module mux(data_in, sel, data_out);
    parameter WIDTH = 16;
    parameter SIZE = 8;
    localparam ADDR_WIDTH = $clog2(SIZE);

    input [WIDTH-1:0] data_in [0:SIZE-1];
    input [ADDR_WIDTH-1:0] sel;
    output [WIDTH-1:0] data_out;

    assign data_out = data_in[sel];
endmodule