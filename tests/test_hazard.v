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


//*** Test stalls for the JALR instruction ***//    (PASSED)

//// Write the first address of the data memory
initial begin
    // AABB CDEF
    dut.MA.u_Data_Memory.memory[0] = 8'hAA;
    dut.MA.u_Data_Memory.memory[1] = 8'hBB;
    dut.MA.u_Data_Memory.memory[2] = 8'hCD;
    dut.MA.u_Data_Memory.memory[3] = 8'hEF;
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


//*** Test stalls for the JR instruction ***//
/*
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
*/

//*** Test stalls (there should be no stalls) for the J and JAL instructions ***//
/*
initial begin
    // LUI $t3 0x00F0          0x3C0B00F0
    dut.IF.u_Instruction_Memory.memory[0] = 8'h3C;
    dut.IF.u_Instruction_Memory.memory[1] = 8'h0B;
    dut.IF.u_Instruction_Memory.memory[2] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[3] = 8'hF0;

    // J 0x0000003             0x08000003           // Jumps to the second NOP (also executes the following NOP in the delay slot)
    dut.IF.u_Instruction_Memory.memory[4] = 8'h08;
    dut.IF.u_Instruction_Memory.memory[5] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[6] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[7] = 8'h03;

    // NOP
    dut.IF.u_Instruction_Memory.memory[8] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[9] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[10] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[11] = 8'h00;

    // NOP
    dut.IF.u_Instruction_Memory.memory[12] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[13] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[14] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[15] = 8'h00;

    // JAL 0x00000FF           0x0C0000FF
    dut.IF.u_Instruction_Memory.memory[16] = 8'h0C;
    dut.IF.u_Instruction_Memory.memory[17] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[18] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[19] = 8'hFF;

    // NOP
    dut.IF.u_Instruction_Memory.memory[20] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[21] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[22] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[23] = 8'h00;
end
*/


//*** Test stalls for the Branch instructions ***//
/*
initial begin
    // LUI $t4 0xFFFF          0x3C0CFFFF
    dut.IF.u_Instruction_Memory.memory[0] = 8'h3C;
    dut.IF.u_Instruction_Memory.memory[1] = 8'h0C;
    dut.IF.u_Instruction_Memory.memory[2] = 8'hFF;
    dut.IF.u_Instruction_Memory.memory[3] = 8'hFF;

    // ADDI $t5 $t5 0x0004     0x21AD0004
    dut.IF.u_Instruction_Memory.memory[4] = 8'h21;
    dut.IF.u_Instruction_Memory.memory[5] = 8'hAD;
    dut.IF.u_Instruction_Memory.memory[6] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[7] = 8'h04;

    // BNE $t4 $t5 0x0008       0x158D0008
    dut.IF.u_Instruction_Memory.memory[8] = 8'h15;
    dut.IF.u_Instruction_Memory.memory[9] = 8'h8D;
    dut.IF.u_Instruction_Memory.memory[10] = 8'hFF;
    dut.IF.u_Instruction_Memory.memory[11] = 8'hFE;

    // LUI $t6 0x0001           0x3C0E0001
    dut.IF.u_Instruction_Memory.memory[12] = 8'h3C;
    dut.IF.u_Instruction_Memory.memory[13] = 8'h0E;
    dut.IF.u_Instruction_Memory.memory[14] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[15] = 8'h01;

    // NOP
    dut.IF.u_Instruction_Memory.memory[16] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[17] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[18] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[19] = 8'h00;
end
*/

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
