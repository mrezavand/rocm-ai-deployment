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

