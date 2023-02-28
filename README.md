# ECE260B_FinalProject

## Progress

### 1. Connected output ports in `core.v` and `fullchip.v`.
### 2. Added `pmem` read in `fullchip_tb.v`.
### 3. Added `fullchip.sdc` and `run_dc.tcl` to generate `fullchip.out.v`.

## Commands

### 1. Waveforms verification
```
iveri filelist
irun
wave fullchip_tb.vcd
```

### 2. DC Synthesis
```
dc_shell
source run_dc.tcl
exit
```
