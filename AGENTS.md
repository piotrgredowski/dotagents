# Agent Notes

## oMLX

**oMLX** is a macOS-native LLM inference server optimized for Apple Silicon. It provides continuous batching, tiered KV caching (hot RAM + cold SSD), and an OpenAI/Anthropic-compatible API. Install via Homebrew or from source (https://github.com/jundot/omlx).

- CLI: `omlx serve --model-dir <path>`
- Admin dashboard: `http://localhost:8000/admin`
- Default port: 8000

### Model Directory

Use `~/.lmstudio/models` as the model directory (shared with LM Studio):

```
omlx serve --model-dir ~/.lmstudio/models
```

Models are discovered from subdirectories automatically. Two-level organization (e.g., `mlx-community/model-name/`) is supported.
