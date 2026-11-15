module "saluto" {
  source = "./modules/saluto"
  nome   = "classe 5A"
}

output "messaggio" {
  value = module.saluto.messaggio
}
