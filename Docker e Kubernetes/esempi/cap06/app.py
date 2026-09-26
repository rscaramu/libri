import os
from pathlib import Path
from flask import Flask

app = Flask(__name__)
FILE = Path(os.environ.get("DATI", "/dati")) / "visite.txt"


@app.route("/")
def home():
    n = int(FILE.read_text()) if FILE.exists() else 0
    n += 1
    FILE.parent.mkdir(parents=True, exist_ok=True)
    FILE.write_text(str(n))
    return f"Visite: {n}\n"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
