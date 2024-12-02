module regfile(data_in, writenum, write, readnum1, readnum2, clk, data_out1, data_out2);
    parameter WIDTH = 16;
    parameter SIZE = 8;
    localparam ADDR_WIDTH = $clog2(SIZE);

    input [WIDTH-1:0] data_in;
    input [ADDR_WIDTH-1:0] writenum, readnum1, readnum2;
    input write, clk;
    output [WIDTH-1:0] data_out1, data_out2;

    wire [SIZE-1:0] write_sel;
    binaryToOnehot #(.SIZE(SIZE)) bto (.in(writenum), .out(write_sel));

    wire [WIDTH-1:0] reg_out [0:SIZE-1];
    // instantiate DFFE modules

    genvar i;
    generate
        for (i = 0; i < SIZE; i++) begin: generate_registers
            vDFFE #(.WIDTH(WIDTH)) register (.clk(clk), .en(write & write_sel[i]), .in(data_in), .out(reg_out[i]));
        end
    endgenerate

    mux #(.WIDTH(WIDTH), .SIZE(SIZE)) muxRead1 (.data_in(reg_out), .sel(readnum1), .data_out(data_out1));

    mux #(.WIDTH(WIDTH), .SIZE(SIZE)) muxRead2 (.data_in(reg_out), .sel(readnum2), .data_out(data_out2));

endmodule