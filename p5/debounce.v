module debounce(
    input clk,
    input in,
    output reg out);

    parameter DEBOUNCE_LIMIT = 500_000; // 10 ms at 50 MHz

    reg state = 1'b0;
    reg [18:0] counter = 0;

    always @(posedge clk) begin
        if (in !== state && counter < DEBOUNCE_LIMIT)
            counter <= 0;
        else if (counter == DEBOUNCE_LIMIT) begin
            counter <= 0;
            out <= state;
        end else
            counter <= counter + 1;
        state <= in;
    end

endmodule
