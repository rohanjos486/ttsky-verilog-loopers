/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module fir_core (
    input [7:0] din,
    input [7:0] x1,
    input [7:0] x2,
    output reg [7:0] dout
);

    wire [9:0] sum;

    // Shift-add implementation
    assign sum = din + (x1 << 1) + x2;

    always @(*) begin
        // Saturation logic
        if (sum > 10'd255)
            dout = 8'd255;
        else
            dout = sum[7:0];
    end

endmodule
