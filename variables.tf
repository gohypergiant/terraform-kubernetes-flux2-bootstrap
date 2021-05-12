variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster. Used to fetch authentication details."
}

variable "flux_git_branch" {
  type        = string
  default     = "stable"
  description = "flux git branch name"
}

variable "flux_git_email" {
  type        = string
  default     = "flux@localhost"
  description = "flux git email"
}

variable "flux_git_url" {
  type        = string
  description = "flux git url"
}

variable "flux_git_path" {
  type        = string
  default     = ""
  description = "Path within git repo to locate Kubernetes manifests (relative path)"
}

variable "flux_sync_interval" {
  type        = string
  default     = "5m"
  description = "Flux sync interval"
}

variable "flux_ssh_known_hosts" {
  type        = string
  default     = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
  description = "SSH known hosts used to access private helm repos via git SSH. See https://github.com/fluxcd/helm-operator/blob/master/chart/helm-operator/README.md#use-a-private-git-server"
}

variable "flux_deploy_image_automation" {
  type        = bool
  default     = false
  description = "Optionally deploy the image automation controller with the gitops toolkit"
}