module "subnets" {
  source = "./subnets"
  availability_zone = var.availability_zone
  cidr_block = var.cidr_block
  default_vpc_id = var.default_vpc_id
  env = var.env
  name = var.name
  vpc_id = var.vpc_id
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

#resource "aws_subnet" "main" {
#  count         = length(var.cidr_block)
#  cidr_block    = var.cidr_block[count.index]
#  availability_zone = var.availability_zone[count.index]
#  vpc_id        = var.vpc_id
#  tags = merge(
#    local.common_tags,
#    { Name = "${var.env}-${var.name}-subnet-${count.index + 1}" }
#  )
#}
#
#resource "aws_route_table" "route_table" {
#  vpc_id = var.vpc_id
#
#  route {
#    cidr_block        = data.aws_vpc.default.cidr_block
#    vpc_peering_connection_id = var.vpc_peering_connection_id
#  }
#  tags = merge(
#    local.common_tags,
#    { Name = "${var.env}-${var.name}-route_table" }
#  )
#}
#
#resource "aws_route_table_association" "association" {
#  count = length(aws_subnet.main)
#  subnet_id      = aws_subnet.main.*.id[count.index]
#  route_table_id = aws_route_table.route_table.id
#}

#resource "aws_route" "internet_gw_route" {
#  count                     = var.internet_gw ? 1:0
#  route_table_id            = aws_route_table.route_table.id
#  destination_cidr_block    = "0.0.0.0/0"
#  gateway_id = var.internet_gw_id
#}
#
#resource "aws_internet_gateway" "igw" {
#  count                     = var.internet_gw ? 1:0
#  vpc_id = var.vpc_id
#  tags = merge(
#    local.common_tags,
#    { Name = "${var.env}-igw" }
#  )
#}
#
resource "aws_eip" "ngw-eip" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw-eip.id
  subnet_id     = var.public_subnet_ids[0]

  tags = merge(
    local.common_tags,
    { Name = "${var.env}-ngw" }
  )
}