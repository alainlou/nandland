/*
 * Note to self: we are using CLKS_PER_BIT-1 because it took one clock period to transition to the new state
 */

module uart_receiver(
    input clk,
    input uart_rxd,
    output reg data_valid,
    output reg [7:0] data);

    parameter CLKS_PER_BIT = 433; // 50 MHz clock, 115 200 baud rate, 433 is experimental
    parameter IDLE = 0, START = 1, SAMPLING = 2;

    reg [2:0] state = IDLE;
    reg [3:0] bit_index = 0;
    reg [8:0] counter = 0;

    reg prev;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (uart_rxd == 1'b0 && prev)
                    state <= START;
                else
                    state <= IDLE;
            end
            START: begin
                if (counter < CLKS_PER_BIT/2) begin
                    counter <= counter + 1;
                    state <= START;
                end else begin
                    counter <= 0;
                    state <= SAMPLING;
                end
            end
            SAMPLING: begin
                if (counter < CLKS_PER_BIT) begin
                    counter <= counter + 1;
                    state <= SAMPLING;
                end else begin
                    if (bit_index < 8) begin
                        data[bit_index] <= uart_rxd;
                        bit_index <= bit_index + 1;
                        state <= SAMPLING;
                    end else begin
                        bit_index <= 0;
                        state <= IDLE;
                    end
                    counter <= 0;
                end
            end
        endcase
        prev <= uart_rxd;
    end

endmodule
