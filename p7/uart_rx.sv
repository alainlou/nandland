/*
 * Note to self: we are using CLKS_PER_BIT-1 because it took one clock period to transition to the new state
 */

module uart_rx(
    input FPGA_CLK,
    input UART_RXD,
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
    output SVNSEG_SEG7);

    wire data_valid;
    wire [7:0] data_byte;
    wire [6:0] svnseg;

    uart_receiver uart_rx_inst(
        .clk(FPGA_CLK),
        .uart_rxd(UART_RXD),
        .data_valid(data_valid),
        .data(data_byte));

    num_to_7seg svnseg_inst(
        .in(data_byte[3:0]),
        .out(svnseg));

    assign {SVNSEG_DIG4, SVNSEG_DIG3, SVNSEG_DIG2, SVNSEG_DIG1} = 4'b1110;
    assign {SVNSEG_SEG0, SVNSEG_SEG1, SVNSEG_SEG2, SVNSEG_SEG3, SVNSEG_SEG4, SVNSEG_SEG5, SVNSEG_SEG6} = svnseg;
    assign {SVNSEG_SEG7} = 1'b1; // no decimal point

endmodule
