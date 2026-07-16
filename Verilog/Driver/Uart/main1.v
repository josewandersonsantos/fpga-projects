module uart_rx #(
    parameter CLKS_PER_BIT = 434 // Configurado para 50MHz Clock e 115200 Baud
)(
    input            i_Clk,       // Clock do sistema
    input            i_Rx,        // Linha física de recepção UART
    output reg       o_Rx_DV,     // Data Valid (Pulsa em 1 quando o byte está pronto)
    output reg [7:0] o_Rx_Byte    // Byte de dados recebido
);

    // Definição dos estados da FSM
    localparam IDLE         = 3'b000;
    localparam START_BIT    = 3'b001;
    localparam DATA_BITS    = 3'b010;
    localparam STOP_BIT     = 3'b011;
    localparam CLEANUP      = 3'b100;

    reg [2:0] r_SM_Main = IDLE;   // Registrador de estado
    
    // Evita problemas de metaestabilidade na linha assíncrona RX
    reg r_Rx_Data_R = 1'b1;
    reg r_Rx_Data   = 1'b1;
    
    reg [$clog2(CLKS_PER_BIT)-1:0] r_Clk_Count = 0; // Contador de ciclos de clock
    reg [2:0]                      r_Bit_Index = 0; // Índice do bit (0 a 7)
    reg [7:0]                      r_Rx_Byte   = 0; // Registrador temporário de dados

    // Dupla sincronização do sinal de entrada assíncrono
    always @(posedge i_Clk) begin
        r_Rx_Data_R <= i_Rx;
        r_Rx_Data   <= r_Rx_Data_R;
    end

    // Máquina de Estados para amostragem do fluxo UART
    always @(posedge i_Clk) begin
        case (r_SM_Main)
            
            // Aguarda a linha RX ficar em nível lógico baixo (Start Bit)
            IDLE: begin
                o_Rx_DV     <= 1'b0;
                r_Clk_Count <= 0;
                r_Bit_Index <= 0;
                
                if (r_Rx_Data == 1'b0) // Borda de descida detectada
                    r_SM_Main <= START_BIT;
                else
                    r_SM_Main <= IDLE;
            end

            // Verifica se o Start Bit é válido amostrando no meio dele
            START_BIT: begin
                if (r_Clk_Count == (CLKS_PER_BIT - 1) / 2) begin
                    if (r_Rx_Data == 1'b0) begin // Garante que ainda está em 0
                        r_Clk_Count <= 0;        // Reseta o contador para o próximo bit
                        r_SM_Main   <= DATA_BITS;
                    end else begin
                        r_SM_Main   <= IDLE;     // Ruído detectado, volta para IDLE
                    end
                end else begin
                    r_Clk_Count <= r_Clk_Count + 1;
                    r_SM_Main   <= START_BIT;
                end
            end

            // Amostra os 8 bits de dados sequencialmente no meio de cada período
            DATA_BITS: begin
                if (r_Clk_Count < CLKS_PER_BIT - 1) begin
                    r_Clk_Count <= r_Clk_Count + 1;
                    r_SM_Main   <= DATA_BITS;
                end else begin
                    r_Clk_Count          <= 0;
                    r_Rx_Byte[r_Bit_Index] <= r_Rx_Data; // Armazena o bit amostrado
                    
                    if (r_Bit_Index < 7) begin
                        r_Bit_Index <= r_Bit_Index + 1;
                        r_SM_Main   <= DATA_BITS;
                    end else begin
                        r_Bit_Index <= 0;
                        r_SM_Main   <= STOP_BIT;
                    end
                end
            end

            // Amostra o Stop Bit (espera-se nível lógico alto '1')
            STOP_BIT: begin
                if (r_Clk_Count < CLKS_PER_BIT - 1) begin
                    r_Clk_Count <= r_Clk_Count + 1;
                    r_SM_Main   <= STOP_BIT;
                end else begin
                    o_Rx_DV     <= 1'b1;      // Sinaliza que os dados são válidos
                    o_Rx_Byte   <= r_Rx_Byte; // Envia o byte completo para a saída
                    r_Clk_Count <= 0;
                    r_SM_Main   <= CLEANUP;
                end
            end

            // Estado de transição para limpar flags e retornar com segurança ao IDLE
            CLEANUP: begin
                o_Rx_DV   <= 1'b0;
                r_SM_Main <= IDLE;
            end

            default: r_SM_Main <= IDLE;
        endcase
    end
endmodule
