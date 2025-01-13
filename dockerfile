FROM ubuntu:22.04 as builder
# https://riscof.readthedocs.io/en/latest/installation.html
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies with additional packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-pip \
    git \
    curl \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    bison \
    flex \
    device-tree-compiler \
    zlib1g-dev \
    libexpat-dev \
    gawk \
    texinfo \
    dpkg-dev \
    file \
    patchutils \
    ninja-build \
    pkg-config \
    libglib2.0-dev \
    && rm -rf /var/lib/apt/lists/*

# Install RISCOF
RUN pip3 install riscof

WORKDIR /build

# Clone and build RISC-V GNU Toolchain with specific commit
RUN git clone https://github.com/riscv/riscv-gnu-toolchain \
    && cd riscv-gnu-toolchain \
    && git submodule update --init --recursive \
    && mkdir build && cd build \
    && ../configure --prefix=/opt/riscv \
        --with-arch=rv32gc \
        --with-abi=ilp32d \
        --disable-linux \
        --enable-multilib \
    && make -j$(nproc) || (cat */mkinst*.log; false)

# Build Spike separately
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim.git \
    && cd riscv-isa-sim \
    && mkdir build && cd build \
    && ../configure --prefix=/opt/spike \
    && make -j$(nproc) \
    && make install

# Final image
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    libmpc3 \
    libmpfr6 \
    libgmp10 \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install riscof

# Copy built artifacts from builder
COPY --from=builder /opt/riscv /opt/riscv
COPY --from=builder /opt/spike /opt/spike

ENV PATH="/opt/riscv/bin:/opt/spike/bin:${PATH}"

WORKDIR /workspace

CMD ["bash"]
# docker build -t riscv-dev .
# docker run -v $(pwd):/workspace riscv-dev make test
