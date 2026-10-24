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
