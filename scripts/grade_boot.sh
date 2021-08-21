#!/bin/bash

SCRIPT_PATH=$(readlink -f "${BASH_SOURCE[0]}")
DN="$(dirname "$SCRIPT_PATH")"
cd "${DN}/../"

./scripts/judge_boot.sh
./scripts/judge_consume.py
