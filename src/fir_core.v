/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module fir_core (
    input clk,
    input rst,
    input [7:0] din,
    input [7:0] x1,
    input [7:0] x2,
    input [7:0] x3,
    output reg [7:0] dout
);

    wire [10:0] sum;
    wire [10:0] scaled;
    wire [10:0] feedback;
    wire [11:0] final_sum;

    reg [7:0] y_prev;

    // FIR computation
    assign sum = {3'b000, din} +
                 ({3'b000, x1} << 1) +
                 ({3'b000, x2} << 1) +
                 {3'b000, x3};

    // FIR scaling (divide by 4)
    assign scaled = sum >> 2;

    // Feedback (y[n-1] / 2)
    assign feedback = {3'b000, y_prev} >> 1;

    // Combine FIR + IIR
    assign final_sum = scaled + feedback;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 0;
            y_prev <= 0;
        end else begin
            // Saturation
            if (final_sum > 12'd255)
                dout <= 8'd255;
            else
                dout <= final_sum[7:0];

            // Store previous output
            y_prev <= (final_sum > 12'd255) ? 8'd255 : final_sum[7:0];
        end
    end

endmodule
