import os
import time
from flask import Flask, Response
import redis
from prometheus_client import (Counter, Histogram,
                               generate_latest,
                               CONTENT_TYPE_LATEST)

app = Flask(__name__)
host = os.environ.get("REDIS_HOST", "localhost")
r = redis.Redis(host=host, port=6379)

RICHIESTE = Counter("http_requests_total",
                    "Richieste HTTP", ["status"])
DURATA = Histogram("http_request_duration_seconds",
                   "Durata richieste")


@app.route("/")
def home():
    inizio = time.time()
    try:
        n = r.incr("visite")
        RICHIESTE.labels(status="200").inc()
        return f"Visite: {n}\n"
    except redis.RedisError:
        RICHIESTE.labels(status="503").inc()
        return "Redis non disponibile\n", 503
    finally:
        DURATA.observe(time.time() - inizio)


@app.route("/healthz")
def healthz():
    return "ok\n"


@app.route("/readyz")
def readyz():
    try:
        r.ping()
        return "ok\n"
    except redis.RedisError:
        return "redis non raggiungibile\n", 503


@app.route("/metrics")
def metrics():
    return Response(generate_latest(),
                    mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
