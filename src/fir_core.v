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
    input [7:0] x4,
    output reg [7:0] dout
);

    wire [10:0] sum;
    wire [10:0] scaled;
    //wire [11:0] feedback;
    wire [12:0] final_sum;

    reg [7:0] y_prev, y_prev2;

    // FIR computation
    assign sum = {4'b0000, din} +
                 ({4'b0000, x1} << 1) +
                 ({4'b0000, x2} << 1) +
                 ({4'b0000, x3} << 1) +
                 {4'b0000, x4};

    // FIR scaling (divide by 4)
    assign scaled = sum >> 2;

    // Feedback (y[n-1] / 2)
    wire [10:0] feedback1 = {3'b000, y_prev} >> 2;
    wire [10:0] feedback2 = {3'b000, y_prev2} >> 3;

    // Combine FIR + IIR
    assign final_sum = scaled + feedback1 + feedback2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 0;
            y_prev <= 0;
            y_prev2 <= 0;
        end else begin
            // Saturation
            if (final_sum > 12'd255)
                dout <= 8'd255;
            else
                dout <= final_sum[7:0];

            // Store previous output
            y_prev2 <= y_prev;
            y_prev  <= (final_sum > 12'd255) ? 8'd255 : final_sum[7:0];
        end
    end

endmodule
