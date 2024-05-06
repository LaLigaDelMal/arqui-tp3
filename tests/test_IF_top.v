`timescale 1ns / 1ps

module IF_top;
    reg i_clk;
    reg i_rst;
    reg i_sel_jump;
    reg [31:0] i_jump_pc;
    reg i_inst_mem_wr_en;
    reg [31:0] i_inst_mem_data;
    wire [31:0] o_pc;
    wire [31:0] o_instr;

    // Instantiate the Unit Under Test (UUT)
    Instruction_Fetch uut (
        .i_clk(i_clk), 
        .i_rst(i_rst), 
        .i_sel_jump(i_sel_jump), 
        .i_jump_pc(i_jump_pc), 
        .o_pc(o_pc), 
        .o_instr(o_instr), 
        .i_inst_mem_wr_en(i_inst_mem_wr_en), 
        .i_inst_mem_data(i_inst_mem_data)
    );

    initial begin
        // Initialize Inputs
        i_clk               = 0;
        i_rst               = 0;
        i_sel_jump          = 0;
        i_jump_pc           = 0;
        i_inst_mem_wr_en    = 0;
        i_inst_mem_data     = 0;
        
        // Deassert reset
        i_rst = 1;
        #100;
        
        // Assert reset
        i_rst = 0;
        #100;
        
        
        // Stimulate the inputs
        // Add your test sequences here
        
        // Finish the simulation
        $finish;
    end
      
    // Clock generator
    always begin
        #10 i_clk = ~i_clk;
    end
endmodule