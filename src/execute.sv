module ex_stage (
    input  logic [31:0] rs1_data,    // Data from source register 1
    input  logic [31:0] rs2_data,    // Data from source register 2
    input  logic [31:0] imm,         // Immediate value
    input  logic [3:0]  alu_op,      // ALU operation code
    output logic [31:0] alu_result   // Result of ALU operation
);
    always_comb begin
        case (alu_op)
            4'b0000: alu_result = rs1_data + rs2_data; // ADD
            4'b0001: alu_result = rs1_data - rs2_data; // SUB
            4'b0010: alu_result = rs1_data & rs2_data; // AND
            4'b0011: alu_result = rs1_data | rs2_data; // OR
            default: alu_result = 32'h0;
        endcase
    end
endmodule
