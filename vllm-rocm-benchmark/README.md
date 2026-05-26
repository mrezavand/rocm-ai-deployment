# vLLM Online Serving Benchmark — DeepSeek-V3.1-Terminus on 8× AMD Instinct MI355X

This guide reproduces an **online inference benchmark** of
[`deepseek-ai/DeepSeek-V3.1-Terminus`](https://huggingface.co/deepseek-ai/DeepSeek-V3.1-Terminus)
using [vLLM](https://github.com/vllm-project/vllm) on a **bare-metal node with 8× AMD Instinct™ MI355X (CDNA 4, gfx950)** GPUs.

See [ROCm Docs](https://rocm.docs.amd.com/en/7.13.0-preview/ai-inference/vllm.html?fam=instinct&vllm-ver=0.19.1&i=docker&gpu=mi350x&w=compute&gfx=gfx950) for further details.

The workflow has three steps:

1. **Launch** the vLLM ROCm container.
2. **Start** the vLLM server inside the container.
3. **Run** the `vllm bench serve` online benchmark against the server.

---

## Prerequisites

### Hardware
- 1× bare-metal node with **8× AMD Instinct MI355X** GPUs (CDNA 4 / `gfx950`).
- Sufficient host RAM (≥ 512 GB recommended for DeepSeek-V3.1-Terminus).
- Fast local NVMe storage for model weights (the model is ~600 GB+).

### Software (host)
- Linux with ROCm-compatible kernel and `amdgpu` driver installed.
- Docker (with `--device /dev/kfd` and `/dev/dri` access). To install Docker, please see [This page](https://docs.docker.com/engine/install/).  
- Network access to `huggingface.co` (or pre-staged weights).

### Accounts / Tokens
- A Hugging Face account with access to `deepseek-ai/DeepSeek-V3.1-Terminus`.
- A **Hugging Face access token** exported as `HF_TOKEN`.

---

## Step 1 - Launch the vLLM ROCm Container

The script `vllm-rocm-docker.sh` contains all the requirements to run the `vllm/vllm-openai-rocm:nightly` container. Run `bash vllm-rocm-docker.sh`

You will land at a shell prompt **inside the container** (`root@<host>:/workspace#`). Keep this terminal open — Steps 2 and 3 run inside it (or in `docker exec` sessions into the same container).

### Verify GPUs are visible

```bash
amd-smi
# You should see 8 MI355X devices listed.
```

### (Optional) Pre-stage the model as a local alias `DeepSeekTerminus`

Steps 2 and 3 reference the model as `DeepSeekTerminus`. The simplest way is to download once and create a symlink so vLLM serves it under that short name:

```bash
# Inside the container
huggingface-cli download deepseek-ai/DeepSeek-V3.1-Terminus \
    --local-dir /root/.cache/huggingface/DeepSeekTerminus \
    --local-dir-use-symlinks False
```

Then in Steps 2 and 3, set:

```bash
MODEL="/root/.cache/huggingface/DeepSeekTerminus"
```

Alternatively, just use the full HF repo ID directly:

```bash
MODEL="deepseek-ai/DeepSeek-V3.1-Terminus"
```

---

## Step 2 - Start the vLLM Server

Use the script `vllm-rocm-server.sh` for this purpose. Run `bash vllm-rocm-server.sh`.
Wait until the server is initiated.

### Quick sanity check (in a second terminal, inside the container)

```
curl http://localhost:8000/v1/chat/completions   -H "Content-Type: application/json"   -d '{
    "model": "deepseek-ai/DeepSeek-V3.1-Terminus",
    "messages": [
      {"role": "user", "content": "Hello DeepSeek, confirm you are working."}
    ],
    "max_tokens": 15
  }'
```

## Step 3 - Run the Online Benchmark

In a second terminal enter the container by `docker exec -it <containerID> bash`, then use the script `vllm-rocm-bench.sh` to start the benchmark. Run `bash vllm-rocm-bench.sh`.

### Metrics reported

- **TTFT** — Time To First Token (s)
- **TPOT** — Time Per Output Token (s/token, after first)
- **ITL**  — Inter-Token Latency (s)
- **E2EL** — End-to-End Latency per request (s)
- **Throughput** — Total output tokens/sec and requests/sec