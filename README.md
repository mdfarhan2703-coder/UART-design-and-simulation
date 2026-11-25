# UART Design and Simulation

## Project Overview
This project implements a simple **UART (Universal Asynchronous Receiver/Transmitter)** using Verilog HDL. It contains separate transmitter and receiver modules and a testbench that connects the transmitter output directly to the receiver input for loopback simulation.

The testbench sends five 8-bit data values and compares the received data with the transmitted data.

## Features
- 8-bit UART data transmission and reception
- Separate UART transmitter (`uart_tx`) and receiver (`uart_rx`)
- Configurable clock cycles per bit through the `CLKS_PER_BIT` parameter
- Active-high asynchronous reset
- `tx_busy` status output from the transmitter
- `rx_done` pulse when a byte has been received
- Loopback testbench and waveform dump
- Yosys synthesis reports for the transmitter and receiver

## Project Files

| File | Description |
|---|---|
| `uart_tx.v` | UART transmitter RTL module |
| `uart_rx.v` | UART receiver RTL module |
| `uart_tb.v` | Testbench connecting TX to RX and testing five data bytes |
| `uart.vcd` | Simulation waveform dump |
| `Waveform.jpg` | Waveform screenshot |
| `tx_report.txt` | Yosys synthesis/statistics report for the transmitter |
| `rx_report.txt` | Yosys synthesis/statistics report for the receiver |
| `uart_sim` | Simulation executable included in the submitted project |

## UART Frame Format
The transmitter forms a 10-bit frame:
- 1 start bit (logic 0)
- 8 data bits
- 1 stop bit (logic 1)

The receiver detects the start condition and collects the 8 data bits.

## Simulation Configuration
The testbench uses:
- Clock period: `10 ns` (toggle every `5 ns`)
- `CLKS_PER_BIT`: `16`
- Data width: `8 bits`

The testbench sends these hexadecimal values:

`A5`, `55`, `AA`, `FF`, `00`

For each byte, it prints the transmitted and received values and indicates `PASS` or `FAIL` when they match or differ. At the end, it prints `ALL TESTS COMPLETED`.

## Tools Used
- Verilog HDL
- Icarus Verilog — simulation
- GTKWave — waveform viewing
- Yosys — synthesis and logic statistics

## How to Run the Simulation

Run these commands from the project directory in a Linux terminal.

### 1. Compile
```bash
iverilog -o uart_sim uart_tx.v uart_rx.v uart_tb.v
```

### 2. Run
```bash
vvp uart_sim
```

### 3. View the waveform
```bash
gtkwave uart.vcd
```

The testbench also writes `uart.vcd` when the simulation runs.

## Synthesis Reports

The repository includes Yosys reports generated for the individual RTL modules.

To regenerate the transmitter report:
```bash
yosys -p "read_verilog uart_tx.v; hierarchy -top uart_tx; proc; opt; stat" > tx_report.txt
```

To regenerate the receiver report:
```bash
yosys -p "read_verilog uart_rx.v; hierarchy -top uart_rx; proc; opt; stat" > rx_report.txt
```

The included reports show the synthesis statistics:
- Transmitter (`uart_tx`): 31 cells
- Receiver (`uart_rx`): 43 cells

These are Yosys generic cell statistics, not FPGA resource or timing results.

## Notes
- The testbench uses a direct loopback connection: `tx` is connected to `rx`.
- `CLKS_PER_BIT` is set to `16` in the testbench for simulation.
- This project demonstrates RTL design and simulation. No physical hardware implementation is included in the supplied project files.
