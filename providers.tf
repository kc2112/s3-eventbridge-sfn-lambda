provider "aws" {
  region = var.primary

  default_tags {
    tags = merge(var.tags, { RegionRole = "primary" })
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary

  default_tags {
    tags = merge(var.tags, { RegionRole = "secondary" })
  }
}
