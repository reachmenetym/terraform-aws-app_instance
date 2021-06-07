output "app_public_ips" {
    value = aws_instance.app.*.public_ip
}

output "app_private_ips" {
    value = aws_instance.app.*.private_ip
}

output "app_sg_id" {
    value = aws_security_group.app_sg.id
}