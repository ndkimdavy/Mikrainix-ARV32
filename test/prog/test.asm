# test.asm - RISC-V RV32I Test Instructions

.text
.globl _start

_start:
    # Upper Immediate
    lui  x5, 0x12345       # LUI
    auipc x6, 0x1000       # AUIPC
    
    # Jump and Link
    jal  x1, label1        # JAL
    jalr x2, x3, 100       # JALR
    
    # Branch
    beq  x1, x2, label2    # BEQ
    bne  x1, x2, label2    # BNE
    blt  x1, x2, label2    # BLT
    bge  x1, x2, label2    # BGE
    bltu x1, x2, label2    # BLTU
    bgeu x1, x2, label2    # BGEU
    
    # Load
    lb   x1, 0(x2)         # LB
    lh   x1, 2(x2)         # LH
    lw   x1, 4(x2)         # LW
    lbu  x1, 8(x2)         # LBU
    lhu  x1, 10(x2)        # LHU
    
    # Store
    sb   x3, 0(x2)         # SB
    sh   x3, 2(x2)         # SH
    sw   x3, 4(x2)         # SW
    
    # Immediate ALU
    addi x1, x2, 100       # ADDI
    slti x1, x2, 50        # SLTI
    sltiu x1, x2, 50       # SLTIU
    xori x1, x2, 0xFF      # XORI
    ori  x1, x2, 0xF0      # ORI
    andi x1, x2, 0x0F      # ANDI
    slli x1, x2, 4         # SLLI
    srli x1, x2, 2         # SRLI
    srai x1, x2, 1         # SRAI
    
    # Register ALU
    add  x1, x2, x3        # ADD
    sub  x1, x2, x3        # SUB
    sll  x1, x2, x3        # SLL
    slt  x1, x2, x3        # SLT
    sltu x1, x2, x3        # SLTU
    xor  x1, x2, x3        # XOR
    srl  x1, x2, x3        # SRL
    sra  x1, x2, x3        # SRA
    or   x1, x2, x3        # OR
    and  x1, x2, x3        # AND
    
    # System
    ecall                  # ECALL
    ebreak                 # EBREAK

label1:
    nop                    # Simple return point

label2: 
    nop                    # Branch target