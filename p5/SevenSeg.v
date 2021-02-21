module SevenSeg(
    input FPGA_CLK,
    input KEY1,
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

    wire filtered;
    wire [6:0] svnseg;
    reg [3:0] counter = 0;

    debounce debounce_inst(
        .clk(FPGA_CLK),
        .in(KEY1),
        .out(filtered));

    always @(negedge filtered) begin
        counter <= counter + 1;
    end

    num_to_7seg decoder_inst(
        .in(counter),
        .out(svnseg));

    assign {SVNSEG_DIG4, SVNSEG_DIG3, SVNSEG_DIG2, SVNSEG_DIG1} = 4'b1110;
    assign {SVNSEG_SEG0, SVNSEG_SEG1, SVNSEG_SEG2, SVNSEG_SEG3, SVNSEG_SEG4, SVNSEG_SEG5, SVNSEG_SEG6} = svnseg;
    assign {SVNSEG_SEG7} = 1'b1; // no decimal point
endmodule
