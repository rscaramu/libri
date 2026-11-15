locals {
  server = [
    {
      nome  = "web"
      porte = [80, 443]
    },
    {
      nome  = "db"
      porte = [5432]
    },
  ]
}
