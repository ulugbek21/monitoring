#!/bin/bash
CURRENT_DIR=$1
if [[ -f $1/.env ]]; then
    set -a &&. ./.env && set +a
fi
