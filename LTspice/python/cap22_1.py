import sqlite3, statistics as st
db = sqlite3.connect("c22_mc.db")
v = [r[0] for r in db.execute(
    "SELECT r.AT FROM Results r JOIN Measurements m "
    "ON m.ID = r.ID WHERE m.Name = 'fc'")]
print(len(v), st.mean(v), st.stdev(v), min(v), max(v))
