module id_stage (
    input  logic        clk,
    input  logic [31:0] inst,       // Instruction to decode
    output logic [4:0]  rs1,        // Source register 1
    output logic [4:0]  rs2,        // Source register 2
    output logic [4:0]  rd,         // Destination register
    output logic [31:0] imm         // Immediate value
);
    always_comb begin
        // Decode fields of the instruction (simplified example)
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        rd  = inst[11:7];
        imm = {{20{inst[31]}}, inst[31:20]}; // Sign-extended immediate
    end
endmodule
