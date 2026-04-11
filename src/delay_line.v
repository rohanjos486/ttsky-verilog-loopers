/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module delay_line(
    input clk,
    input rst,
    input [7:0] din,
    output reg [7:0] x1,
    output reg [7:0] x2
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 0;
            x2 <= 0;
        end else begin
            x2 <= x1;
            x1 <= din;
        end
    end

endmodule
