import time

from flask import Flask, Response, jsonify
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

app = Flask(__name__)

REQUESTS = Counter("app_requests_total", "Total HTTP requests", ["endpoint"])


@app.get("/")
def index():
    REQUESTS.labels(endpoint="/").inc()
    return jsonify(message="Hello from EKS GitOps platform")


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


@app.get("/stress/memory/<int:mb>")
def stress_memory(mb):
    # Test only: holds <mb> MB for 10 seconds (capped at 200)
    mb = min(mb, 200)
    data = b"x" * (mb * 1024 * 1024)
    time.sleep(10)
    return jsonify(allocated_mb=len(data) // (1024 * 1024))