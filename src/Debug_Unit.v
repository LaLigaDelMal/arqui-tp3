`timescale 1ns / 1ps

module Debug_Unit #(
    parameter       DATA_BITS           = 8,
    parameter       NBITS               = 32,
    parameter       DATA_MEM_SIZE       = 16,
    parameter       INST_MEM_SIZE       = 256,
    parameter       REG_SEL            = 5,
    parameter       REG_SIZE            = 32
)(
    input  wire                  i_clk,             // Clock signal
    input  wire                  i_rst,             // Reset signal
    
    input  wire                  i_uart_data_received,
    input  wire  [DATA_BITS-1:0] i_uart_data,
    input  wire                  i_uart_data_sent,

    input  wire                  i_mips_halt,        // Señal de halt del MIPS
    input  wire  [NBITS-1:0]     i_mips_pc,          // Program counter del MIPS
    input  wire  [NBITS-1:0]     i_mips_clk_count,   // Contador de ciclos del MIPS
    input  wire  [NBITS-1:0]     i_mips_reg_data,    // Registros del MIPS
    input  wire  [NBITS-1:0]     i_mips_mem_data,    // Memoria de datos del MIPS


    output wire                  o_uart_rx_rst,        // Reset signal for the UART Top.
    output wire                  o_uart_tx_rst,        // Reset signal for the UART Top.
    output wire  [DATA_BITS-1:0] o_uart_data,
    output wire                  o_uart_send_data,
    
    output wire                  o_mips_step,        // Control de clock del MIPS
    output wire                  o_mips_rst,         // Control de reset del MIPS
    output wire  [REG_SEL-1:0]   o_mips_reg_sel,     // Registros del MIPS
    output wire  [NBITS-1:0]     o_mips_mem_addr,    // Memoria de datos del MIPS
    output wire  [NBITS-1:0]     o_mips_instr_addr,  // Direccion de la instruccion a escribir
    output wire  [NBITS-1:0]     o_mips_instr_data,  // Dato de la instruccion a escribir
    output wire                  o_mips_instr_write  // Habilita escritura de instruccion
);

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
    localparam REG_COUNT_SIZE  = $clog2(REG_SIZE);
    localparam INST_COUNT_SIZE = $clog2(INST_MEM_SIZE);

    reg         mips_clk_ctrl;

    reg [4:0]   state, state_next;

    reg                         uart_rx_reset, uart_rx_reset_next;
    reg                         uart_tx_reset, uart_tx_reset_next;
    reg [NBITS-1:0]             uart_rx_data_line, uart_rx_data_line_next;
    reg                         uart_rx_inst_write, uart_rx_inst_write_next;
    reg [INST_COUNT_SIZE-1:0]   uart_rx_inst_count, uart_rx_inst_count_next;
    reg [1:0]                   uart_rx_word_count, uart_rx_word_count_next;

    reg [DATA_BITS-1:0]         uart_tx_data, uart_tx_data_next;
    reg                         uart_tx_ready, uart_tx_ready_next;
    reg [NBITS-1:0]             uart_tx_data_word, uart_tx_data_word_next;
    reg [1:0]                   tx_byte_count, tx_byte_count_next;
    reg [2:0]                   tx_data_count, tx_data_count_next;

    reg [REG_COUNT_SIZE-1:0]    tx_regs_count, tx_regs_count_next;
    reg [NBITS-1:0]             tx_mem_count, uart_tx_mem_count_next;

    reg [1:0]                   mips_mode, mips_mode_next;
    reg                         mips_step, mips_step_next;

    reg                         mips_rst, mips_rst_next;

    always @ (posedge i_clk) begin
            if (i_rst) begin
                state                   <= IDLE;
                uart_rx_reset           <= 1;
                uart_tx_reset           <= 1;
                uart_rx_data_line       <= 0;
                uart_rx_word_count      <= 0;
                uart_rx_inst_count      <= 0;
                uart_rx_inst_write      <= 0;
                uart_tx_data            <= 0;
                uart_tx_ready           <= 0;
                tx_byte_count           <= 0;
                tx_data_count           <= 0;
                tx_regs_count           <= 0;
                tx_mem_count            <= 0;
                uart_tx_data_word       <= 0;
                mips_mode               <= MIPS_STOP;
                mips_step               <= 0;
                mips_rst                <= 1;
            end else begin
                state                   <= state_next;
                uart_rx_reset           <= uart_rx_reset_next;
                uart_tx_reset           <= uart_tx_reset_next;
                uart_rx_data_line       <= uart_rx_data_line_next;
                uart_rx_word_count      <= uart_rx_word_count_next;
                uart_rx_inst_count      <= uart_rx_inst_count_next;
                uart_rx_inst_write      <= uart_rx_inst_write_next;
                uart_tx_data            <= uart_tx_data_next;
                uart_tx_ready           <= uart_tx_ready_next;
                tx_byte_count           <= tx_byte_count_next;
                tx_data_count           <= tx_data_count_next;
                tx_regs_count           <= tx_regs_count_next;
                tx_mem_count            <= uart_tx_mem_count_next;
                uart_tx_data_word       <= uart_tx_data_word_next;
                mips_mode               <= mips_mode_next;
                mips_step               <= mips_step_next;
                mips_rst                <= mips_rst_next;
            end
        end

    //state machine
    always @ (*) begin
        state_next          <= state;

        uart_rx_reset_next        <= uart_rx_reset;
        uart_tx_reset_next        <= uart_tx_reset;
        uart_rx_data_line_next    <= uart_rx_data_line;
        uart_rx_word_count_next   <= uart_rx_word_count;
        uart_rx_inst_count_next   <= uart_rx_inst_count;
        uart_rx_inst_write_next   <= uart_rx_inst_write;

        uart_tx_data_next        <= uart_tx_data;
        uart_tx_ready_next       <= uart_tx_ready;
        tx_byte_count_next       <= tx_byte_count;
        tx_data_count_next       <= tx_data_count;
        tx_regs_count_next       <= tx_regs_count;
        uart_tx_mem_count_next   <= tx_mem_count;
        uart_tx_data_word_next   <= uart_tx_data_word;

        mips_mode_next           <= mips_mode;
        mips_step_next           <= mips_step;
        mips_rst_next            <= mips_rst;

        $display("State: %b", state);
        case (state)
            IDLE:
                begin
                    mips_rst_next <= 1;
                    uart_tx_reset_next <= 0;
                    tx_regs_count_next <= 0;
                    uart_tx_mem_count_next <= 0;
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
                    mips_rst_next   <= 0;
                    mips_mode_next  <= MIPS_RUN;

                    if( i_mips_halt ) begin // Viene de MIPS, etapa decodificación (opcode 111111)
                        mips_mode_next  <= MIPS_STOP;
                        state_next      <= PREPARE_TX;
                    end
                end
            STEP:
                begin
                    mips_rst_next       <= 0;
                    mips_mode_next      <= MIPS_STEP;

                    if (i_mips_halt) begin
                        mips_mode_next  <= MIPS_STOP;
                        state_next      <= PREPARE_TX;
                    end

                    if (mips_step) begin
                        mips_step_next <= 0;
                        tx_regs_count_next <= 0;
                        uart_tx_mem_count_next <= 0;
                        state_next     <= PREPARE_TX;
                    end else begin
                        if (~i_uart_data_received) begin  // Verifica si hay datos listos desde la UART
                            uart_rx_reset_next  <= 0;
                        end else begin // Verifica si el char recibido es n (next)
                            uart_rx_reset_next  <= 1;
                            if( i_uart_data == 8'b01101110) begin  // es n
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
                    case(tx_data_count)
                        0: // Envia contenido de PC del MIPS
                            begin
                                uart_tx_data_word_next  <= i_mips_pc;
                                tx_data_count_next      <= tx_data_count + 1;
                                state_next              <= DATA_TX;
                            end
                        1: // Envia cantidad de ciclos realizados desde el inicio
                            begin
                                uart_tx_data_word_next  <= i_mips_clk_count;
                                tx_data_count_next      <= tx_data_count + 1;
                                state_next              <= DATA_TX;
                            end
                        2: // Envia contenido de los 32 registros
                            begin
                                uart_tx_data_word_next  <= i_mips_reg_data;
                                tx_regs_count_next      <= tx_regs_count + 1;
                                
                                if(tx_regs_count == REG_SIZE-1) begin
                                    tx_data_count_next  <= tx_data_count + 1;
                                end

                                state_next              <= DATA_TX;
                            end
                        3:  // Envia contenido de la memoria de datos
                            begin
                                uart_tx_data_word_next <= i_mips_mem_data;
                                uart_tx_mem_count_next <= tx_mem_count + 4;

                                if(tx_mem_count == DATA_MEM_SIZE-4) begin
                                    tx_data_count_next <= tx_data_count + 1;
                                end

                                state_next              <= DATA_TX;
                            end
                        4: // Termino de enviar todos los datos y vuelve a IDLE o STEP
                            begin
                                tx_data_count_next  <= 0;
                                if(mips_mode == MIPS_STEP) begin
                                    state_next           <= STEP;
                                end else begin
                                    state_next           <= IDLE;
                                end
                            end
                        default:
                            begin
                                uart_tx_data_word_next      <= 32'b01100110011000010110100101101100; // FAIL message
                                tx_data_count_next          <= 0;
                                state_next                  <= IDLE;
                            end
                    endcase
                end
            DATA_TX:
                begin
                    uart_tx_data_next       <= uart_tx_data_word[ NBITS-1: NBITS - DATA_BITS];
                    uart_tx_ready_next      <= 1;
                    if (~i_uart_data_sent) begin
                        uart_tx_ready_next       <= 0;
                        tx_byte_count_next       <= tx_byte_count +1;  // registro de dos bits, reinicia por overflow
                        state_next               <= WAIT_TX;
                    end
                end
            WAIT_TX:
                begin
                    if(i_uart_data_sent) begin
                        if(tx_byte_count == 0) begin
                            state_next <= PREPARE_TX;
                        end else begin
                            uart_tx_data_word_next <= uart_tx_data_word << 8;
                            state_next             <= DATA_TX;
                        end
                    end
                end
            default:
                state_next <= IDLE; //default idle state
         endcase
    end

    //Clock y reset de MIPS
    always @(*) begin
        case(mips_mode)
            MIPS_RUN:   mips_clk_ctrl <= 1'b1;
            MIPS_STEP:  mips_clk_ctrl <= mips_step;
            MIPS_STOP:  mips_clk_ctrl <= 1'b0;
            default:    mips_clk_ctrl <= 1'b0;
        endcase
    end

    assign o_uart_send_data     = uart_tx_ready;
    assign o_uart_data          = uart_tx_data;

    assign o_uart_rx_rst           = uart_rx_reset;
    assign o_uart_tx_rst           = uart_tx_reset;

    assign o_mips_step          = mips_clk_ctrl;
    assign o_mips_rst           = mips_rst;
    assign o_mips_reg_sel       = tx_regs_count;
    assign o_mips_mem_addr      = tx_mem_count;

    assign o_mips_instr_addr    = uart_rx_inst_count;
    assign o_mips_instr_data    = uart_rx_data_line;
    assign o_mips_instr_write   = uart_rx_inst_write;

endmodule
