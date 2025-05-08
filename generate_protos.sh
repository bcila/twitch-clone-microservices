#!/bin/bash

# Created by: Burak Anil Cila
# GitHub: github.com/bcila

# ========== PROTO GENERATOR ========== #

set -e # Exit immediately if a command exits with a non-zero status.

# ========== CONFIGURATION ========== #
PROTO_DIR="./proto"

STREAM_SERVICE="stream-service"
STREAM_SERVICE_PROTO="stream.proto"

USER_SERVICE="user-service"
USER_SERVICE_PROTO="user.proto"

generate_go_protos() {
    # Check if the service directory exists, if not create it
    if [ ! -d "./services/$1/internal/grpc/pb" ]; then
        mkdir -p "./services/$1/internal/grpc/pb"
    fi

    # Check if proto file exists
    if [ -f "$PROTO_DIR/$2" ]; then
        # Generate Go Protos if proto file exists
        protoc --proto_path=$PROTO_DIR \
        --go_out=./services/$1/internal/grpc/pb \
        --go-grpc_out=./services/$1/internal/grpc/pb \
        $PROTO_DIR/$2
    else
        echo "⚠️ Proto file for $1 not found. Skipping Go protos generation."
    fi
}

generate_ts_protos() {
    # Check if the types directory exists, if not create it
    if [ ! -d "./services/$1/types" ]; then
        mkdir -p "./services/$1/types"
    fi
    
    # Check if proto file exists
    if [ -f "$PROTO_DIR/$2" ]; then
        # Generate TS Protos if proto file exists
        npx protoc --ts_proto_out=./services/$1/types/ ./proto/$2 --ts_proto_opt=nestJs=true;
    else
        echo "⚠️ Proto file for $1 not found. Skipping generation."
    fi
}

generate_python_protos() {
    if [ ! -d "./services/$1/pb" ]; then
        mkdir -p "./services/$1/pb"
    fi

    # Check if proto file exists
    if [ -f "$PROTO_DIR/$2" ]; then
        # Generate Python Protos if proto file exists
        python -m grpc_tools.protoc \
            -I $PROTO_DIR \
            --python_out=./services/$1/pb \
            --grpc_python_out=./services/$1/pb \
            $PROTO_DIR/$2
    else
        echo "⚠️ Proto file for $1 not found. Skipping generation."
    fi
}

generate_gateway_protos() {
    # Check if the types directory exists, if not create it
    if [ ! -d "./gateway/types" ]; then
        mkdir -p "./gateway/types"
    fi
    
    # Check if any proto files exist in the proto directory
    if ls "$PROTO_DIR"/*.proto 1> /dev/null 2>&1; then
        # Generate TS Protos for Gateway
        npx protoc --ts_proto_out=./gateway/types/ ./proto/*.proto --ts_proto_opt=nestJs=true;
    else
        echo "⚠️ No proto files found in $PROTO_DIR. Skipping generation."
    fi
}

main() {

    # Check if protoc command is available
    if ! command -v protoc &> /dev/null; then
        echo -e "❌ \e[1;31mprotoc command not found. Please install Protocol Buffer Compiler\e[0m"
        exit 1
    fi

    # Check if any proto files exist
    if ls "$PROTO_DIR"/*.proto 1> /dev/null 2>&1; then
        echo -e "\e[1;32mGenerating Protos...\e[0m ✅"
    else
        echo -e "❌ \e[1;31mNo proto files found in $PROTO_DIR\e[0m"
        exit 1
    fi

    # Generate Protos
    echo "🔨 Generating Go protos..."
    generate_go_protos $STREAM_SERVICE $STREAM_SERVICE_PROTO

    echo "🚀 Generating TypeScript protos for NestJS..."
    generate_ts_protos $USER_SERVICE $USER_SERVICE_PROTO

    echo "🧩 Generating Gateway protos..."
    generate_gateway_protos

    echo -e "\e[1;32mAll proto files that exist are generated\e[0m ✅"
}

main
