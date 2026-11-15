# Commento su una riga: la forma consigliata.
// Commento su una riga, alternativa ammessa.
/* Commento che puo' estendersi
   su piu' righe. */
resource "local_file" "nota" {
  filename = "nota.txt" # un commento puo' seguire il codice
  content  = "testo"
}
