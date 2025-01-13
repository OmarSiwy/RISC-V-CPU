module tb;
    // Clock generation
    logic clk = 0;
    always #5 clk = ~clk;

    // Reset generation
    logic rst_n;
    initial begin
        rst_n = 0;
        #10;
        rst_n = 1;
    end

    // DUT outputs
    logic [31:0] result;

    // DUT instantiation
    cpu dut (
        .clk    (clk),
        .rst_n  (rst_n),
        .result (result)
    );

    // Simple test
    initial begin
        // Wait for reset
        @(posedge rst_n);

        // Run for a few cycles
        repeat(10) @(posedge clk);

        // End simulation
        $finish;
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
