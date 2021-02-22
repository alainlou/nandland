module DebounceSwitch(
    input FPGA_CLK,
    input KEY1,
    output LED1);

    reg led_state = 1'b0;
    wire filtered;

    debounce debounce_instance(
        .clk(FPGA_CLK),
        .in(KEY1),
        .out(filtered));

    always @(negedge filtered) begin
        led_state <= !led_state;
    end

    assign LED1 = led_state;

endmodule
