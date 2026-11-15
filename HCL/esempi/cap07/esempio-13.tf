locals {
  cpu = (
    var.taglia == "piccola" ? 1 :
    var.taglia == "media" ? 2 :
    var.taglia == "grande" ? 4 :
    8
  )
}
