module mem_stage (
    input  logic [31:0] alu_result,  // Address or data for memory access
    input  logic        mem_read,    // Read enable signal
    input  logic        mem_write,   // Write enable signal
    input  logic [31:0] mem_wdata,   // Data to write to memory
    output logic [31:0] mem_rdata    // Data read from memory
);
    always_comb begin
        if (mem_read)
            mem_rdata = alu_result; // Placeholder: memory read
        else
            mem_rdata = 32'h0;      // Default value
    end
endmodule
