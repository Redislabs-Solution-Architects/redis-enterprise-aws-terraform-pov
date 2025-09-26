output "instance_id" { value = aws_instance.redis_re.id }
output "public_ip" { value = aws_instance.redis_re.public_ip }
output "private_ip" { value = aws_instance.redis_re.private_ip }
output "admin_ui_url" { value = "https://${aws_instance.redis_re.public_ip}:8443" }
output "mgmt_api_url" { value = "https://${aws_instance.redis_re.private_ip}:9443" }