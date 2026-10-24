# ---------- Build stage ----------
# Python 3.11 to match the distroless debian12 runtime
FROM python:3.11-slim AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/app/deps -r requirements.txt
COPY main.py .

# ---------- Runtime stage ----------
# Distroless: no shell, no package manager, runs as non-root
FROM gcr.io/distroless/python3-debian12:nonroot
WORKDIR /app
COPY --from=build /app /app
ENV PYTHONPATH=/app/deps
EXPOSE 8080
USER nonroot
ENTRYPOINT ["python3", "-m", "gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "main:app"]
