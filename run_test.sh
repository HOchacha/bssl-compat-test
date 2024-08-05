#!/bin/bash

# 사용법 출력 함수
usage() {
    echo "Usage: $0 [openssl_library_path]"
    echo "Example: $0 /usr/local/openssl-3.0.8/lib64"
    echo "If no path is provided, the script will attempt to find OpenSSL automatically."
}

# OpenSSL 라이브러리 경로 찾기
find_openssl() {
    POSSIBLE_PATHS=(
        "/usr/local/openssl/lib64"
        "/usr/local/ssl/lib64"
        "/usr/lib64/openssl"
        "/usr/lib64/ssl"
        "/usr/local/openssl/lib"
        "/usr/local/openssl-3.0.8/lib"
        "/usr/local/ssl/lib"
        "/usr/lib/openssl"
        "/usr/lib/ssl"
        "/opt/openssl/lib64"
        "/opt/openssl/lib"
    )

    for path in "${POSSIBLE_PATHS[@]}"; do
        if [ -d "$path" ] && ( [ -f "$path/libssl.so" ] || [ -f "$path/libcrypto.so" ] ); then
            echo "OpenSSL found at: $path"
            OPENSSL_LIB_PATH="$path"
            return 0
        fi
    done

    echo "OpenSSL not found"
    return 1
}

# 인자로 제공된 경로 확인 또는 자동 검색
if [ $# -eq 1 ]; then
    OPENSSL_LIB_PATH="$1"
    if [ ! -d "$OPENSSL_LIB_PATH" ]; then
        echo "Provided path does not exist: $OPENSSL_LIB_PATH"
        usage
        exit 1
    fi
else
    find_openssl
    if [ -z "$OPENSSL_LIB_PATH" ]; then
        echo "Failed to find OpenSSL. Please provide the path as an argument."
        usage
        exit 1
    fi
fi

# LD_LIBRARY_PATH 설정
export LD_LIBRARY_PATH="$OPENSSL_LIB_PATH:$LD_LIBRARY_PATH"
echo "LD_LIBRARY_PATH set to: $LD_LIBRARY_PATH"

# test 프로그램 실행
if [ -f "./test" ]; then
    echo "Running test program..."
    ./test
else
    echo "Error: test program not found in the current directory."
    exit 1
fi
