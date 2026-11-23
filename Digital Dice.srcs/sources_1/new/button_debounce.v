`timescale 1ns / 1ps
// Synchronizes and debounces an active-high push button.
// Produces a one-clock pulse for each debounced press.
module button_debounce #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer DEBOUNCE_MS = 20
) (
    input  wire clk,
    input  wire reset,
    input  wire button_in,
    output reg  button_pulse
);

    localparam integer COUNT_MAX = (CLK_HZ / 1000) * DEBOUNCE_MS;
    localparam integer COUNT_WIDTH = (COUNT_MAX < 2) ? 1 : $clog2(COUNT_MAX + 1);

    reg button_meta;
    reg button_sync;
    reg button_stable;
    reg [COUNT_WIDTH-1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            button_meta   <= 1'b0;
            button_sync   <= 1'b0;
            button_stable <= 1'b0;
            count         <= {COUNT_WIDTH{1'b0}};
            button_pulse  <= 1'b0;
        end else begin
            button_meta <= button_in;
            button_sync <= button_meta;
            button_pulse <= 1'b0;

            if (button_sync == button_stable) begin
                count <= {COUNT_WIDTH{1'b0}};
            end else if (count == COUNT_MAX - 1) begin
                count <= {COUNT_WIDTH{1'b0}};
                button_stable <= button_sync;
                if (button_sync)
                    button_pulse <= 1'b1;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule
