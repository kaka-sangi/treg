FROM node:22-bookworm-slim AS web
WORKDIR /app
COPY . .
RUN bash scripts/build-dashboard.sh

FROM python:3.12-slim
ENV PYTHONUNBUFFERED=1 \
    PORT=3000 \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/app/.venv \
    PATH=/app/.venv/bin:$PATH
RUN pip install --no-cache-dir uv==0.12.3
WORKDIR /app
COPY --from=web /app /app
RUN uv sync --locked --no-dev --extra server
EXPOSE 3000
CMD ["python", "-m", "treg"]
