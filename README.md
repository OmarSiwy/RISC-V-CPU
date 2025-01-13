## **RISC-V-CPU**

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

## Testing

```bash
make test
```

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
