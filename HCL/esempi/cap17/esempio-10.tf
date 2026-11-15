data "archive_file" "pacco" {
  type        = "zip"
  output_path = "${path.module}/pacco.zip"

  dynamic "source" {
    for_each = var.documenti
    content {
      filename = source.key
      content  = source.value
    }
  }

  dynamic "source" {
    for_each = var.note[*]
    content {
      filename = "note.txt"
      content  = source.value
    }
  }
}
