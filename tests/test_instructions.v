`timescale 1ns / 1ps
//Test bench top

module test_instructions;

// Inputs
reg clk;
reg reset;
reg inst_mem_wr_en;
reg [31:0] inst_mem_addr;
reg [31:0] inst_mem_data;

// Instantiate the module under test
TOP_TOP dut(
    clk,
    reset,
    inst_mem_wr_en,
    inst_mem_addr,
    inst_mem_data
);

initial begin
    clk=0;
end


// Clock generation
always begin
    #50 clk = ~clk;
end


// Test instruction result
initial begin
    //// Tests SLL instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h00094100; // Shift left 4 bits the value in t1 and save it to t0 (SLL $t0 $t1 0x4)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT to be shifted
    dut.ID.Regs.reg_file[9] = 32'h0F0F0F0F;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'hF0F0F0F0) begin
        $display("SLL Test failed: Expected 0xF0F0F0F0, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SLL Test passed: Expected 0xF0F0F0F0, got 0x%h", dut.ID.Regs.reg_file[8]);
    end

    //// Tests SRL instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h00094102; // Shift right 4 bits the value in t1 and save it to t0 (SRL $t0 $t1 0x4)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT to be shifted
    dut.ID.Regs.reg_file[9] = 32'hF0F0F0F0;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h0F0F0F0F) begin
        $display("SRL Test failed: Expected 0x0F0F0F0F, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SRL Test passed: Expected 0x0F0F0F0F, got 0x%h", dut.ID.Regs.reg_file[8]);
    end

    //// Tests SRA instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h00094083; // Shift right 2 bits the value in t1 and save it to t0 (SRA $t0 $t1 0x2)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;
    
    // Store a value in RT to be shifted
    dut.ID.Regs.reg_file[9] = 32'hFFFFFFF0;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'hFFFFFFFC) begin
        $display("SRA Test failed: Expected 0xFFFFFFFC, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SRA Test passed: Expected 0xFFFFFFFC, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests SLLV instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494004; // Shift left 4 bits the value in t1 and save it to t0 (SLLV $t0 $t1 $t2)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT to be shifted
    dut.ID.Regs.reg_file[9] = 32'h0F0F0F0F;
    // Store a value in RS to be the shift amount
    dut.ID.Regs.reg_file[10] = 32'h4;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'hF0F0F0F0) begin
        $display("SLLV Test failed: Expected 0xF0F0F0F0, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SLLV Test passed: Expected 0xF0F0F0F0, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests SRLV instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494006; // Shift right 4 bits the value in t1 and save it to t0 (SRLV $t0 $t1 $t2)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT to be shifted
    dut.ID.Regs.reg_file[9] = 32'hF0F0F0F0;
    // Store a value in RS to be the shift amount
    dut.ID.Regs.reg_file[10] = 32'h4;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h0F0F0F0F) begin
        $display("SRLV Test failed: Expected 0x0F0F0F0F, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SRLV Test passed: Expected 0x0F0F0F0F, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests SRAV instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494007; // Shift right 4 bits the value in t1 and save it to t0 (SRAV $t0 $t1 $t2)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT to be shifted
    dut.ID.Regs.reg_file[9] = 32'hFFFFFFF0;
    // Store a value in RS to be the shift amount
    dut.ID.Regs.reg_file[10] = 32'h2;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'hFFFFFFFC) begin
        $display("SRAV Test failed: Expected 0xFFFFFFFC, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SRAV Test passed: Expected 0xFFFFFFFC, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests ADDU instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494021; // Add the values in t1 and t2 and save it to t0 (ADDU $t0 $t1 $t2)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT
    dut.ID.Regs.reg_file[9] = 32'h00000001;
    // Store a value in RS
    dut.ID.Regs.reg_file[10] = 32'h00000002;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h00000003) begin
        $display("ADDU Test failed: Expected 0x00000003, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("ADDU Test passed: Expected 0x00000003, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests SUBU instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494023; // Subtract the value in rt to rs and save it to t0 (SUBU $t0 $t2 $t1)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT
    dut.ID.Regs.reg_file[9] = 32'h00000001;
    // Store a value in RS
    dut.ID.Regs.reg_file[10] = 32'h00000002;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h00000001) begin
        $display("SUBU Test failed: Expected 0x00000001, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SUBU Test passed: Expected 0x00000001, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests AND instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494024; // AND the values in t1 and t2 and save it to t0 (AND $t0 $t2 $t1)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT
    dut.ID.Regs.reg_file[9] = 32'h10000001;
    // Store a value in RS
    dut.ID.Regs.reg_file[10] = 32'h10000002;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h10000000) begin
        $display("AND Test failed: Expeced 0x10000000, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("AND Test passed: Expected 0x10000000, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests OR instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494025; // OR the values in t1 and t2 and save it to t0 (OR $t0 $t2 $t1)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT
    dut.ID.Regs.reg_file[9] = 32'h10000001;
    // Store a value in RS
    dut.ID.Regs.reg_file[10] = 32'h10000002;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h10000003) begin
        $display("OR Test failed: Expected 0x10000003, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("OR Test passed: Expected 0x10000003, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests XOR instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494026; // XOR the values in t1 and t2 and save it to t0 (XOR $t0 $t2 $t1)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT
    dut.ID.Regs.reg_file[9] = 32'h10000001;
    // Store a value in RS
    dut.ID.Regs.reg_file[10] = 32'h10000002;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h00000003) begin
        $display("XOR Test failed: Expected 0x00000003, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("XOR Test passed: Expected 0x00000003, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests NOR instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h01494027; // NOR the values in t1 and t2 and save it to t0 (NOR $t0 $t2 $t1)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT
    dut.ID.Regs.reg_file[9] = 32'h10000001;
    // Store a value in RS
    dut.ID.Regs.reg_file[10] = 32'h10000002;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'hEFFFFFFC) begin
        $display("NOR Test failed: Expected 0xEFFFFFFC, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("NOR Test passed: Expected 0xEFFFFFFC, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //// Tests SLT instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h0149402A; // Set t0 to 1 if t2 < t1, 0 otherwise (SLT $t0 $t2 $t1)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Store a value in RT
    dut.ID.Regs.reg_file[9] = 32'h00000002;
    // Store a value in RS
    dut.ID.Regs.reg_file[10] = 32'h00000001;
    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h00000001) begin
        $display("SLT Test failed: Expected 0x00000001, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("SLT Test passed: Expected 0x00000001, got 0x%h", dut.ID.Regs.reg_file[8]);
    end


    //TODO Add tests for the following instructions when hazzard detection is implemented (The instruction following the jumnp instruction should be executed and an stall should be inserted in the pipeline)
    //// Tests JR instruction
    //// Tests JALR instruction


    //// Tests LUI instruction
    // Load instruction in memory
    inst_mem_wr_en = 1;
    inst_mem_addr = 0;
    inst_mem_data = 32'h3C080001; // Load 1 in T0 (LUI $t0 0x0001)
    #100;
    inst_mem_wr_en = 0;

    // Reset generation
    reset = 1;
    #100 reset = 0;

    // Wait for a few clock cycles
    #500;

    // Check register value
    if (dut.ID.Regs.reg_file[8] !== 32'h00010000) begin
        $display("LUI Test failed: Expected 0x00010000, got 0x%h", dut.ID.Regs.reg_file[8]);
    end else begin
        $display("LUI Test passed: Expected 0x00010000, got 0x%h", dut.ID.Regs.reg_file[8]);
    end
    

    // End simulation
    $finish;
end

endmodule