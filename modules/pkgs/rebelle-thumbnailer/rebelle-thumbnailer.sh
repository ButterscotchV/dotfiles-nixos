#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage: rebelle-thumbnailer INPUT OUTPUT SIZE" >&2
    exit 2
fi

input=$1
output=$2
size=$3

if [[ ! "$size" =~ ^[0-9]+$ ]]; then
    echo "Invalid thumbnail size: $size" >&2
    exit 2
fi

"@UNZIP@" -p "$input" canvas.png |
    "@MAGICK@" - -thumbnail "${size}x${size}>" \
        -strip "PNG:$output"
