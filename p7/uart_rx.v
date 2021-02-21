module uart_rx(
	input FPGA_CLK,
    input UART_RXD,
    input KEY1,
    output LED1,
	output LED2);

	reg state = 1'b1;
	reg [25:0] counter;

	always @(posedge FPGA_CLK, negedge UART_RXD) begin
        if (!UART_RXD)
            state <= 1'b0;
            counter <= counter + 1;
        else if (counter >= 50_000_000) begin
            counter <= 0;
            state <= 1'b1;
        end else
            counter <= counter + 1;
	end

    assign LED1 = KEY1;
	assign LED2 = state;

endmodule
