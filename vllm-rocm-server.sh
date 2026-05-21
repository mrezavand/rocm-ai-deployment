#!/bin/bash

PORT=8000
TP=8
MODEL="../DeepSeekTerminus"

MAX_MODEL_LEN=10240
MAX_NUM_SEQS=256
MAX_NUM_BATCHED_TOKENS=8192
GPU_MEM_UTIL=0.95

vllm serve ${MODEL} \
        --port ${PORT} \
        --tensor-parallel-size ${TP} \
        --max-model-len ${MAX_MODEL_LEN} \
        --max-num-seqs ${MAX_NUM_SEQS} \
        --max-num-batched-tokens ${MAX_NUM_BATCHED_TOKENS} \
        --gpu-memory-utilization ${GPU_MEM_UTIL} \
        --no-enable-prefix-caching
