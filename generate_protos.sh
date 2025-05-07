#!/bin/bash

# Created by: Burak Anil Cila
# GitHub: github.com/bcila

# ========== PROTO GENERATOR ========== #

set -e # Exit immediately if a command exits with a non-zero status.

# ========== CONFIGURATION ========== #
PROTO_DIR="./proto"
STREAM_SERVICE="stream-service"
STREAM_SERVICE_PROTO="stream.proto"

generate_go_protos() {
    # Check if the service directory exists, if not create it
    if [ ! -d "./services/$1/internal/grpc/pb" ]; then
        mkdir -p "./services/$1/internal/grpc/pb"
    fi

    # Generate Go Protos
    protoc --proto_path=$PROTO_DIR \
    --go_out=./services/$1/internal/grpc/pb \
    --go-grpc_out=./services/$1/internal/grpc/pb \
    $PROTO_DIR/$2
}

generate_ts_protos() {
    # Check if the types directory exists, if not create it
    if [ ! -d "./types" ]; then
        mkdir -p "./types"
    fi
    # Generate TS Protos
    npx protoc --ts_proto_out=./services/$1/types/ ./proto/$2 --ts_proto_opt=nestJs=true;
}

generate_python_protos() {
    if [ ! -d "./services/$1/pb" ]; then
        mkdir -p "./services/$1/pb"
    fi

    python -m grpc_tools.protoc \
        -I $PROTO_DIR \
        --python_out=./services/$1/pb \
        --grpc_python_out=./services/$1/pb \
        $PROTO_DIR/$2
}


generate_gateway_protos() {
    # Check if the types directory exists, if not create it
    if [ ! -d "./gateway/types" ]; then
        mkdir -p "./gateway/types"
    fi
    # Generate TS Protos
    npx protoc --ts_proto_out=./gateway/types/ ./proto/*.proto --ts_proto_opt=nestJs=true;
}

main() {

    if ! command -v protoc &> /dev/null; then
        echo -e "❌ \e[1;31mprotoc command not found. Please install Protocol Buffer Compiler\e[0m"
        exit 1
    fi

    if ls "$PROTO_DIR"/*.proto 1> /dev/null 2>&1; then
        echo -e "\e[1;32mGenerating Protos...\e[0m ✅"
    else
        echo -e "❌ \e[1;31mNo proto files found in $PROTO_DIR\e[0m"
        exit 1
    fi

    echo "🔨 Generating Go protos..."
    generate_go_protos $STREAM_SERVICE $STREAM_SERVICE_PROTO

    # echo "🚀 Generating TypeScript protos for NestJS..."
    # generate_ts_protos

    echo "🧩 Generating Gateway protos..."
    generate_gateway_protos

    echo -e "\e[1;32mAll proto files are generated\e[0m ✅"
}

main