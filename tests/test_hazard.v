`timescale 1ns / 1ps

module test_hazard;

// Inputs
reg clk;
reg rst;

// Instantiate the module under test
TOP_TOP dut(
    clk,
    rst,
    rx,
    tx
);


////////////////////////// TODO Test program for the hazard unit //////////////////////////
// Any instruction that modifies $t4
////////// LUI $t4 0xFFFF
// Any instruction that modifies $t5
////////// ADDI $t5 $t5 0x0004
// BNE that compares $t4 and $t5 and jumps to a certain address if they are not equal
////////// BNE $t4 $t5 0x0008
// Any instruction that modifies $t6
////////// LUI $t6 0x0001
// NOP
////////// NOP

//******* Test if J or JAL introduces one stall in the pipeline to wait for the address to be selected in the PC (there should be also one delay slot).


//*** Test stalls for the JALR instruction ***//    (PASSED)
/*
//// Write the first address of the data memory
initial begin
    dut.MA.u_Data_Memory.memory[0] = 8'hAA;
    dut.MA.u_Data_Memory.memory[1] = 8'hBB;
    dut.MA.u_Data_Memory.memory[2] = 8'hCD;
    dut.MA.u_Data_Memory.memory[3] = 8'hEF;
end

//// Set registers
initial begin
    dut.ID.Regs.reg_file[7] = 32'h00000000;     // $t0 = 0
end

///// Write program to the instruction memory
initial begin
    // LH $t0 0x0 ($t0)    0x85080000
    dut.IF.u_Instruction_Memory.memory[0] = 8'h85;
    dut.IF.u_Instruction_Memory.memory[1] = 8'h08;
    dut.IF.u_Instruction_Memory.memory[2] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[3] = 8'h00;

    // ADDI $t1 $t0 0x0010    0x21090010
    dut.IF.u_Instruction_Memory.memory[4] = 8'h21;
    dut.IF.u_Instruction_Memory.memory[5] = 8'h09;
    dut.IF.u_Instruction_Memory.memory[6] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[7] = 8'h10;

    // JALR $t2 $t0    0x01005009
    dut.IF.u_Instruction_Memory.memory[8] = 8'h01;
    dut.IF.u_Instruction_Memory.memory[9] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[10] = 8'h50;
    dut.IF.u_Instruction_Memory.memory[11] = 8'h09;

    // NOPs
    dut.IF.u_Instruction_Memory.memory[12] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[13] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[14] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[15] = 8'h00;

    dut.IF.u_Instruction_Memory.memory[16] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[17] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[18] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[19] = 8'h00;
end
*/

//*** Test stalls for the JR instruction ***//
initial begin
    // LUI $t3 0x00F0          0x3C0B00F0
    dut.IF.u_Instruction_Memory.memory[0] = 8'h3C;
    dut.IF.u_Instruction_Memory.memory[1] = 8'h0B;
    dut.IF.u_Instruction_Memory.memory[2] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[3] = 8'hF0;

    // NOP                     0x00000000
    dut.IF.u_Instruction_Memory.memory[4] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[5] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[6] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[7] = 8'h00;

    // JR $t3                  0x01600008
    dut.IF.u_Instruction_Memory.memory[8] = 8'h01;
    dut.IF.u_Instruction_Memory.memory[9] = 8'h60;
    dut.IF.u_Instruction_Memory.memory[10] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[11] = 8'h08;

    // NOPs
    dut.IF.u_Instruction_Memory.memory[12] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[13] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[14] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[15] = 8'h00;

    dut.IF.u_Instruction_Memory.memory[16] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[17] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[18] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[19] = 8'h00;
end


initial begin
    // Reset
    rst = 1;
    #100;
    rst = 0;

    dut.DU.state = 4'b0010;  // RUN state
    //dut.DU.mips_clk_ctrl = 1;
end


initial begin
    clk = 0;
end


// Clock generation
always begin
    #50 clk = ~clk;
end


initial begin
    #3000;

    // End simulation
    $finish;
end

endmodule
