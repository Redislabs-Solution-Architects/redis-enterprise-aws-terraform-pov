# Redis Enterprise on AWS with Terraform

This project deploys a **Redis Enterprise** single-node PoV environment on AWS using Terraform.  
It provisions an EC2 instance (default: `r6i.xlarge` with 32 GB gp3 root disk), installs Redis Enterprise on RHEL 9, creates a single-node cluster, and optionally provisions a Redis database.

---

## 📂 Project Structure

```
.
├── versions.tf              # Terraform + provider versions
├── providers.tf             # AWS provider
├── variables.tf             # Input variables
├── locals.tf                # Auto tags, name prefix, suffix
├── data-ami.tf              # Lookup latest RHEL 9 AMI
├── sg.tf                    # Security group for Redis Enterprise
├── ec2.tf                   # EC2 instance and user_data
├── outputs.tf               # Useful outputs (Admin UI, Mgmt API, IPs, creds)
├── terraform.tfvars         # User-specific values (VPC, subnet, keypair, etc.)
└── templates/
    └── user_data.sh.tftpl   # Cloud-init bootstrap script
```

---

## 🚀 Prerequisites

- Terraform ≥ 1.5
- AWS credentials with permissions for EC2 + networking
- An existing AWS VPC + **public subnet**
- An existing **EC2 KeyPair** for SSH access

---

## ⚙️ Configuration

Set values in **terraform.tfvars** (sample):

```hcl
region       = "us-east-1"
vpc_id       = "vpc-xxxxxxxxxxxxxxxxx"
subnet_id    = "subnet-xxxxxxxxxxxxxxxxx"
ssh_key_name = "my-keypair-name"

# Optional
suffix        = "gc"                  # Unique suffix per SA to avoid collisions
allowed_cidrs = ["0.0.0.0/0"]         # Restrict to your IP range in production

# Redis Enterprise
redis_version_tar = "redislabs-7.22.2-14-rhel9-x86_64"
cluster_fqdn      = "mycluster.example.com"
re_username       = "admin@example.com"
re_password       = "Secret_42"

# DB (created only if create_db = true)
db_name         = "redis-pj-pov"
db_password     = "secret42"
db_memory_bytes = 21474836480
shards_count    = 1

# Toggles
create_cluster = true
create_db      = true
```

---

## ▶️ Deploy

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

### What you’ll see in the outputs
- `admin_ui_url` → Redis Enterprise Admin UI (port 8443, HTTPS)
- `mgmt_api_url` → Management API (port 9443, HTTPS)
- `instance_id`, `instance_name`
- `public_ip`, `private_ip`
- `re_username` (for the UI/API login)
- `db_name`, `db_password`, `db_port` (if DB creation is enabled)

Open the **Admin UI** at the provided URL, accept the self‑signed cert, and log in with the username/password from the outputs.

---

## 🔎 Follow the bootstrap in real time

SSH into the instance and tail the cloud-init output:

```bash
ssh -i <your-key>.pem ec2-user@<public_ip>
sudo -i
tail -f /var/log/cloud-init-output.log
```

The custom bootstrap also logs to:

```bash
tail -f /var/log/redis-enterprise-init.log
```

---

## 🧹 Destroy

```bash
terraform destroy -auto-approve
```

---

## ⚠️ Notes

- Uses IMDSv2 for metadata.
- Security group opens: SSH (22), Admin UI (8443), Mgmt API (9443), Redis DB ports (12000–19999).
- This is a **PoV/test** setup (no TLS cert management, single node, no HA).
- The `user_data.sh.tftpl` strictly follows the sequence: bootstrap → install → create cluster (optional) → create DB via API (optional).

---

## 📄 License

MIT
