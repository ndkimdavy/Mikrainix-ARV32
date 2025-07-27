# Mikrainix-ARV32 - Documentation

## 1. Overview

**Architecture:** RISC-V 32-bit 5-stage processor  
**Objective:** 1 instruction per clock cycle  
**Compatibility:** RV32I (42 base instructions)

```
┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐
│ IF        │ → │ ID        │ → │ EX        │ → │ MEM       │ → │ WB        │
│ Fetch     │   │ Decode    │   │ Execute   │   │ Memory    │   │ WriteBack │
└───────────┘   └───────────┘   └───────────┘   └───────────┘   └───────────┘
```

## 2. The 5 stages

### IF (Instruction Fetch)
- Reads instruction at PC address
- Increments PC = PC + 4
- Passes instruction to ID

### ID (Instruction Decode) 
- Decodes the instruction
- Reads source registers (rs1, rs2)
- Generates control signals
- Passes everything to EX

### EX (Execute)
- Performs ALU calculation
- Calculates memory addresses
- Evaluates branch conditions
- Passes result to MEM

### MEM (Memory Access)
- Accesses memory for LOAD/STORE
- Propagates other results
- Passes final data to WB

### WB (Write Back)
- Writes result to destination register
- Updates PC if branch
- Instruction completed

## 3. Hardware components

### Memory (32 MB)
```
0x00000000 - 0x00FFFFFF : CODE (16 MB)
0x20000000 - 0x20FFFFFF : DATA (16 MB)  
0x40000000 - 0x40000007 : I/O (8 bytes)
```

### Registers
- 32 general purpose registers (x0 to x31)
- x0 always = 0
- PC (Program Counter)

### ALU
- Addition, subtraction
- Logical operations (AND, OR, XOR)
- Shifts (left, right)
- Comparisons

## 4. Performance

### Nominal throughput
- **Latency:** 5 cycles for first instruction
- **Throughput:** 1 instruction/cycle after filling

### Example with 5 instructions
```
Cycle:  1   2   3   4   5   6   7   8   9
Inst1: [IF][ID][EX][MEM][WB]
Inst2:     [IF][ID][EX][MEM][WB]
Inst3:         [IF][ID][EX][MEM][WB]
Inst4:             [IF][ID][EX][MEM][WB]
Inst5:                 [IF][ID][EX][MEM][WB]

Result: 5 instructions in 9 cycles
```

### Efficiency
```
Small programs (10 inst.) : ~71%
Large programs (1000 inst.) : ~99%
Formula: Efficiency = N/(N+4)
```

## 5. Supported instructions

### Arithmetic (9)
ADD, SUB, ADDI, LUI, AUIPC, SLT, SLTU, SLTI, SLTIU

### Logical (6) 
AND, OR, XOR, ANDI, ORI, XORI

### Shifts (6)
SLL, SRL, SRA, SLLI, SRLI, SRAI

### Memory (8)
LW, LH, LHU, LB, LBU, SW, SH, SB

### Control (8)
BEQ, BNE, BLT, BGE, BLTU, BGEU, JAL, JALR

### Memory Ordering (3)
FENCE, FENCE.TSO, PAUSE

### System (2)
ECALL, EBREAK

## 6. Issues to handle

### Data hazards
```
ADD x1, x2, x3    # x1 written at cycle 5
SUB x4, x1, x5    # x1 read at cycle 3 → CONFLICT!
```
**Solution:** Insert bubbles (stall)

### Branches
```
BEQ x1, x2, label  # Decision at cycle 4
ADD x3, x4, x5     # Already in process → may be cancelled
```
**Solution:** Flush stages if branch taken

## 7. I/O Interface

### GPIO (0x40000000)
- 32 bits bidirectional
- Access via LOAD/STORE

### UART (0x40000004) 
- Serial interface
- Character transmission/reception

## 8. Implementation

### Development steps
1. **Base structure:** Registers and controller
2. **ALU instructions:** ADD, SUB, AND, OR...
3. **Memory instructions:** LOAD/STORE
4. **Branches:** BEQ, JAL...
5. **Hazard handling:** Stall and flush
6. **Optimizations:** Forwarding, prediction

### Validation
- Instruction-by-instruction testing
- RISC-V reference programs
- Timing validation

## 9. Technical summary

```
Architecture    : 5 stages
ISA             : RISC-V RV32I (42 instructions)
Registers       : 32 × 32-bit
Memory          : 32 MB
Theoretical     : f(Hz) instructions/second
Latency         : 5 cycles
Target          : FPGA
```

**Key principle:** Maintain continuous instruction flow to maximize performance.

---
*Mikrainix-ARV32*  
*Author: NDAYONGEJE Kim Davy*