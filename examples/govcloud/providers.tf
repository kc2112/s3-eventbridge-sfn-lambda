provider "aws" {
  region = var.primary

  default_tags {
    tags = {
      Project     = "s3-eventbridge-sfn-lambda"
      Environment = "govcloud"
      ManagedBy   = "terraform"
    }
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary

  default_tags {
    tags = {
      Project     = "s3-eventbridge-sfn-lambda"
      Environment = "govcloud"
      ManagedBy   = "terraform"
    }
  }
}
