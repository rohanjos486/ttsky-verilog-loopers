<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This DSP Core is a continuous streaming filter. It takes an 8-bit digital signal on ui_in, processes it through a configurable mathematical pipeline, and outputs the filtered 8-bit result on uo_out.

1. The Configuration Cycle
The module must be configured immediately after powering on or resetting. The very first byte sent to ui_in after the reset pin (rst_n) goes high is captured as the "Configuration Byte".

Bits [1:0] set the Operating Mode.

Bits [3:2] set the Scale (a right-shift divisor to prevent the FIR sum from exceeding 8-bit limits).

Bits [7:4] are ignored.

2. Operating Modes
Once configured, the core enters data-streaming mode. It supports four distinct DSP topologies:

Mode 0 (Low-Pass FIR): Applies a smoothing filter using the coefficients [1, 2, 2, 1].

Mode 1 (FIR + IIR): Applies the Low-Pass FIR and adds recursive feedback from previous outputs (y[n-1]/4 + y[n-2]/8).

Mode 2 (High-Pass FIR): Applies an edge-detecting filter using alternating coefficients [1, -1, 1, -1].

Mode 3 (Full DSP): Combines the Low-Pass FIR, High-Pass FIR, and IIR feedback into a single output.

3. Saturation Protection
To ensure hardware stability, all internal math is computed using 12-bit signed arithmetic. Before reaching uo_out, the final sum is checked. If it exceeds 255, it clamps to 255. If it drops below 0, it clamps to 0. This prevents catastrophic integer wrap-around (e.g., a value of 256 turning into 0) when processing real-world signals.


## How to test

To verify the DSP core on silicon or in simulation, follow this exact sequence:

🔹 Step 1: Load configuration

Apply reset and send one configuration word:

din = {4'b0000, scale, mode}

Example:

mode = 2'b00 → FIR only
scale = 2'b10 → divide by 4
🔹 Step 2: Apply input signals

Test the DSP behavior using different input types:

**Constant input**
Apply a fixed value (e.g., 50)
Observe smoothing and steady-state response
Step input
Transition from 0 → 100
Observe rise time and settling behavior
Ramp input
Gradually increase input
Observe tracking and saturation
Alternating input
Toggle between values (e.g., 0 ↔ 200)
Useful for testing high-pass response (Mode 2)
🔹 Expected behavior
Mode 0 → smooth output
Mode 1 → smoother with decay
Mode 2 → reacts to changes
Mode 3 → combined response with saturation



## External hardware

No external hardware is required.

The design operates entirely on digital inputs:
- `clk`: Clock input
- `rst`: Reset input
- `din[7:0]`: 8-bit input data stream

The output `dout[7:0]` provides the filtered result.

For demonstration purposes, the input can be driven by switches or a microcontroller, and the output can be observed using LEDs or a logic analyzer.
