FROM ghcr.io/google/gemini-cli:latest

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
