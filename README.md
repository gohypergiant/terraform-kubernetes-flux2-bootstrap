# Terraform Module Template

[![Hypergiant](https://i.imgur.com/cLjriJj.jpg)](https://www.hypergiant.com/)

This repository represents the basic skeleton of a Terraform module at Hypergiant.

### What's in the box?
- Github Actions
- File structure for your module
- Unit tests
- File structure for examples (that will be unit tested)

### What do I do?
- Change this section
- Write your module
- Keep your example in `examples/complete` up to date
- Add your AWS IAM creds to the repo's secrets so unit tests can run. Use TF Unit Test User in LastPass.
- Once your base functionality is done and it passes tests, deploy it in Terraform Cloud
- Update your input and output interfaces using `terraform-docs markdown .` on changes to variables

## How do you use this Module?

### Requirements

No requirements.

### Providers

No provider.

### Inputs

No input.

### Outputs

No output.

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

