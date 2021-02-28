module uart_loopback(
    input FPGA_CLK,
    input UART_RXD,
    output UART_TXD,
    output SVNSEG_DIG1,
    output SVNSEG_DIG2,
    output SVNSEG_DIG3,
    output SVNSEG_DIG4,
    output SVNSEG_SEG0,
    output SVNSEG_SEG1,
    output SVNSEG_SEG2,
    output SVNSEG_SEG3,
    output SVNSEG_SEG4,
    output SVNSEG_SEG5,
    output SVNSEG_SEG6,
    output SVNSEG_SEG7,
    output LED1,
    output LED2,
    output LED3,
    output LED4);

    wire rx = !UART_RXD;
    wire tx;
    assign UART_TXD = !tx;
    reg [3:0] count = 0;

    always @(negedge rx) begin
        count <= count + 1;
    end

    assign {LED1, LED2, LED3, LED4} = ~count;

    reg valid;
    reg [7:0] data_byte;

    uart_rx uart_rx_inst(
        .clk(FPGA_CLK),
        .uart_rxd(rx),
        .data_valid(valid),
        .data(data_byte));

    uart_tx uart_tx_inst(
        .clk(FPGA_CLK),
        .data_valid(valid),
        .data(data_byte),
        .uart_txd(tx));

    reg [3:0] top;
    reg [3:0] bot;

    always @(posedge valid) begin
        {top, bot} <= data_byte;
    end

    svnseg_controller controller_inst(
        .clk(FPGA_CLK),
        .num3(4'h0),
        .num2(4'h0),
        .num1(top),
        .num0(bot),
        .dig1(SVNSEG_DIG1),
        .dig2(SVNSEG_DIG2),
        .dig3(SVNSEG_DIG3),
        .dig4(SVNSEG_DIG4),
        .seg0(SVNSEG_SEG0),
        .seg1(SVNSEG_SEG1),
        .seg2(SVNSEG_SEG2),
        .seg3(SVNSEG_SEG3),
        .seg4(SVNSEG_SEG4),
        .seg5(SVNSEG_SEG5),
        .seg6(SVNSEG_SEG6),
        .seg7(SVNSEG_SEG7));

endmodule
