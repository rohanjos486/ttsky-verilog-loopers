![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# 🎛️ Logic Loopers: Configurable 8-bit Streaming DSP Core

**Team:** Logic Loopers (Rohan Jose, Neelaja Joshi, Megha Murphy Raghunath)

## 📌 Project Overview
The Logic Loopers DSP Core is a fully verified, tapeout-ready digital signal processing block designed for the **Skywater 130nm ASIC node** via the Tiny Tapeout platform. 

It processes continuous 8-bit streaming data and features a configurable datapath supporting both **Finite Impulse Response (FIR)** and **Infinite Impulse Response (IIR)** topologies. Unlike standard combinatorial logic projects, this core implements recursive mathematical feedback, dynamic arithmetic scaling, and robust hardware saturation logic to prevent bit-wrapping on physical silicon.

## 🚀 Key Architectural Features
* **4-Mode Configurable Datapath:**
  * `Mode 0`: Low-Pass FIR only
  * `Mode 1`: FIR + IIR Feedback
  * `Mode 2`: High-Pass FIR only
  * `Mode 3`: Full DSP (FIR_Low + FIR_High + IIR)
* **Dynamic Gain Scaling:** A variable right-shift divisor prevents internal summations from exceeding strict 8-bit limits based on input signal magnitude.
* **Hardware Saturation Protection:** Internal summations use 12-bit signed arithmetic clamped to a final 8-bit unsigned output (0-255). This guarantees acoustic/signal stability by preventing catastrophic integer wrap-around.
* **Efficient Pipelining:** Evaluates complex discrete-time difference equations, producing one output sample per clock cycle after initial configuration.

## 📐 Physical Design & Sign-off
This design has been fully routed through the OpenLane ASIC flow and is 100% tapeout-ready.
* **Target Frequency:** 50 MHz
* **Area Utilization:** 43.68% (Optimal zone for routing safety and hold-fix buffering)
* **DRC / LVS:** 0 Violations (Clean)
* **Timing:** Positive WNS and WHS (Fully constrained clock tree)

## 📖 Official Datasheet & Documentation
For the complete mathematical breakdown, Z-transform difference equations, configuration byte maps, and exact hardware test vectors, please refer to our official project documentation:

👉 **[Read the Full DSP Core Datasheet Here](docs/info.md)**

---

### Local Verification & Simulation
If you wish to simulate this core locally, the repository includes a comprehensive Verilog testbench (`test/tb.v`) that covers all configuration states, saturation bounds, and steady-state IIR convergence limits. 

*To build and test locally:*
1. Clone this repository.
2. Navigate to the `test` directory.
3. Run `make` to execute the test suite via Verilator/Icarus Verilog.
