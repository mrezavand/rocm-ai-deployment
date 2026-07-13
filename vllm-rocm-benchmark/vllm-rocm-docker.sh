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


docker run -it --rm \
  --name vllm-kimi-k26-mi355x \
  --network=host \
  --group-add=video \
  --ipc=host \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --device /dev/kfd \
  --device /dev/dri \
  -v /home/:/home/ehhossei \
  -v /mnt/gfx_apps/models/moonshotai/kimi-k2.6:/app/models/Kimi-K2.6:ro \
  -e HOME=/home/ehhossei \
  -e HF_HOME=/home/ehhossei/.cache/huggingface \
  -e VLLM_CACHE_ROOT=/home/ehhossei/.cache/vllm \
  -e HSA_OVERRIDE_GFX_VERSION=9.4.2 \
  -w /home/ehhossei \
  mkmhub.amd.com/dcgpu-gfx_apps-prod/vllm:7.14.0-26203389112-ubuntu2404 \
  bash
  