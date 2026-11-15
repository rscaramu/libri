check "file_presente" {
  assert {
    condition     = fileexists("${path.module}/licenza.txt")
    error_message = "Il file licenza.txt non esiste."
  }
}
