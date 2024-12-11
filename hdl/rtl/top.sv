module top (
    input logic clk,
    input logic rst,
    output logic [3:0] data_out
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 4'b0000;
        else
            data_out <= data_out + 1;
    end
endmodule
