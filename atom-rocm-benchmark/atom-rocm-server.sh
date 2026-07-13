#!/bin/bash

model_path=/workspace/models/GLM-52-FP8/
export AITER_QUICK_REDUCE_QUANTIZATION=INT4
export AITER_USE_FLYDSL_MOE_SORTING=1
TP=8

python -m atom.entrypoints.openai_server \
  --model "$model_path" \
  --server-port 7777 \
  --kv_cache_dtype fp8 \
  --no-enable_prefix_caching \
  -tp $TP 2>&1 | tee server.log &
