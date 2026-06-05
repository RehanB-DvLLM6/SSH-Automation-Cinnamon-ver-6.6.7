# Sys-Telemetry

A lightweight Linux terminal dashboard written in C++ that displays real-time memory and network I/O statistics by reading directly from the Linux kernel's virtual filesystem.

---

## What It Does

- Reads RAM usage (total, used, free, utilization %) from `/proc/meminfo`
- Reads network download/upload speeds from `/proc/net/dev`
- Refreshes every 3 seconds in a continuous terminal loop
- Displays an ASCII banner on startup

---

## How It Works

The program reads two virtual files exposed by the Linux kernel:

- `/proc/meminfo` — parsed line by line to extract `MemTotal`, `MemFree`, `Buffers`, and `Cached`. Actual used memory is calculated as `MemTotal - MemFree - Buffers - Cached`, which excludes kernel-managed cache from the "used" figure.

- `/proc/net/dev` — parsed per interface, skipping the loopback (`lo`). Two snapshots are taken one interval apart; the delta between them gives bytes transferred per second, converted to MB/s.

---

## Problems Tackled During Development

### 1. Output Not Appearing on Terminal
`cout` in C++ is buffered by default. In an infinite loop that never fills the buffer, output is held indefinitely and nothing appears on screen. Fixed by adding `cout.flush()` after each display cycle.

### 2. ASCII Banner Overlapping With Stats Output
The original code used `\033[3;1H` to reposition the cursor to row 3 after printing the banner, assuming the banner was 3 lines tall. It is not — the banner spans 8 rows. The stats were printing directly on top of the banner characters. Fixed by moving `\033[2J\033[1;1H` (clear screen + cursor to top) inside the loop and reprinting the banner each cycle, so layout is always consistent regardless of banner height.

### 3. Network Speed Permanently Showing 0.00 MB/s
The `/proc/net/dev` column layout is:

```
interface: rx_bytes rx_packets rx_errs rx_drop rx_fifo rx_frame rx_compressed rx_multicast tx_bytes tx_packets ...
```

That is 16 data columns total. The original code attempted to skip columns with a manual loop but used an ambiguous index that made tx_bytes land on the wrong column. Fixed by reading all 16 columns into an array and indexing `col[0]` for rx_bytes and `col[8]` for tx_bytes directly — no guesswork.

### 4. Battery Drain From Aggressive Polling
The original 1-second refresh interval combined with full terminal clears (`\033[2J`) every cycle caused continuous I/O reads, CPU wakeups, and forced terminal repaints. On battery this was measurably destructive. The refresh interval was increased to `sleep(3)`, which reduces kernel file reads and terminal redraws by 66% with no meaningful loss in dashboard utility. This is not a tool you should leave running unplugged.

---

## Build and Run

```bash
g++ -o sys-telemetry main.cpp
./sys-telemetry
```

Requires Linux. Will not work on macOS or Windows — `/proc` does not exist on those kernels.

---

## Notes

- Tested on Ubuntu. The `/proc` filesystem layout is consistent across mainstream Linux distributions but may vary on heavily customized or embedded kernels.
- Network speed is calculated as a delta between two snapshots, so the first reading after launch will always show 0.00 MB/s. This is expected behavior.
- `Cached:` in `/proc/meminfo` refers to the page cache. Excluding it from "used" memory gives a more accurate picture of what your applications are actually consuming.
