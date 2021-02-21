module uart_rx(
    input FPGA_CLK,
    input UART_RXD,
    input KEY1,
    output LED1,
    output LED2);

    reg state = 1'b1;
    reg prev;
    reg [25:0] counter;

    always @(posedge FPGA_CLK) begin
        if (!state) begin
            if (counter == 50_000_000) begin
                counter <= 1'b0;
                state <= 1'b1;
            end else
                counter <= counter + 1;
        end else if (prev && !UART_RXD)
            state <= 1'b0;

        prev <= UART_RXD;
    end

    assign LED1 = KEY1;
    assign LED2 = state;

endmodule
