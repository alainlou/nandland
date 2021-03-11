module sync_pulse_gen
    (
    input clk,
    output HSync,
    output VSync,
    output reg [9:0] row,
    output reg [9:0] col
    );

    parameter TOTAL_COLS  = 800;
    parameter TOTAL_ROWS  = 525;
    parameter ACTIVE_COLS = 640;
    parameter ACTIVE_ROWS = 480;

    always @(posedge clk) begin
        if (col < TOTAL_COLS-1)
            col <= col + 1;
        else begin
            col <= 0;
            if (row < TOTAL_ROWS-1)
                row <= row + 1;
            else
                row <= 0;
        end
    end

    assign HSync = col < ACTIVE_COLS;
    assign VSync = row < ACTIVE_ROWS;

endmodule
