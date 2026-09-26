import os
from flask import Flask
import redis

app = Flask(__name__)
host = os.environ.get("REDIS_HOST", "localhost")
r = redis.Redis(host=host, port=6379)


@app.route("/")
def home():
    n = r.incr("visite")
    return f"Visite: {n}\n"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
