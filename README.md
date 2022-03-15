# Terraform Module Template

[![Hypergiant](https://i.imgur.com/cLjriJj.jpg)](https://www.hypergiant.com/)

## How do you use this Module?

This module provisions Flux2 onto an EKS cluster and emits the public key to add to Github as an output.

### Example

```HCL
// always initialize providers OUTSIDE the module or else you're gonna have a bad time
data "aws_eks_cluster" "demo" {
  name = module.demo_eks.cluster_id
}

data "aws_eks_cluster_auth" "demo" {
  name = module.demo_eks.cluster_id
}

provider "kubectl" {
  alias                  = "flux2-kubectl"
  host                   = data.aws_eks_cluster.demo.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.demo.token
}

provider "kubernetes" {
  alias                  = "flux2-kubernetes"
  host                   = data.aws_eks_cluster.demo.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.demo.token
}

provider "tls" {
  alias = "flux2-tls"
}

provider "flux" {
  alias = "flux2-flux"
}


module "demo_eks" {
  // deploy your EKS cluster as usual
  source    = "terraform-aws-modules/eks/aws"

  // make sure to explicitly use the same provider to allow for multiple clusters in the same state
  providers = {
    kubernetes = kubernetes.flux2-kubernetes
  }
}

module "flux2-bootstrap" {
  source  = "app.terraform.io/Hypergiant/flux2-bootstrap/kubernetes"
  version = "~> 0.1.0"

  // Pass providers in explicitly to allow for multiple clusters
  providers = {
    kubernetes = kubernetes.flux2-kubernetes
    kubectl    = kubectl.flux2-kubectl
    flux       = flux.flux2-flux
    tls        = tls.flux2-tls
  }

  // Required inputs
  cluster_name = "demo"
  flux_git_url = "ssh://git@github.com/gohypergiant/flux-demo.git"

  // Optional Inputs
  flux_git_path            = "common//,demo"
  flux_git_email           = "demo@hypergiant.com"
  flux_git_branch          = "main"
  flux_ssh_known_hosts     = "your.private.git.server.io ssh-rsa AAAAB...."
  flux_sync_interval       = "5m"
  flux_deploy_image_auto   mation = true
  private_key_algorithm    = "rsa"
  private_key_rsa_bits     = 2048
  private_key_ecdsa_curve  = "P224"
}
```

## What's a Module?

A Module is a canonical, reusable, best-practices definition for how to run a single piece of infrastructure, such as a database or server cluster. Each Module is created primarily using [Terraform](https://www.terraform.io/), includes automated tests, examples, and documentation, and is maintained both by the open source community and companies that provide commercial support.

Instead of having to figure out the details of how to run a piece of infrastructure from scratch, you can reuse existing code that has been proven in production. And instead of maintaining all that infrastructure code yourself, you can leverage the work of the Module community and maintainers, and pick up infrastructure improvements through a version number bump.

## Who maintains this Module?

This module is maintained by the Hypergiant Infrastructure Engineering Team

## How is this Module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release,
along with the changelog, in the [Releases Page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR, MINOR, and PATCH versions on each release to indicate any incompatibilities.

## Contributing

See our [Contributing Guidelines](contributing.md)

## License
This repository is licensed under [Apache 2.0](LICENSE.md)

