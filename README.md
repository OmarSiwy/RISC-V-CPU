## **RISC-V-CPU**

![RISC-V Logo](https://riscv.org/wp-content/uploads/2019/03/riscv-logo-stacked.png)

### Project Overview
Base RISC-V CPU intended to evolve over time to integrate OS-Managed Context Switching into it for faster performance.

The reason is that many systems are separated and, as a result, have multiple levels of abstraction that communicate through specific endpoints. If only there were a way to optimize that and, in turn, make a faster CPU.

Someone in a Compiler-Design Talk:
```
A lot of systems nowadays are built on levels of abstraction.
```

My project intends to slowly blend in the heavy features of a Real-Time Operating System into it to achieve performance at magnitudes faster than a software algorithm. My goals are:
- Context Switching (Will have to be on the fly)
- Asynchronous Data (Through Atomics)
- Dynamic Memory Allocation

I understand this will involve adding onto the RISC-V ISA, which isn't very hard because the current Instruction Set doesn't use all 128 spots of instructions.

## Features

- **RV32E**: Designed for low-power draw and size efficiency in embedded systems.
- **I**: Integer addition and subtraction.
- **M**: Multiplication and division.
- **F**: Floating-point number handling.
- **D**: Double-precision number handling.
- **A**: Atomic operations for thread-safe memory access.
- **C**: Compressed instructions for reducing code size.
- **Zicsr**: Control and status register instructions for efficient OS implementation.
- **Zifencei**: Instruction-fetch fence for better security and synchronization.

## Performance

Refer to the script `PowerRating.tcl` for more recent results.

## Size

Refer to the script `SizeRating.tcl` for more recent results.

## Testing

```bash
make test
```

**TO DO**:
- Add https://github.com/chipsalliance/riscv-dv testing

## Development

### Package Requirements

- `riscv-gnu-toolchain`
- `iverilog`
- `python`
- `make`
- `SPIKE`

### Development Workflow

```bash
make all
```

## Fabrication

This project is not completed with the OS features I'd like, and fabrication is quite expensive. Therefore, I aim to perfect it before sending it out for fabrication.
