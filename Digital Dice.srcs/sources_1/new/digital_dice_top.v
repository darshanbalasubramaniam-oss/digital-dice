`timescale 1ns / 1ps
// Top-level for an Artix-7 board with a 100 MHz clock,
// active-high push button and four-digit active-low seven-segment display.
module digital_dice_top #(
    parameter integer CLK_HZ = 100_000_000
) (
    input  wire       clk,
    input  wire       reset,
    input  wire       btn_roll,
    output wire [6:0] seg,   // Active-low segments, ordered {a,b,c,d,e,f,g}
    output wire       dp,    // Active-low decimal point
    output wire [3:0] an     // Active-low digit enables; an[0] is rightmost
);

    wire roll_pulse;
    wire [2:0] dice_value;

    button_debounce #(
        .CLK_HZ(CLK_HZ),
        .DEBOUNCE_MS(20)
    ) u_button_debounce (
        .clk(clk),
        .reset(reset),
        .button_in(btn_roll),
        .button_pulse(roll_pulse)
    );

    digital_dice_core u_digital_dice_core (
        .clk(clk),
        .reset(reset),
        .roll_pulse(roll_pulse),
        .dice_value(dice_value)
    );

    // Show the dice result on the rightmost seven-segment digit.
    // Other digits are disabled. Segment order is abcdefg, active-low.
    reg [6:0] seg_reg;

    always @* begin
        case (dice_value)
            3'd1: seg_reg = 7'b1001111;
            3'd2: seg_reg = 7'b0010010;
            3'd3: seg_reg = 7'b0000110;
            3'd4: seg_reg = 7'b1001100;
            3'd5: seg_reg = 7'b0100100;
            3'd6: seg_reg = 7'b0100000;
            default: seg_reg = 7'b1111111;
        endcase
    end

    assign seg = seg_reg;
    assign dp  = 1'b1;
    assign an  = 4'b1110;

endmodule
