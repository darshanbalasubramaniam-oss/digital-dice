`timescale 1ns / 1ps
// Reusable Digital Dice IP-style core.
// A rising edge on roll_pulse captures a pseudo-random value from 1 to 6.
module digital_dice_core (
    input  wire       clk,
    input  wire       reset,
    input  wire       roll_pulse,
    output reg  [2:0] dice_value
);

    reg [15:0] lfsr;
    wire feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

    always @(posedge clk) begin
        if (reset) begin
            lfsr      <= 16'hACE1;
            dice_value <= 3'd1;
        end else begin
            // 16-bit Fibonacci LFSR: pseudo-random sequence generator.
            lfsr <= {lfsr[14:0], feedback};

            if (roll_pulse) begin
                // Convert the sampled LFSR value to the dice range 1..6.
                // This is suitable for a teaching/demo dice, not cryptography.
                dice_value <= (lfsr % 16'd6) + 3'd1;
            end
        end
    end

endmodule
