module vDFFE(clk, en, in, out);
    parameter WIDTH = 16;

    input clk, en;
    input [WIDTH-1:0] in;
    output reg [WIDTH-1:0] out;

    always_ff @(posedge clk)
        out <= en? in : out;
endmodule