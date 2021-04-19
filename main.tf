# Generate manifests
data "flux_install" "main" {
  target_path = var.flux_git_path
}

data "flux_sync" "main" {
  target_path = var.flux_git_path
  url         = var.flux_git_url
  branch      = var.flux_git_branch
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

// 
data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

# Convert documents list from the datasource to include parsed yaml data
locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

// The group of manifests to deploy flux2's basic components
resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

// Note: Workaround unless support for adding the IRSA ARN is added to the flux2 provider: https://github.com/fluxcd/terraform-provider-flux/issues/120. We are removing the kustomize SA from the collection of 
resource "kubectl_manifest" "apply" {
  for_each   = { for v in data.kustomization_overlay.example.manifests : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content if anytrue([v.data.kind != "ServiceAccount", v.data.metadata.name != "kustomize-controller"]) }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

resource "kubernetes_service_account" "kustomize_controller" {
  metadata {
    name      = "kustomize-controller"
    namespace = "flux-system"
    labels = {
      "app.kubernetes.io/instance" = "flux-system"
      "app.kubernetes.io/part-of"  = "flux"
      "app.kubernetes.io/version"  = data.install.main.version
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = var.flux_sops_kms_create ? aws_kms_key.this.arn : ""
    }
  }
}

// The group of manifests to initialize the flux state repo
resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}


// Manage the secret used by flux to 
resource "kubernetes_secret" "main" {
  depends_on = [kubectl_manifest.install]

  metadata {
    name      = data.flux_sync.main.secret
    namespace = data.flux_sync.main.namespace
  }

  data = {
    identity       = tls_private_key.main.private_key_pem
    "identity.pub" = tls_private_key.main.public_key_pem
    known_hosts    = var.flux_ssh_known_hosts
  }
}
