// Copyright 2020 Hypergiant, LLC

provider "aws" {
  region = var.region
}

module "this" {
  source = "../../"
}
