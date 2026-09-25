# S3 → SQS → Step Functions → SQS (two regions)

Deploys an independent ingest pipeline in a **primary** and **secondary** region.

```
primary                                           secondary
S3 → input SQS → starter → my_sfn → output SQS    S3 → input SQS → starter → my_sfn → output SQS
```

```bash
cp terraform.tfvars.example terraform.tfvars
# primary / secondary must match the credential partition
terraform init
terraform apply
```

GovCloud:

```hcl
primary   = "us-gov-west-1"
secondary = "us-gov-east-1"
```

Commercial:

```hcl
primary   = "us-west-2"
secondary = "us-east-1"
```
