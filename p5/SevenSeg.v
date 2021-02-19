module SevenSeg(
    input FPGA_CLK,
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

    reg [3:0] num = 0;
    reg [25:0] counter = 0;
    reg [6:0] hex_encoding;

    always @(posedge FPGA_CLK) begin
        case (num)
            4'h0: hex_encoding <= 7'h7E;
            4'h1: hex_encoding <= 7'h30;
            4'h2: hex_encoding <= 7'h6D;
            4'h3: hex_encoding <= 7'h79;
            4'h4: hex_encoding <= 7'h33;
            4'h5: hex_encoding <= 7'h5B;
            4'h6: hex_encoding <= 7'h5F;
            4'h7: hex_encoding <= 7'h70;
            4'h8: hex_encoding <= 7'h7F;
            4'h9: hex_encoding <= 7'h7B;
            4'hA: hex_encoding <= 7'h77;
            4'hB: hex_encoding <= 7'h1F;
            4'hC: hex_encoding <= 7'h4E;
            4'hD: hex_encoding <= 7'h3D;
            4'hE: hex_encoding <= 7'h4F;
            4'hF: hex_encoding <= 7'h47;
        endcase
        counter <= counter + 1;
        if (counter == 0)
            num <= num + 1;
    end

    assign {SVNSEG_DIG1, SVNSEG_DIG2, SVNSEG_DIG3, SVNSEG_DIG4} = 4'b0111;
    assign {SVNSEG_SEG0, SVNSEG_SEG1, SVNSEG_SEG2, SVNSEG_SEG3, SVNSEG_SEG4, SVNSEG_SEG5, SVNSEG_SEG6} = ~hex_encoding;
    assign SVNSEG_SEG7 = 1'b1;

endmodule
