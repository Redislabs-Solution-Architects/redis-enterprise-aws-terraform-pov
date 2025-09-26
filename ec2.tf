resource "aws_instance" "redis_re" {
  ami                         = data.aws_ami.rhel9.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.redis_re.id]
  associate_public_ip_address = true
  key_name                    = var.ssh_key_name

  root_block_device {
    volume_size = var.root_volume_gb
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    redis_version_tar = var.redis_version_tar
    cluster_fqdn      = var.cluster_fqdn
    re_username       = var.re_username
    re_password       = var.re_password
    create_cluster    = var.create_cluster
    create_db         = var.create_db
    db_name           = var.db_name
    db_password       = var.db_password
    db_memory_bytes   = var.db_memory_bytes
    shards_count      = var.shards_count
    db_port           = var.db_port
  })

  # Name tag already included via local.common_tags; it resolves to local.effective_prefix
  tags = local.common_tags
}