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

    // ================= FIR =================

    wire [10:0] sum;
    wire [10:0] scaled;

    assign sum = {3'b000, din} +
                 ({3'b000, x1} << 1) +
                 ({3'b000, x2} << 1) +
                 {3'b000, x3};

    assign scaled = sum >> 2;

    // ================= FIR2 =================

    wire signed [10:0] fir2;
    assign fir2 = (
    $signed({3'b000, din})
  - $signed({3'b000, x1})
  + $signed({3'b000, x2})
  - $signed({3'b000, x3})
) >>> 1;   // divide by 2

    // ================= Combine FIRs =================

    wire signed [11:0] fir1_ext = $signed({1'b0, scaled});
    wire signed [11:0] fir2_ext = $signed({fir2[10], fir2});

    wire signed [11:0] combined_fir = fir1_ext + fir2_ext;

    // ================= Feedback =================

    reg [7:0] y_prev, y_prev2;

    wire signed [11:0] feedback1 = $signed({4'b0000, y_prev}) >> 2;
    wire signed [11:0] feedback2 = $signed({4'b0000, y_prev2}) >> 3;

    // ================= Final Sum =================

    wire signed [11:0] final_sum = combined_fir + feedback1 + feedback2;

    // ================= Sequential =================

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout    <= 0;
            y_prev  <= 0;
            y_prev2 <= 0;
        end else begin
            // Saturation
            if (final_sum > 12'sd255)
                dout <= 8'd255;
            else if (final_sum < 12'sd0)
                dout <= 8'd0;
            else
                dout <= final_sum[7:0];

            // Feedback shift register
            y_prev2 <= y_prev;

            y_prev <= (final_sum > 12'sd255) ? 8'd255 :
                      (final_sum < 12'sd0)   ? 8'd0   :
                      final_sum[7:0];
        end
    end

endmodule
