#!/bin/bash

model_path=/workspace/models/GLM-52-FP8/
ISL=1024
OSL=1024
CONC=16

python -m atom.benchmarks.benchmark_serving \
    --model "$model_path" --backend=vllm --base-url=http://localhost:7777 \
    --dataset-name=random \
    --random-input-len=${ISL} --random-output-len=${OSL} \
    --random-range-ratio 1.0 \
    --num-prompts=$(( $CONC * 10 )) \
    --max-concurrency=$CONC \
    --request-rate=inf --ignore-eos \
    --save-result --result-dir=${result_dir} --result-filename=$RESULT_FILENAME.json \
    --percentile-metrics="ttft,tpot,itl,e2el"
