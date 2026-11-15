locals {
  repliche_per_ambiente = {
    produzione = 3
    collaudo   = 2
  }
  repliche = lookup(
    local.repliche_per_ambiente,
    terraform.workspace,
    1
  )
}
