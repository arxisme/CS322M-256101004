# Problem 4: Master-Slave Handshake with Two FSMs

## 1. Project Goal 🤝
This project implements a communication link between two Finite State Machines (FSMs), a **Master** and a **Slave**. The Master sends a burst of 4 bytes of data to the Slave over an 8-bit data bus. The communication is synchronized using a **4-phase `req`/`ack` handshake protocol**.

- **Master FSM**: Initiates the transfer of 4 data bytes.
- **Slave FSM**: Receives the data and acknowledges each byte.
- **Protocol**: 4-phase handshake with a 2-cycle `ack` hold by the Slave.

---
## 2. State Machine and Timing Diagrams

### Master FSM State Diagram
The Master FSM sequences through sending 4 bytes of data. It uses a 2-bit counter (`byte_index`) to track its progress.

- **`M_IDLE`**: The initial state. Transitions to `M_DRIVE_DATA` to begin the transfer.
- **`M_DRIVE_DATA`**: Places the current byte on the `data` bus and asserts `req`.
- **`M_WAIT_ACK`**: Waits for the Slave to assert `ack`.
- **`M_DROP_REQ`**: Once `ack` is seen, it de-asserts `req`.
- **`M_WAIT_ACK_LOW`**: Waits for the Slave to de-assert `ack`, completing the handshake for one byte. If more bytes remain, it loops back to `M_DRIVE_DATA`. Otherwise, it proceeds to `M_DONE`.
- **`M_DONE`**: Asserts the `done` signal for a single clock cycle, then returns to `M_IDLE`.


### Slave FSM State Diagram
The Slave FSM's primary role is to listen for a request and acknowledge it for exactly two clock cycles.

- **`S_IDLE`**: The initial state, waiting for `req` to go high. `ack` is low.
- **`S_ACK_1`**: On seeing `req`, it latches the incoming data, asserts `ack`, and enters this state. This is the **first cycle** of the `ack` pulse.
- **`S_ACK_2`**: This is the **second cycle** of the `ack` pulse. It holds `ack` high and waits for `req` to be de-asserted by the Master.
- Once `req` is low while in `S_ACK_2`, it transitions back to `S_IDLE`, dropping `ack`.


### Handshake Timing Diagram (for one byte)
This diagram illustrates the sequence of `req` and `ack` signals for a single byte transfer.
