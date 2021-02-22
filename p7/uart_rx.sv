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
    output SVNSEG_SEG7,
    output LED1,
    output LED2,
    output LED3,
    output LED4);

    reg [3:0] count = 0;

    always @(negedge UART_RXD) begin
        count <= count + 1;
    end

    assign {LED1, LED2, LED3, LED4} = ~count;


    reg [15:0] time_passed;

    svnseg_controller controller(
        .clk(FPGA_CLK),
        .num3(time_passed[15:12]),
        .num2(time_passed[11:8]),
        .num1(time_passed[7:4]),
        .num0(time_passed[3:0]),
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

    reg prev;
    reg counting;

    always @(posedge FPGA_CLK) begin
        if (!UART_RXD && prev) begin
            counting <= !counting;
        end
        if (counting) begin
            time_passed <= time_passed + 1;
        end
        prev <= UART_RXD;
    end

endmodule
