output "github_deploy_key" {
  description = "The TLS key to add as a deploy key to any private github repos"
  value       = tls_private_key.main.public_key_openssh
}