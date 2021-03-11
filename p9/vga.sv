module vga
    (
    input FPGA_CLK,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_R,
    output VGA_G,
    output VGA_B
    );

    reg [9:0] row_counter;
    reg [9:0] col_counter;


    sync_pulse_gen inst
    (
        .clk(FPGA_CLK),
        .HSync(VGA_HSYNC),
        .VSync(VGA_VSYNC),
        .row(row_counter),
        .col(col_counter)
    );

    assign VGA_R = 1'b1;
    assign VGA_G = 1'b1;
    assign VGA_B = 1'b1;

endmodule
