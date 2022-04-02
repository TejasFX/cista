# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang

## Add source code to the build stage.
ADD . /cista
WORKDIR /cista

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN mkdir -p build && cd build && CC=clang CXX=clang++ cmake .. && make cista-fuzz-graph && make cista-fuzz-bitset_verification && make cista-fuzz-hash_map_verification && make cista-fuzz-hash_set

# Package Stage
FROM ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /cista/build/cista-fuzz-graph /
COPY --from=builder /cista/build/cista-fuzz-bitset_verification /
COPY --from=builder /cista/build/cista-fuzz-hash_map_verification /
COPY --from=builder /cista/build/cista-fuzz-hash_set /
