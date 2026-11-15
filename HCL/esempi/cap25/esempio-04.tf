resource "terraform_data" "ritardo" {
  # Il DNS impiega fino a 60 secondi a propagare il record:
  # senza questa attesa il certificato non si convalida.
  # Vedi il verbale del 12 marzo.
  input = "60s"
}
