`timescale 1ns / 1ps


module Debug_Unit #(
    parameter       DATA_BITS           = 8,
    parameter       NBITS               = 32,
    parameter       DATA_MEM_SIZE       = 16,
    parameter       INST_MEM_SIZE       = 256
)(
    input  wire                  i_clk,             // Clock signal
    input  wire                  i_rst,             // Reset signal
    input  wire  [NBITS-1:0]     i_pc,              // Program counter
    input  wire  [4:0]           i_reg_sel,         // Special addresing bus for registers (only for debug unit).
    input  wire  [NBITS-1:0]     i_data_mem_addr,   // Address of the data memory.
    input  wire                  i_uart_data_received,
    input  wire  [DATA_BITS-1:0] i_uart_data,
    input  wire                  i_uart_data_sent,
    output wire                  o_uart_rst,        // Reset signal for the UART Top.
    output wire  [DATA_BITS-1:0] o_uart_data,
    output wire                  o_uart_send_data,
    output wire  [NBITS-1:0]     o_reg_data,        // Data output from the register file.
    output wire  [NBITS-1:0]     o_data_mem,        // Data output from the data memory.
    output wire                  o_inst_mem_wr,     // Write enable for the instruction memory.
    output wire  [NBITS-1:0]     o_inst_mem_addr,   // Address for the instruction memory.
    output wire  [NBITS-1:0]     o_inst_mem_data,   // Data for the instruction memory.
    output wire                  o_reset,           // Restore every state of the processor before runing a new program. (This goes to every reset in the design).
    output wire                  o_enable           // At high by default (should be initialized to 1). It is used to allow the clock to run.
    );

        ////  TODO: interfaz con el procesador
        input                                   i_mips_halt,
        input           [NBITS-1        :0]     i_mips_pc,
        input           [NBITS-1        :0]     i_mips_clk_count,
        input           [NBITS-1        :0]     i_mips_reg,
        input           [NBITS-1        :0]     i_mips_mem,
        output                                  o_mips_clk_ctrl,
        output                                  o_mips_reset_ctrl,
        output          [REGS-1         :0]     o_mips_reg,
        output          [NBITS-1        :0]     o_mips_mem,
        output          [NBITS-1:0]             o_mips_instr_sel,
        output          [NBITS-1        :0]     o_mips_instr_dato,
        output                                  o_mips_instr_write,
        ////

    localparam IDLE         =   4'b0000;
    localparam RUN          =   4'b0010; //Char: 'r'
    localparam STEP         =   4'b0001; //Char: 's'
    localparam LOAD         =   4'b0011; //Char: 'l'
    localparam DATA_TX      =   4'b0100;
    localparam WAIT_TX      =   4'b0110;
    localparam PREPARE_TX   =   4'b0111;
    localparam PREPARE_LOAD =   4'b1000;
    localparam WAIT_LOAD    =   4'b1001;

    localparam MIPS_STOP    =   2'b00;
    localparam MIPS_RUN     =   2'b01;
    localparam MIPS_STEP    =   2'b11;

    localparam MEM_COUNT_SIZE  = $clog2(DATA_MEM_SIZE);
    localparam REG_COUNT_SIZE  = $clog2(MEM_REG_SIZE);
    localparam INST_COUNT_SIZE = $clog2(INST_MEM_SIZE);


    reg         mips_clk_ctrl;

    reg [4:0]   state, state_next;

    reg                         uart_rx_reset, uart_rx_reset_next;
    reg [NBITS-1:0]             uart_rx_data_line, uart_rx_data_line_next;
    reg                         uart_rx_inst_write, uart_rx_inst_write_next;
    reg [INST_COUNT_SIZE-1:0]   uart_rx_inst_count, uart_rx_inst_count_next;
    reg [1:0]                   uart_rx_word_count, uart_rx_word_count_next;

    reg [DATA_BITS-1:0]         uart_tx_data, uart_tx_data_next;
    reg                         uart_tx_ready, uart_tx_ready_next;
    reg [NBITS-1:0]             uart_tx_data_line, uart_tx_data_line_next;
    reg [1:0]                   uart_tx_word_count, uart_tx_word_count_next;
    reg [2:0]                   uart_tx_data_count, uart_tx_data_count_next;

    reg [REG_COUNT_SIZE-1:0]    uart_tx_regs_count, uart_tx_regs_count_next;
    reg [MEM_COUNT_SIZE-1:0]    uart_tx_mem_count, uart_tx_mem_count_next;

    reg [1:0]                   mips_mode, mips_mode_next;
    reg                         mips_step, mips_step_next;

    reg                         mips_reset_ctrl, mips_reset_ctrl_next;

    always @ (posedge clk)
        begin
            if (reset)begin
                state                   <= IDLE;
                uart_rx_reset           <= 1;
                uart_rx_data_line       <= 0;
                uart_rx_word_count      <= 0;
                uart_rx_inst_count      <= 0;
                uart_rx_inst_write      <= 0;
                uart_tx_data            <= 0;
                uart_tx_ready           <= 0;
                uart_tx_word_count      <= 0;
                uart_tx_data_count      <= 0;
                uart_tx_regs_count      <= 0;
                uart_tx_mem_count       <= 0;
                uart_tx_data_line       <= 0;
                mips_mode               <= MIPS_STOP;
                mips_step               <= 0;
                mips_reset_ctrl         <= 1;
            end else begin
                state                   <= state_next;
                uart_rx_reset           <= uart_rx_reset_next;
                uart_rx_data_line       <= uart_rx_data_line_next;
                uart_rx_word_count      <= uart_rx_word_count_next;
                uart_rx_inst_count      <= uart_rx_inst_count_next;
                uart_rx_inst_write      <= uart_rx_inst_write_next;
                uart_tx_data            <= uart_tx_data_next;
                uart_tx_ready           <= uart_tx_ready_next;
                uart_tx_word_count      <= uart_tx_word_count_next;
                uart_tx_data_count      <= uart_tx_data_count_next;
                uart_tx_regs_count      <= uart_tx_regs_count_next;
                uart_tx_mem_count       <= uart_tx_mem_count_next;
                uart_tx_data_line       <= uart_tx_data_line_next;
                mips_mode               <= mips_mode_next;
                mips_step               <= mips_step_next;
                mips_reset_ctrl              <= mips_reset_ctrl_next;
            end
        end

    //state machine
    always @*
    begin
        state_next          <= state;

        uart_rx_reset_next        <= uart_rx_reset;
        uart_rx_data_line_next    <= uart_rx_data_line;
        uart_rx_word_count_next   <= uart_rx_word_count;
        uart_rx_inst_count_next   <= uart_rx_inst_count;
        uart_rx_inst_write_next   <= uart_rx_inst_write;

        uart_tx_data_next        <= uart_tx_data;
        uart_tx_ready_next       <= uart_tx_ready;
        uart_tx_word_count_next  <= uart_tx_word_count;
        uart_tx_data_count_next  <= uart_tx_data_count;
        uart_tx_regs_count_next  <= uart_tx_regs_count;
        uart_tx_mem_count_next   <= uart_tx_mem_count;
        uart_tx_data_line_next   <= uart_tx_data_line;

        mips_mode_next      <= mips_mode;
        mips_step_next      <= mips_step;
        mips_reset_ctrl_next     <= mips_reset_ctrl;

        case (state)
            IDLE:
            begin
                if (~i_uart_data_received) begin        // Verifica si hay datos listos desde la UART
                    uart_rx_reset_next  <= 0;
                end else begin                          // Verifica el char recibido
                    uart_rx_reset_next  <= 1;
                    case(i_uart_data)
                        8'b01110010:    state_next          <= RUN;
                        8'b01110011:    state_next          <= STEP;
                        8'b01101100:    state_next          <= PREPARE_LOAD;
                        default:        state_next          <= IDLE;
                    endcase
                end
            end
            RUN:
            begin
                mips_reset_ctrl_next <= 0;
                mips_mode_next  <= MIPS_RUN;
                if( i_mips_halt ) begin // Viene de MIPS, etapa decodificación (opcode 111111)
                    mips_reset_ctrl_next <= 1; // Resetea el MIPS //TODO Checkear porque reiniciar el MIPS
                    mips_mode_next  <= MIPS_STOP;
                    state_next      <= PREPARE_TX;
                end
            end
            STEP:
            begin
                mips_reset_ctrl_next     <= 0;
                mips_mode_next      <= MIPS_STEP;
                if( i_mips_halt ) begin
                    mips_reset_ctrl_next <= 1;
                    mips_mode_next  <= MIPS_STOP;
                    state_next      <= PREPARE_TX;
                end
                if(mips_step) begin
                    mips_step_next <= 0;
                    state_next     <= PREPARE_TX;
                end else begin
                    if (~i_uart_data_received) begin// Verifica si hay datos listos desde la UART
                        uart_rx_reset_next  <= 0;
                    end else begin // Verifica si el char recibido es n (next)
                        uart_rx_reset_next  <= 1;
                        if( i_uart_data == 8'b01101110) begin
                            mips_step_next <= 1;
                        end
                    end
                end
            end
            PREPARE_LOAD:
            begin
                if (~i_uart_data_received) begin    // Verifica si hay datos listos desde la UART
                    uart_rx_reset_next  <= 0;
                end else begin                      // Verifica el char recibido
                    uart_rx_reset_next      <= 1;
                    uart_rx_data_line_next  <= {uart_rx_data_line[23:0], i_uart_data};  // Concatena el dato recibido con el dato anterior (32 bits) asi no es necesario hacer un shift
                    uart_rx_word_count_next <= uart_rx_word_count + 1;
                    state_next              <= LOAD;
                end
            end
            LOAD:
            begin
                if(uart_rx_word_count == 0) begin
                    uart_rx_inst_write_next <= 1;   // Habilita escritura en posedge de la etapa anterior
                    state_next              <= WAIT_LOAD;
                end else begin
                    state_next              <= PREPARE_LOAD;
                end
            end
            WAIT_LOAD:
            begin
                uart_rx_inst_write_next <= 0;
                if(uart_rx_data_line == 32'b11111111111111111111111111111111) begin
                    uart_rx_inst_count_next <= 0;
                    state_next              <= IDLE;
                end else begin
                    uart_rx_inst_count_next <= uart_rx_inst_count + 4; //Aumenta en 4 la direccion
                    state_next              <= PREPARE_LOAD;
                end
            end
            PREPARE_TX:
            begin
                case(uart_tx_data_count)
                    0: // Envia contenido de PC del MIPS
                    begin
                        uart_tx_data_line_next  <= i_mips_pc;
                        uart_tx_data_count_next <= uart_tx_data_count + 1;
                        state_next              <= DATA_TX;
                    end
                    1: // Envia cantidad de ciclos realizados desde el inicio
                    begin
                        uart_tx_data_line_next  <= i_mips_clk_count;
                        uart_tx_data_count_next <= uart_tx_data_count + 1;
                        state_next              <= DATA_TX;
                    end
                    2: // Envia contenido de los 32 registros
                    begin
                        uart_tx_data_line_next  <= i_mips_reg;
                        uart_tx_regs_count_next <= uart_tx_regs_count + 1;
                        if(uart_tx_regs_count == MEM_REG_SIZE-1) begin
                            uart_tx_data_count_next <= uart_tx_data_count + 1;
                        end
                        state_next              <= DATA_TX;
                    end
                    3:
                    begin
                        uart_tx_data_line_next <= i_mips_mem;
                        uart_tx_mem_count_next <= uart_tx_mem_count + 1;
                        if(uart_tx_mem_count == DATA_MEM_SIZE-1) begin
                            uart_tx_data_count_next <= uart_tx_data_count + 1;
                        end
                        state_next              <= DATA_TX;
                    end
                    4: // Termino de enviar todos los datos y vuelve a IDLE o STEP
                    begin
                        uart_tx_data_count_next  <= 0;
                        if(mips_mode  == MIPS_STEP) begin
                            state_next           <= STEP;
                        end else begin
                            state_next           <= IDLE;
                        end
                    end
                    default:
                    begin
                        uart_tx_data_line_next   <= 32'b01100101011100100111001001101111; // erro
                        uart_tx_data_count_next  <= 0;
                        state_next               <= IDLE;
                    end
                endcase
            end
            DATA_TX:
            begin
                uart_tx_data_next       <= uart_tx_data_line[ NBITS-1: NBITS - DATA_BITS];
                uart_tx_ready_next      <= 1;
                if(~i_uart_data_sent) begin
                   uart_tx_ready_next       <= 0;
                   uart_tx_word_count_next  <= uart_tx_word_count +1;
                   state_next               <= WAIT_TX;
                end
            end
            WAIT_TX:
            begin
                if(i_uart_data_sent) begin
                    if(uart_tx_word_count == 0) begin
                        state_next <= PREPARE_TX;
                    end else begin
                        uart_tx_data_line_next <= uart_tx_data_line << 8;
                        state_next             <= DATA_TX;
                    end
                end
            end
           default:
                state_next <= IDLE; //default idle state
         endcase
    end

    //Clock y reset de MIPS
    always @*
    begin
        case(mips_mode)
            MIPS_RUN:   mips_clk_ctrl <= 1'b1;
            MIPS_STEP:  mips_clk_ctrl <= mips_step;
            MIPS_STOP:  mips_clk_ctrl <= 1'b0;
            default:    mips_clk_ctrl <= 1'b0;
        endcase
    end

    assign o_uart_send_data = uart_tx_ready;
    assign o_uart_data      = uart_tx_data;

    assign o_uart_rst = uart_rx_reset;

    assign o_mips_clk_ctrl = mips_clk_ctrl;
    assign o_mips_reset    = mips_reset_ctrl;
    assign o_mips_reg      = uart_tx_regs_count;
    assign o_mips_mem      = uart_tx_mem_count;

    assign o_mips_instr_sel     = uart_rx_inst_count;
    assign o_mips_instr_dato    = uart_rx_data_line;
    assign o_mips_instr_write   = uart_rx_inst_write;

endmodule
