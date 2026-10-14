import sqlite3
db = sqlite3.connect("specchio.db")
q = ("SELECT s.Value, r.Re FROM Results r "
     "JOIN Steps s ON s.Step = r.Step "
     "JOIN Measurements m ON m.ID = r.ID "
     "WHERE m.Name = 'rout'")
for valore, rout in db.execute(q):
    print(valore, rout)
