# 1101 Pattern Detector

## 1. Overview

This project implements a **Mealy Finite State Machine (FSM)** to detect the serial bit pattern **1101** with **overlap**. The design is synchronized to a clock and features a synchronous, active-high reset.

The FSM's single output, `y`, generates a **1-cycle pulse** when the final bit of the pattern is received. Overlap detection means that a detected pattern's trailing bits can serve as the leading bits of a subsequent pattern.

## 2. Design Details

The FSM is defined by a state diagram with four states:
* **S0:** The initial state (no bits of the pattern matched).
* **S1:** The first bit, '1', has been matched.
* **S2:** The prefix '11' has been matched.
* **S3:** The prefix '110' has been matched.

The output `y` is asserted high on the transition from state **S3** to **S2** when the input `din` is '1', which completes the **1101** sequence.

## 3. Test Streams and Expected Behavior

The design's functionality was verified using a comprehensive testbench. The following table details the tested input streams and the expected timing of the `y` pulse.

| Test Stream              | Expected Pulse Indices (1-based) | Notes                                                                   |
| ------------------------ | -------------------------------- | ----------------------------------------------------------------------- |
| `01101110101101`         | **5, 9, 11, 14** | Multiple detections, including a clear overlap at indices 9 and 11.       |
| `1101101101`             | **4, 8, 10** | Shows how the last '1' of a pattern can start a new sequence.           |
| `11110101101`            | **6, 11** | The FSM correctly handles consecutive '1's.                             |
| `00001101000`            | **8** | A basic, non-overlapping test case.                                     |

The testbench generates a waveform file (`dump.vcd`) for visual verification of these results.
