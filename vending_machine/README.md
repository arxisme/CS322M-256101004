# Problem 3: Mealy Vending Machine with Change

## 1. Objective 🎯
This project implements a vending machine controller using a **Mealy Finite State Machine (FSM)**. The machine accepts 5 and 10-unit coins, vends an item when at least 20 units are deposited, and provides 5 units of change if the final total is 25.

- **Item Price**: 20
- **Accepted Coins**: 5 (`2'b01`), 10 (`2'b10`)
- **Outputs**: `dispense` (1-cycle pulse), `chg5` (1-cycle pulse)

---
## 2. State Machine Design

### Justification for Mealy FSM
A Mealy FSM is the ideal choice for this problem. The outputs (`dispense` and `chg5`) depend on **both the current total (the state) and the specific coin just inserted (the input)**.

For example, when the machine has accumulated 15 units (`S_15` state), the final action depends entirely on the next coin:
- If a **5** is inserted, the machine must `dispense`.
- If a **10** is inserted, it must `dispense` AND give `chg5`.

This direct, immediate reaction of the output to an input is the defining characteristic and advantage of a Mealy machine. A Moore FSM would require extra states to produce these different output combinations, making the design more complex.

### State Definitions
The FSM uses four states to track the total amount of money deposited:
- **`S_0`**: Total = 0 units. Initial and post-vend state.
- **`S_5`**: Total = 5 units.
- **`S_10`**: Total = 10 units.
- **`S_15`**: Total = 15 units.

### State Transition Diagram
The diagram below shows the states (circles) and transitions (arrows). Each transition is labeled as `input (coin) / output (dispense, chg5)`.


- **`S_0`**
  - `01 (5) / 00` → **`S_5`**
  - `10 (10) / 00` → **`S_10`**
  - `00, 11 / 00` → **`S_0`**

- **`S_5`**
  - `01 (5) / 00` → **`S_10`**
  - `10 (10) / 00` → **`S_15`**
  - `00, 11 / 00` → **`S_5`**

- **`S_10`**
  - `01 (5) / 00` → **`S_15`**
  - `10 (10) / 10` → **`S_0`** **(Vend!)**
  - `00, 11 / 00` → **`S_10`**

- **`S_15`**
  - `01 (5) / 10` → **`S_0`** **(Vend!)**
  - `10 (10) / 11` → **`S_0`** **(Vend & Change!)**
  - `00, 11 / 00` → **`S_15`**

---
## 3. Waveform Highlighting 📈
After running the simulation with the provided testbench, open the `waveform.vcd` file. The key Mealy behaviors to observe are:

1.  **Simple Vend (10+10)**: Find the clock cycle where `current_state` is `S_10` and the input `coin` is `10`. In that exact same cycle, you will see the `dispense` output pulse high for one cycle. The machine then transitions to `S_0` on the next clock edge.

2.  **Vend with Change (10+5+10)**: Find the cycle where `current_state` is `S_15` and the input `coin` is `10`. In that same cycle, you will see **both** `dispense` and `chg5` pulse high. This demonstrates the output's dependency on both state and input. The machine transitions to `S_0` on the next clock edge.

The output pulses are asserted *combinatorially* as soon as the valid input coin is detected, not after the next clock edge, which confirms the correct Mealy FSM implementation.
