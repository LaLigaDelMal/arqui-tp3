`timescale 1ns / 1ps
//Test bench top

module test_forwarding;

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

// Test forwarding unit
initial begin
    // LUI to set the value 0xFFFF0000 to $t0
    // Removed NOP (00000000) and re-accommodated addresses

    dut.IF.u_Instruction_Memory.memory[0]  = 8'h34;
    dut.IF.u_Instruction_Memory.memory[1]  = 8'h01;
    dut.IF.u_Instruction_Memory.memory[2]  = 8'h00;
    dut.IF.u_Instruction_Memory.memory[3]  = 8'h05;

    dut.IF.u_Instruction_Memory.memory[4]  = 8'h34;
    dut.IF.u_Instruction_Memory.memory[5]  = 8'h02;
    dut.IF.u_Instruction_Memory.memory[6]  = 8'h00;
    dut.IF.u_Instruction_Memory.memory[7]  = 8'h0a;

    dut.IF.u_Instruction_Memory.memory[8]  = 8'h00;
    dut.IF.u_Instruction_Memory.memory[9]  = 8'h22;
    dut.IF.u_Instruction_Memory.memory[10] = 8'h18;
    dut.IF.u_Instruction_Memory.memory[11] = 8'h21;

    dut.IF.u_Instruction_Memory.memory[12] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[13] = 8'h62;
    dut.IF.u_Instruction_Memory.memory[14] = 8'h20;
    dut.IF.u_Instruction_Memory.memory[15] = 8'h21;

    dut.IF.u_Instruction_Memory.memory[16] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[17] = 8'h81;
    dut.IF.u_Instruction_Memory.memory[18] = 8'h28;
    dut.IF.u_Instruction_Memory.memory[19] = 8'h21;

    dut.IF.u_Instruction_Memory.memory[20] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[21] = 8'ha2;
    dut.IF.u_Instruction_Memory.memory[22] = 8'h30;
    dut.IF.u_Instruction_Memory.memory[23] = 8'h24;

    dut.IF.u_Instruction_Memory.memory[24] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[25] = 8'hc1;
    dut.IF.u_Instruction_Memory.memory[26] = 8'h38;
    dut.IF.u_Instruction_Memory.memory[27] = 8'h25;

    dut.IF.u_Instruction_Memory.memory[28] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[29] = 8'h01;
    dut.IF.u_Instruction_Memory.memory[30] = 8'h40;
    dut.IF.u_Instruction_Memory.memory[31] = 8'h80;

    dut.IF.u_Instruction_Memory.memory[32] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[33] = 8'h22;
    dut.IF.u_Instruction_Memory.memory[34] = 8'h48;
    dut.IF.u_Instruction_Memory.memory[35] = 8'h04;

    dut.IF.u_Instruction_Memory.memory[36] = 8'h10;
    dut.IF.u_Instruction_Memory.memory[37] = 8'h21;
    dut.IF.u_Instruction_Memory.memory[38] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[39] = 8'h08;

    dut.IF.u_Instruction_Memory.memory[40] = 8'h20;
    dut.IF.u_Instruction_Memory.memory[41] = 8'h0a;
    dut.IF.u_Instruction_Memory.memory[42] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[43] = 8'h01;

    dut.IF.u_Instruction_Memory.memory[44] = 8'h21;
    dut.IF.u_Instruction_Memory.memory[45] = 8'h4a;
    dut.IF.u_Instruction_Memory.memory[46] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[47] = 8'h01;

    dut.IF.u_Instruction_Memory.memory[48] = 8'h14;
    dut.IF.u_Instruction_Memory.memory[49] = 8'h41;
    dut.IF.u_Instruction_Memory.memory[50] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[51] = 8'h08;

    dut.IF.u_Instruction_Memory.memory[52] = 8'h20;
    dut.IF.u_Instruction_Memory.memory[53] = 8'h0b;
    dut.IF.u_Instruction_Memory.memory[54] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[55] = 8'h02;

    dut.IF.u_Instruction_Memory.memory[56] = 8'h21;
    dut.IF.u_Instruction_Memory.memory[57] = 8'h6b;
    dut.IF.u_Instruction_Memory.memory[58] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[59] = 8'h02;

    dut.IF.u_Instruction_Memory.memory[60] = 8'h08;
    dut.IF.u_Instruction_Memory.memory[61] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[62] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[63] = 8'h40;

    dut.IF.u_Instruction_Memory.memory[64] = 8'h20;
    dut.IF.u_Instruction_Memory.memory[65] = 8'h0c;
    dut.IF.u_Instruction_Memory.memory[66] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[67] = 8'h03;

    dut.IF.u_Instruction_Memory.memory[68] = 8'h0c;
    dut.IF.u_Instruction_Memory.memory[69] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[70] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[71] = 8'h50;

    dut.IF.u_Instruction_Memory.memory[72] = 8'h20;
    dut.IF.u_Instruction_Memory.memory[73] = 8'h0d;
    dut.IF.u_Instruction_Memory.memory[74] = 8'h00;
    dut.IF.u_Instruction_Memory.memory[75] = 8'h04;
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
    #30000;

    // End simulation
    $finish;
end


endmodule
