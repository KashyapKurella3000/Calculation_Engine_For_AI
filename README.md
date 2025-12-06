# EE272 – AI Calculation Engine



This project implements a high-performance AI calculation engine capable of performing 16 parallel FP11 multiply-accumulate operations in a pipelined architecture.
The engine interfaces with a wide, high-bandwidth S-bus system capable of burst reads and single-cycle writes, enabling efficient movement of large operand blocks.

At the core of this design are hierarchical computation blocks:

FPM – Floating Point Multiplier (FP11)

FPA – Floating Point Adder (FP11)

SUM4 – 4 multipliers feeding one adder

SUM16 – 4 SUM4 blocks feeding one adder (16 multiplications + reduction)

The engine receives 16 operands A and 16 operands B (each 11 bits wide) at once and produces a single FP11 result.
