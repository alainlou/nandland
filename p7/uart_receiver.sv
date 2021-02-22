/*
 * Note to self: we are using CLKS_PER_BIT-1 because it took one clock period to transition to the new state
 */

module uart_receiver(
    input clk,
    input uart_rxd,
    output reg data_valid,
    output [7:0] data);

    parameter CLKS_PER_BIT = 454_545; // 50 MHz clock, 110 baud rate
    parameter IDLE = 0, START_BIT = 1, DATA_BITS = 2, STOP_BIT = 3, CLEANUP = 4;

    reg [2:0] state = IDLE;
    reg [2:0] bit_index = 0;
    reg [$clog2(CLKS_PER_BIT)-1:0] counter = 0;

    reg [7:0] r_data;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                data_valid <= 1'b0;
                counter <= 0;
                bit_index <= 0;

                if (uart_rxd == 1'b0)
                    // negedge on line
                    state <= START_BIT;
                else
                    state <= IDLE;
            end
            START_BIT: begin
                // need to get to the middle of the start bit
                if (counter == (CLKS_PER_BIT-1)/2) begin
                    if (uart_rxd == 1'b0) begin
                        // the line is still low
                        state <= DATA_BITS;
                        counter <= 0;
                    end else begin
                        // there was a glitch
                        state <= IDLE;
                    end
                end else begin
                    state <= START_BIT;
                    counter <= counter + 1;
                end
            end
            DATA_BITS: begin
                // wait one clock cycle, then sample
                if (counter < CLKS_PER_BIT-1) begin
                    state <= DATA_BITS;
                    counter <= counter + 1;
                end else begin
                    // sample
                    r_data[bit_index] <= uart_rxd;
                    counter <= 0;

                    if (bit_index < 7) begin
                        state <= DATA_BITS;
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP_BIT;
                        bit_index <= 0;
                    end
                end
            end
            STOP_BIT: begin
                // wait one clock cycle, then sample
                if (counter < CLKS_PER_BIT-1) begin
                    state <= STOP_BIT;
                    counter <= counter + 1;
                end else begin
                    data_valid <= 1'b1;
                    counter <= 0;
                    state <= CLEANUP;
                end
            end
            CLEANUP: begin
                data_valid <= 1'b0;
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end

    assign data = r_data;
endmodule
