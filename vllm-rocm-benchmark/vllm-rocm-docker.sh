#!/bin/bash

DOCKER_IMAGE="vllm/vllm-openai-rocm:nightly"
HF_TOKEN="hf_xyz"

sudo docker run --rm -it \
    --name vllm-rocm \
    --network host \
    --ipc=host \
    --privileged \
    --shm-size 128g \
    --cap-add=CAP_SYS_ADMIN \
    --cap-add=SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --device /dev/kfd \
    --device /dev/dri \
    --device /dev/mem \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    -v /home/amd/vllm-test:/workspace/scripts \
    -w /workspace \
    -e HF_TOKEN=${HF_TOKEN} \
    -e ROCR_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
    --entrypoint /bin/bash \
    ${DOCKER_IMAGE}
