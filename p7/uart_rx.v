module uart_rx(
    input FPGA_CLK,
    input UART_RXD,
    input KEY1,
    output LED1,
    output LED2);

    reg state = 1'b1;
    reg [25:0] counter;
    reg prev;

    always @(posedge FPGA_CLK) begin
        if (!UART_RXD && prev) begin
            state <= 1'b0;
            counter <= counter + 1;
        end else if (counter >= 50_000_000) begin
            counter <= 0;
            state <= 1'b1;
        end else
            counter <= counter + 1;
        prev <= UART_RXD;
    end

    assign LED1 = KEY1;
    assign LED2 = state;

endmodule
