variable "region" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "ssh_key_name" { type = string }

variable "allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"] # tighten for prod
  description = "CIDRs allowed for SSH/UI/API/DB testing"
}

variable "instance_type" {
  type    = string
  default = "r6i.xlarge"
}
variable "root_volume_gb" {
  type    = number
  default = 32
}

variable "name_prefix" {
  type    = string
  default = "redis-re-pov"
}
variable "tags" {
  type    = map(string)
  default = {}
}

# Redis Enterprise config
variable "redis_version_tar" {
  type    = string
  default = "redislabs-7.22.2-14-rhel9-x86_64"
}
variable "cluster_fqdn" {
  type    = string
  default = "redispov.platformengineer.io"
}
variable "re_username" {
  type    = string
  default = "gabriel.cerioni@redis.com"
}
variable "re_password" {
  type      = string
  sensitive = true
  default   = "Secret_42"
}

variable "create_cluster" {
  type    = bool
  default = true
}
variable "create_db" {
  type    = bool
  default = true
}

variable "db_name" {
  type    = string
  default = "redis-pj-pov"
}
variable "db_password" {
  type      = string
  default   = "secret42"
  sensitive = true
}
variable "db_memory_bytes" {
  type    = number
  default = 21474836480 # 20 GiB
}
variable "shards_count" {
  type    = number
  default = 1
}

variable "db_port" {
  description = "Fixed TCP port for the Redis DB (must be free, typically 12000-19999)."
  type        = number
  default     = 12000
}

variable "suffix" {
  type        = string
  default     = ""
  description = "Optional suffix to differentiate parallel PoC deployments (e.g., SA initials)"
}