import hcl2

with open("main.tf") as f:
    config = hcl2.load(f)

for blocco in config.get("variable", []):
    for nome, corpo in blocco.items():
        if "description" not in corpo:
            print("Senza descrizione:", nome)
