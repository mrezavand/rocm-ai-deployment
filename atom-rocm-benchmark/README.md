# Online Serving Benchmark using ATOM (AiTer Optimized Model) — GLM-5.2-FP8 on 8× AMD Instinct MI355X

This guide reproduces an **online inference benchmark** of
[`zai-org/GLM-5.2-FP8`](https://huggingface.co/zai-org/GLM-5.2-FP8)
using [ATOM](https://github.com/ROCm/ATOM) on a **bare-metal node with 8× AMD Instinct™ MI355X (CDNA 4, gfx950)** GPUs.

ATOM (AiTer Optimized Model) is a lightweight vLLM-like implementation, focusing on integration and optimization based on [AITER](https://github.com/ROCm/aiter).

See [ATOM recipes](https://github.com/ROCm/ATOM/blob/main/recipes/GLM-5.md) for further details.

The workflow has three steps:

1. **Launch** the ATOM ROCm container.
2. **Start** the ATOM server inside the container.
3. **Run** the `atom.benchmarks.benchmark_serving` online benchmark against the server.

---

## Step 1 - Launch the ATOM ROCm Container

The script `atom-rocm-docker.sh` contains all the requirements to run the `rocm/atom-dev:latest` container. Run `bash atom-rocm-docker.sh`

You will land at a shell prompt **inside the container** (`root@<host>:/workspace#`). Keep this terminal open — Steps 2 and 3 run inside it (or in `docker exec` sessions into the same container).

### Verify GPUs are visible

```bash
amd-smi
# You should see 8 MI355X devices listed.
```

### (Optional) Pre-stage the model as a local alias `GLM-5.2-FP8`

Steps 2 and 3 reference the model as `GLM-5.2-FP8`. The simplest way is to download once and create a symlink so ATOM serves it under that short name:

```bash
# Inside the container
huggingface-cli download zai-org/GLM-5.2-FP8 \
    --local-dir /root/.cache/huggingface/GLM-52-FP8 \
    --local-dir-use-symlinks False
```

Then in Steps 2 and 3, set:

```bash
MODEL="/root/.cache/huggingface/GLM-52-FP8"
```

Alternatively, just use the full HF repo ID directly:

```bash
MODEL="zai-org/GLM-5.2-FP8"
```

---

## Step 2 - Start the ATOM Server

Use the script `atom-rocm-server.sh` for this purpose. Run `bash atom-rocm-server.sh`.
Wait until the server is initiated.

### Quick sanity check (in a second terminal, inside the container)

```
curl http://localhost:8000/v1/chat/completions   -H "Content-Type: application/json"   -d '{
    "model": "zai-org/GLM-5.2-FP8",
    "messages": [
      {"role": "user", "content": "Hello DeepSeek, confirm you are working."}
    ],
    "max_tokens": 15
  }'
```

## Step 3 - Run the Online Benchmark

In a second terminal enter the container by `docker exec -it <containerID> bash`, then use the script `atom-rocm-bench.sh` to start the benchmark. Run `bash atom-rocm-bench.sh`.

### Metrics reported

- **TTFT** — Time To First Token (s)
- **TPOT** — Time Per Output Token (s/token, after first)
- **ITL**  — Inter-Token Latency (s)
- **E2EL** — End-to-End Latency per request (s)