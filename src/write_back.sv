module wb_stage (
    input  logic [31:0] alu_result,  // ALU result
    input  logic [31:0] mem_rdata,   // Data read from memory
    input  logic        wb_select,   // Select signal (0: ALU result, 1: memory data)
    output logic [31:0] wb_data      // Data to write back to the register file
);
    always_comb begin
        wb_data = wb_select ? mem_rdata : alu_result; // Choose data source
    end
endmodule
