module if_stage (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] pc_in,        // Input program counter
    output logic [31:0] pc_out,       // Output program counter
    output logic [31:0] inst          // Fetched instruction
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc_out <= 32'h0; // Reset PC to 0
        else
            pc_out <= pc_in + 4; // Increment PC
    end

    // Placeholder for fetching instruction from memory
    assign inst = 32'hDEADBEEF; // Temporary instruction for testing
endmodule
