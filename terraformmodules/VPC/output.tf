output "publicSubnets-ids" {
    value = [for subnet in aws_subnet.pub : subnet.id]
}
output "PrivateSubnets-ids" {
    value = [for subnet in aws_subnet.priv : subnet.id]
}

output "vpcid" {
  value = aws_vpc.lab3.id
}
