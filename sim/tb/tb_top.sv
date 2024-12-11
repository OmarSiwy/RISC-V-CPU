module tb_top;
    logic clk;
    logic rst;
    logic [3:0] data_out;

    // Instantiate DUT
    top uut (
        .clk(clk),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Stimulus
    initial begin
        rst = 1; #10;
        rst = 0; #100;
        $finish;
    end

    // Dump Waveform
    initial begin
        $dumpfile("../../sim/waves/tb_top.vcd");
        $dumpvars(0, tb_top);
    end
endmodule
