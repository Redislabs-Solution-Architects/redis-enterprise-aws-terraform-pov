output "instance_id" {
  value = aws_instance.redis_re.id
}

output "instance_name" {
  description = "Name tag applied to the EC2 instance"
  value       = local.effective_prefix
}

output "public_ip" {
  value = aws_instance.redis_re.public_ip
}

output "private_ip" {
  value = aws_instance.redis_re.private_ip
}

output "admin_ui_url" {
  value = "https://${aws_instance.redis_re.public_ip}:8443"
}

output "admin_ui_user" {
  description = "Username to log into the Redis Enterprise Admin UI"
  value       = var.re_username
}

output "mgmt_api_url" {
  value = "https://${aws_instance.redis_re.private_ip}:9443"
}

output "db_name" {
  description = "Redis Enterprise DB name created in the cluster"
  value       = var.db_name
}

output "db_password" {
  description = "Redis Enterprise DB password"
  value       = var.db_password
  sensitive   = true
}

output "db_port" {
  description = "Fixed port used by the Redis DB"
  value       = var.db_port
}

output "redis_uri" {
  description = "Connection string (no TLS)."
  value       = "redis://:${var.db_password}@${aws_instance.redis_re.private_ip}:${var.db_port}"
  sensitive   = true
}