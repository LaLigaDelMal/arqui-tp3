`timescale 1ns / 1ps
//Test bench top

module test_debug;

// Inputs
reg clk;
reg reset;
reg rx;


// Instantiate the module under test
TOP_TOP dut(
    clk,
    reset,
    rx
);

initial begin
    clk=0;
end

// Clock generation
always begin
    #5 clk = ~clk;
end

reg [9:0] run   = 10'b1011100100;
reg [9:0] step  = 10'b1011100110;
reg [9:0] load  = 10'b1011011000;
reg [7:0] inst1[3:0];
reg [7:0] inst2[3:0];
reg [7:0] eof[3:0];

integer i;
integer j;

initial begin
    // inst1 3C08FFFF (LUI to set the value 0xFFFF0000 to $t0)
    // 0x3C01FFFF same but in reg $at
    inst1[0] = 8'h3C;
    inst1[1] = 8'h01;
    inst1[2] = 8'hFF;
    inst1[3] = 8'hFF;
    // ins2 AC010000 (sw $at 0x0000 $zero)
    inst2[0] = 8'hAC;
    inst2[1] = 8'h01;
    inst2[2] = 8'h00;
    inst2[3] = 8'h00;

    // eof
    eof[0] = 8'b11111111;
    eof[1] = 8'b11111111;
    eof[2] = 8'b11111111;
    eof[3] = 8'b11111111;

    i = 0;
    j = 0;
end

initial begin
    $display("Test debug");
    // RUN:  01110010
    // STEP: 01110011
    // LOAD: 01110011
    
    rx = 1;
    $display("Reset in progress");
    // Reset
    reset = 1;
    #10;
    reset = 0;
    
    $display("Reset Done");

    $display("Load");
    // lOAD

    // Directiva LOAD (Cargar programa)
    for (i = 0; i < 10; i = i + 1) begin
        rx = load[i];
        $display("RX: %b", load[i]);
        #160;
    end

    // Primera instruccion
    for (i = 0; i < 4; i = i + 1) begin
        rx = 0;
        #160;
        for (j = 0; j < 8; j = j + 1) begin
            rx = inst1[i][j];
            #160;
        end
        rx = 1;
        #160;
    end

    // Segunda instruccion
    for (i = 0; i < 4; i = i + 1) begin
        rx = 0;
        #160;
        for (j = 0; j < 8; j = j + 1) begin
            rx = inst2[i][j];
            #160;
        end
        rx = 1;
        #160;
    end

    // End of file
    for (i = 0; i < 4; i = i + 1) begin
        rx = 0;
        #160;
        for (j = 0; j < 8; j = j + 1) begin
            rx = eof[i][j];
            #160;
        end
        rx = 1;
        #160;
    end

    rx = 1;

    // Directiva RUN (Correr programa)
    for (i = 0; i < 10; i = i + 1) begin
        rx = run[i];
        #160;
    end

    $display("Finish run");

    #30000;
    $finish;

end



endmodule