import os
from flask import Flask

app = Flask(__name__)
visite = 0


@app.route("/")
def home():
    global visite
    visite += 1
    nome = os.environ.get("NOME", "mondo")
    return f"Ciao, {nome}! Visite: {visite}\n"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
