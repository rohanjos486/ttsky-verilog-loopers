<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project implements an area-efficient 8-bit streaming FIR (Finite Impulse Response) filter core.

The filter processes one 8-bit input sample per clock cycle and produces a filtered 8-bit output. It is based on a 3-tap FIR structure defined by:

y[n] = x[n] + 2x[n-1] + x[n-2]

The design consists of three main components:

1. Delay Line:
   Stores the previous two input samples using sequential registers.

2. FIR Core:
   Performs shift-add arithmetic to compute the filter output. Multiplication is avoided by using bit shifting (x1 << 1).

3. Saturation Logic:
   Ensures the output remains within 8-bit range (0–255) by clipping overflow values.

The design is fully synchronous and operates on the rising edge of the clock. It is optimized for low area and avoids multipliers to meet strict gate count constraints.


## How to test

1. Apply a clock signal to `clk`.
2. Assert `rst` high for a few cycles, then deassert to begin operation.
3. Provide 8-bit input samples on `din` every clock cycle.
4. Observe the filtered output on `dout`.

Suggested test cases:

- Constant Input:
  Apply a fixed value (e.g., 50). Output should stabilize at a higher value due to filter gain.

- Step Input:
  Transition from 0 to a higher value (e.g., 100). Output should gradually rise, demonstrating smoothing behavior.

- Alternating Input:
  Toggle between two values (e.g., 0 and 200). Output should show reduced variation compared to input.

- Ramp Input:
  Gradually increase input values. Output should follow with smoothing and possible saturation at high values.

Simulation can be performed using standard Verilog tools such as Icarus Verilog or ModelSim.



## External hardware

No external hardware is required.

The design operates entirely on digital inputs:
- `clk`: Clock input
- `rst`: Reset input
- `din[7:0]`: 8-bit input data stream

The output `dout[7:0]` provides the filtered result.

For demonstration purposes, the input can be driven by switches or a microcontroller, and the output can be observed using LEDs or a logic analyzer.
