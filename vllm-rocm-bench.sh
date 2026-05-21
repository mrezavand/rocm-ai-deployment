#!/bin/bash

MODEL="../DeepSeekTerminus"
IN=1024
OUT=1024
NP=96
CC=128

echo "Running vLLM online benchmark ..."
vllm bench serve --host localhost --port 8000 \
  --backend vllm \
  --model ${MODEL} \
  --dataset-name random \
  --random-input-len ${IN} \
  --random-output-len ${OUT} \
  --max-concurrency ${CC} \
  --num-prompts ${NP} \
  --ignore-eos \
  --percentile-metrics "ttft,tpot,itl,e2el" \
  --save-result \
  --result-dir /results \
  --result-filename "deepseek_v31_in${IN}_out${OUT}_np${NP}_c${CC}.json"
