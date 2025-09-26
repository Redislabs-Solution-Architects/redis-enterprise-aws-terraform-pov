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
├── outputs.tf               # Useful outputs (Admin UI, Mgmt API, IPs)
├── terraform.tfvars         # User-specific values (VPC, subnet, keypair, etc.)
└── templates/
    └── user_data.sh.tftpl   # Cloud-init bootstrap script
```

---

## 🚀 Prerequisites

- Terraform >= 1.5
- AWS credentials with permissions for EC2, VPC, and IAM
- An existing AWS VPC + **public subnet**
- An existing **EC2 KeyPair** for SSH access

---

## ⚙️ Configuration

Set values in `terraform.tfvars`:

```hcl
region       = "us-east-1"
vpc_id       = "vpc-xxxxxxxxxxxxxxxxx"
subnet_id    = "subnet-xxxxxxxxxxxxxxxxx"
ssh_key_name = "my-keypair-name"

# optional
suffix        = "gc"                  # Unique suffix per SA to avoid collisions
allowed_cidrs = ["0.0.0.0/0"]         # Restrict to your IP range in production

re_username   = "admin@example.com"
re_password   = "Secret_42"
db_password   = "secret42"
```

---

## ▶️ Deployment

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Terraform will print:

- `admin_ui_url` → Redis Enterprise Admin UI (HTTPS, port 8443)
- `mgmt_api_url` → Management API (HTTPS, port 9443)
- `public_ip` / `private_ip`

Open the **Admin UI** at the provided URL, accept the self-signed certificate, and log in with your username/password.

---

## 🧹 Destroy

```bash
terraform destroy -auto-approve
```

---

## 🔍 Notes

- Uses **IMDSv2** for AWS metadata.
- Security group opens SSH (22), Admin UI (8443), Mgmt API (9443), and Redis DB ports (12000–19999).
- Not production hardened (no TLS certs, no HA).
- Intended for **PoV / testing**.

---

## 📄 License

MIT
