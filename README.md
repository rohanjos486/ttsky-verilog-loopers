![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# 🎛️ Logic Loopers: Configurable 8-bit Streaming DSP Core

**Team:** Logic Loopers (Rohan Jose, Neelaja Joshi, Megha Murphy Raghunath)

---

## 📌 Project Overview
The Logic Loopers DSP Core is a fully verified, tapeout-ready digital signal processing block designed for the **Skywater 130nm ASIC node** via the Tiny Tapeout platform. 

It processes continuous 8-bit streaming data and features a configurable datapath supporting both **Finite Impulse Response (FIR)** and **Infinite Impulse Response (IIR)** topologies.  

This design goes beyond simple combinational logic by implementing recursive feedback (IIR), dynamic scaling, and saturation-aware arithmetic suitable for real signal processing workloads.

---

## 🚀 Key Architectural Features
* **4-Mode Configurable Datapath:**
  * `Mode 0`: Low-Pass FIR only
  * `Mode 1`: FIR + IIR Feedback
  * `Mode 2`: High-Pass FIR only
  * `Mode 3`: Full DSP (FIR_Low + FIR_High + IIR)
* **Dynamic Gain Scaling:** A variable right-shift divisor prevents internal summations from exceeding strict 8-bit limits based on input signal magnitude.
* **Hardware Saturation Protection:** Internal summations use 12-bit signed arithmetic clamped to a final 8-bit unsigned output (0–255), preventing overflow wrap-around.
* **Efficient Pipelining:** Produces one output sample per clock cycle after initial configuration latency.

---

## 🧩 Architecture Summary

The DSP core combines:
- FIR datapath (feedforward)
- IIR feedback loop
- Configurable scaling stage
- Saturation output stage

All blocks are pipelined for continuous streaming operation.

---  

## 🧱 Block Diagram

```
          +-------------------+
ui_in --->|   FIR (Low-pass)  |---+
          +-------------------+   |
                                  +--> +-------------------+
          +-------------------+   |    |                   |
ui_in --->|  FIR2 (High-pass) |---+--> |    SUM (Adder)    | ---> Scaling ---> Saturation ---> uo_out
          +-------------------+        |                   |
                                       +-------------------+
                                              ^
                                              |
                                      +------------------+
                                      |   IIR Feedback   |
                                      | (y[n-1], y[n-2]) |
                                      +------------------+
```

## 🔌 I/O Interface

| Signal   | Width | Description |
|----------|------|------------|
| `ui_in`  | 8-bit | Input data / configuration |
| `uo_out` | 8-bit | Processed output |
| `clk`    | 1-bit | System clock |
| `rst_n`  | 1-bit | Active-low reset |

---

## 🧪 How to Use the Core

1. Apply reset (`rst_n = 0 → 1`)
2. Send a configuration byte on `ui_in`:
   - `[3:2]` → scaling factor  
   - `[1:0]` → mode selection  
3. Stream 8-bit input samples continuously on `ui_in`
4. Read processed output from `uo_out`

The core produces one output per clock cycle after pipeline fill.

---

## 📐 Physical Design & Sign-off
This design has been fully routed through the OpenLane ASIC flow and is 100% tapeout-ready.

* **Target Frequency:** 50 MHz  
* **Area Utilization:** 43.68% (Optimal for routing and hold-fix buffering)  
* **DRC / LVS:** 0 Violations  
* **Timing:** Positive WNS and WHS  

---

## 📖 Official Datasheet & Documentation
For the complete mathematical breakdown, Z-transform equations, configuration details, and test vectors:

👉 **[Read the Full DSP Core Datasheet Here](docs/info.md)**

---

## 🧪 Local Verification & Simulation

This project is compatible with the Tiny Tapeout test framework, which automatically verifies functionality during submission.

Custom simulation testbenches are not included in this repository, as the design is verified through the Tiny Tapeout framework.  
However, the design can be tested using standard Verilog simulators by applying:

- Configuration byte after reset  
- Streaming input patterns (constant, step, ramp, alternating)  
- Observing output behavior and saturation  
