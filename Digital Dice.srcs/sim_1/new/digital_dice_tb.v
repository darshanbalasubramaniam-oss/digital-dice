`timescale 1ns / 1ps

module digital_dice_tb;

    reg clk = 1'b0;
    reg reset = 1'b1;
    reg roll_pulse = 1'b0;
    wire [2:0] dice_value;

    digital_dice_core dut (
        .clk(clk),
        .reset(reset),
        .roll_pulse(roll_pulse),
        .dice_value(dice_value)
    );

    always #5 clk = ~clk; // 100 MHz clock

    integer i;

    initial begin
        $display("Starting Digital Dice testbench...");
        repeat (3) @(posedge clk);
        reset = 1'b0;

        for (i = 0; i < 20; i = i + 1) begin
            @(negedge clk);
            roll_pulse = 1'b1;
            @(negedge clk);
            roll_pulse = 1'b0;
            @(posedge clk);
            #1;
            if ((dice_value < 1) || (dice_value > 6)) begin
                $display("ERROR: dice_value out of range: %0d", dice_value);
                $fatal;
            end
            $display("Roll %0d: dice value = %0d", i + 1, dice_value);
        end

        $display("PASS: every dice result was between 1 and 6.");
        $finish;
    end

endmodule
