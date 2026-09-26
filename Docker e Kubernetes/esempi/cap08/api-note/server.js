const express = require("express");
const app = express();
app.use(express.json());

const note = [];

app.get("/note", (req, res) => res.json(note));
app.post("/note", (req, res) => {
  const n = { id: note.length + 1, testo: req.body.testo };
  note.push(n);
  res.status(201).json(n);
});

const porta = process.env.PORT || 3000;
app.listen(porta, () => console.log(`API su porta ${porta}`));
