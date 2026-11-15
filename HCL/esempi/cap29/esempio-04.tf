resource "aws_subnet" "privata" {
  vpc_id            = aws_vpc.rete.id
  cidr_block        = cidrsubnet(aws_vpc.rete.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.zone.names[1]
}
