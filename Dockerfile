# syntax=docker/dockerfile:1.6

############################
# ARGUMENTS
############################
ARG TARGETARCH
ARG ROCM_VERSION=6.3.3
ARG CUDA11_VERSION=11.3
ARG CUDA12_VERSION=12.8
ARG JETPACK5_VERSION=r35.4.1
ARG JETPACK6_VERSION=r36.4.0
ARG CMAKE_VERSION=3.31.2
ARG GO_VERSION=1.22.3

############################
# BASE (CPU, CMake, Clang, etc.)
############################
FROM --platform=linux/${TARGETARCH} almalinux:8 as base

# Common tools
RUN yum install -y epel-release yum-utils curl git \
    && yum install -y ccache clang make tar gzip \
    && yum clean all

# Add CMake
ARG CMAKE_VERSION
RUN curl -fsSL https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-$(uname -m).tar.gz \
    | tar -xz --strip-components=1 -C /usr/local

ENV CC=clang CXX=clang++ PATH=/usr/local/bin:$PATH

############################
# BUILD CPU TARGET
############################
FROM base as cpu
COPY CMakeLists.txt CMakePresets.json ./
COPY ml/backend/ggml/ggml ml/backend/ggml/ggml

RUN --mount=type=cache,target=/root/.ccache \
    cmake --preset CPU \
    && cmake --build --preset CPU --parallel \
    && cmake --install build --component CPU

############################
# BUILD CUDA TARGETS
############################
FROM base as cuda-11
ARG CUDA11_VERSION
RUN yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/$(uname -m)/cuda-rhel8.repo \
    && yum install -y cuda-toolkit-${CUDA11_VERSION//./-}
ENV PATH=/usr/local/cuda/bin:$PATH

COPY CMakeLists.txt CMakePresets.json ./
COPY ml/backend/ggml/ggml ml/backend/ggml/ggml

RUN --mount=type=cache,target=/root/.ccache \
    cmake --preset "CUDA 11" \
    && cmake --build --preset "CUDA 11" --parallel \
    && cmake --install build --component CUDA

FROM base as cuda-12
ARG CUDA12_VERSION
RUN yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel8/$(uname -m)/cuda-rhel8.repo \
    && yum install -y cuda-toolkit-${CUDA12_VERSION//./-}
ENV PATH=/usr/local/cuda/bin:$PATH

COPY CMakeLists.txt CMakePresets.json ./
COPY ml/backend/ggml/ggml ml/backend/ggml/ggml

RUN --mount=type=cache,target=/root/.ccache \
    cmake --preset "CUDA 12" \
    && cmake --build --preset "CUDA 12" --parallel \
    && cmake --install build --component CUDA

############################
# BUILD ROCm TARGET
############################
FROM rocm/dev-almalinux-8:${ROCM_VERSION}-complete as rocm
COPY CMakeLists.txt CMakePresets.json ./
COPY ml/backend/ggml/ggml ml/backend/ggml/ggml
ENV PATH=/opt/rocm/bin:$PATH

RUN --mount=type=cache,target=/root/.ccache \
    cmake --preset "ROCm 6" \
    && cmake --build --preset "ROCm 6" --parallel \
    && cmake --install build --component HIP

############################
# JETPACK BUILDS (Jetson ARM64)
############################
FROM --platform=linux/arm64 nvcr.io/nvidia/l4t-jetpack:${JETPACK5_VERSION} as jetpack5
ARG CMAKE_VERSION
RUN apt-get update && apt-get install -y curl ccache \
    && curl -fsSL https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-aarch64.tar.gz \
    | tar -xz --strip-components=1 -C /usr/local

COPY CMakeLists.txt CMakePresets.json ./
COPY ml/backend/ggml/ggml ml/backend/ggml/ggml

RUN --mount=type=cache,target=/root/.ccache \
    cmake --preset "JetPack 5" \
    && cmake --build --preset "JetPack 5" --parallel \
    && cmake --install build --component CUDA

FROM --platform=linux/arm64 nvcr.io/nvidia/l4t-jetpack:${JETPACK6_VERSION} as jetpack6
ARG CMAKE_VERSION
RUN apt-get update && apt-get install -y curl ccache \
    && curl -fsSL https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-aarch64.tar.gz \
    | tar -xz --strip-components=1 -C /usr/local

COPY CMakeLists.txt CMakePresets.json ./
COPY ml/backend/ggml/ggml ml/backend/ggml/ggml

RUN --mount=type=cache,target=/root/.ccache \
    cmake --preset "JetPack 6" \
    && cmake --build --preset "JetPack 6" --parallel \
    && cmake --install build --component CUDA

############################
# GO BUILD
############################
FROM base as build-go
WORKDIR /app
COPY go.mod go.sum ./
ARG GO_VERSION

RUN curl -fsSL https://golang.org/dl/go${GO_VERSION}.linux-$(uname -m).tar.gz \
    | tar -C /usr/local -xz
ENV PATH=/usr/local/go/bin:$PATH

RUN go mod download

COPY . .

RUN --mount=type=cache,target=/root/.cache/go-build \
    go build -trimpath -buildmode=pie -ldflags="-s -w" -o /bin/ollama .

############################
# FINAL IMAGE
############################
FROM ubuntu:20.04 as final
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build-go /bin/ollama /usr/local/bin/ollama

COPY --from=cpu /lib/ollama /usr/lib/ollama
COPY --from=cuda-11 /lib/ollama/cuda_v11 /usr/lib/ollama/cuda_v11
COPY --from=cuda-12 /lib/ollama/cuda_v12 /usr/lib/ollama/cuda_v12
COPY --from=rocm /lib/ollama/rocm /usr/lib/ollama/rocm

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility
ENV NVIDIA_VISIBLE_DEVICES=all
ENV OLLAMA_HOST=0.0.0.0:11434

EXPOSE 11434
ENTRYPOINT ["ollama"]
CMD ["serve"]
