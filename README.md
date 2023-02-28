# ECE260B_FinalProject

## Progress

#### 1. Connected output ports in `core.v` and `fullchip.v`.
#### 2. Added `pmem` read in `fullchip_tb.v`.
#### 3. Added `fullchip.sdc` and `run_dc.tcl` to generate `fullchip.out.v`.
#### 4. Formatted the structure as suggested in class.

## Commands

### 1. Waveforms verification
```
cd syn
iveri filelist
irun
wave fullchip_tb.vcd
```

### 2. DC Synthesis
```
cd syn
dc_shell
source run_dc.tcl
exit
```

### 3. PnR
```
cd pnr
innovus
source loadDesignTech.tcl
source initialFloorplan.tcl
source placement.tcl
source pinPlacement.tcl
source clock.tcl
source route.tcl
source reportDesign.tcl
source outputGen.tcl

verifyConnectivity
verifyGeometry
checkPinPlacement

```
