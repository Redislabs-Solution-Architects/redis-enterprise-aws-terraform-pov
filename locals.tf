locals {
  # Construct a unique name prefix with optional suffix
  effective_prefix = (
    var.suffix != "" ?
    "${var.name_prefix}-${var.suffix}" :
    var.name_prefix
  )

  auto_tags = {
    Environment = "poc"
    Region      = var.region
  }

  common_tags = merge(
    local.auto_tags,
    var.tags,
    { Name = local.effective_prefix }
  )
}